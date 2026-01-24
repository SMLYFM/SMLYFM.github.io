# 服务器与容器化部署指南

本文档介绍如何将 Hexo 博客部署到自有服务器、Docker 或 Podman 容器环境。

## 📋 目录

- [部署方式对比](#部署方式对比)
- [方式一：服务器直接部署](#方式一服务器直接部署)
- [方式二：Docker 部署](#方式二docker-部署)
- [方式三：Podman 部署](#方式三podman-部署)
- [高级配置](#高级配置)
- [故障排查](#故障排查)

---

## 部署方式对比

| 特性 | 服务器直接部署 | Docker | Podman |
|------|--------------|--------|--------|
| **复杂度** | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| **隔离性** | ❌ 低 | ✅ 高 | ✅ 高 |
| **可移植性** | ❌ 低 | ✅ 高 | ✅ 高 |
| **资源占用** | ✅ 最小 | 🟡 中等 | 🟡 中等 |
| **安全性** | 🟡 依赖配置 | ✅ 良好 | ✅ 更好（无守护进程） |
| **Fedora 推荐** | 一般 | 一般 | ⭐ 推荐 |

---

## 方式一：服务器直接部署

### 适用场景

- VPS 或云服务器（阿里云、腾讯云、AWS 等）
- 已有 Nginx/Apache 配置的环境
- 希望最小化资源占用

### 前置要求

- Linux 服务器（推荐 Ubuntu/Debian 或 Fedora）
- **Nginx** 或 **Apache** Web 服务器
- （可选）域名 + SSL 证书

### 快速部署脚本

在服务器上执行：

```bash
#!/bin/bash
# 💡 deploy-to-server.sh - 服务器快速部署脚本

# 配置区 - 根据实际情况修改
DEPLOY_USER="www-data"
DEPLOY_DIR="/var/www/blog"
BLOG_DOMAIN="yourdomain.com"

# 创建部署目录
sudo mkdir -p $DEPLOY_DIR
sudo chown $USER:$USER $DEPLOY_DIR

# 同步静态文件（从本地构建后上传）
# 方法1: 使用 rsync（推荐）
rsync -avz --delete ./public/ user@server:$DEPLOY_DIR/

# 方法2: 使用 scp
# scp -r ./public/* user@server:$DEPLOY_DIR/
```

### 步骤详解

#### 1. 本地构建

```bash
# 在本地项目目录
make build
# 或
npm run build
```

生成的静态文件位于 `public/` 目录。

#### 2. 上传到服务器

**方法一：rsync（推荐，增量同步）**

```bash
# 首次配置 SSH 免密登录
ssh-copy-id user@your-server-ip

# 同步静态文件
rsync -avz --delete ./public/ user@your-server-ip:/var/www/blog/
```

**方法二：使用 Makefile**

在 `Makefile` 中添加：

```makefile
# 服务器部署配置
SERVER_USER := your-username
SERVER_HOST := your-server-ip
SERVER_PATH := /var/www/blog

.PHONY: deploy-server
deploy-server: build  ## 部署到自有服务器
 @echo "📦 正在上传到服务器..."
 rsync -avz --delete ./public/ $(SERVER_USER)@$(SERVER_HOST):$(SERVER_PATH)/
 @echo "✅ 部署完成!"
```

使用：

```bash
make deploy-server
```

#### 3. 配置 Nginx

创建 `/etc/nginx/sites-available/blog.conf`:

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    
    # 重定向到 HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;
    
    # SSL 证书配置（Let's Encrypt）
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    
    # 网站根目录
    root /var/www/blog;
    index index.html;
    
    # Gzip 压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
    gzip_min_length 1000;
    
    # 静态资源缓存
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
    
    # 主路由
    location / {
        try_files $uri $uri/ =404;
    }
    
    # 错误页面
    error_page 404 /404.html;
}
```

启用配置：

```bash
sudo ln -s /etc/nginx/sites-available/blog.conf /etc/nginx/sites-enabled/
sudo nginx -t  # 测试配置
sudo systemctl reload nginx
```

#### 4. 配置 SSL 证书（Let's Encrypt）

```bash
# 安装 Certbot
sudo dnf install certbot python3-certbot-nginx  # Fedora
# 或
sudo apt install certbot python3-certbot-nginx  # Ubuntu/Debian

# 获取证书并自动配置 Nginx
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# 设置自动续期
sudo systemctl enable certbot-renew.timer
```

---

## 方式二：Docker 部署

### 适用场景

- 需要可移植、可复制的部署环境
- CI/CD 自动化部署
- 多应用隔离运行

### 项目 Dockerfile

在项目根目录创建 `Dockerfile`:

```dockerfile
# ============================================
# 多阶段构建：Hexo 博客 Docker 镜像
# ============================================

# 阶段1: 构建阶段
FROM node:18-alpine AS builder

WORKDIR /app

# 💡 先复制依赖文件，利用 Docker 缓存层
COPY package*.json ./

# 安装依赖
RUN npm ci --only=production

# 复制源码
COPY . .

# 构建静态文件
RUN npm run build

# ============================================
# 阶段2: 运行阶段（使用轻量级 Nginx）
# ============================================
FROM nginx:alpine

# 复制自定义 Nginx 配置
COPY docker/nginx.conf /etc/nginx/nginx.conf

# 从构建阶段复制静态文件
COPY --from=builder /app/public /usr/share/nginx/html

# 暴露端口
EXPOSE 80 443

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
```

### 创建 Nginx 配置

创建 `docker/nginx.conf`:

```nginx
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent"';
    
    access_log /var/log/nginx/access.log main;
    
    sendfile on;
    keepalive_timeout 65;
    
    # Gzip 压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_proxied any;
    gzip_types text/plain text/css application/json application/javascript 
               text/xml application/xml application/xml+rss text/javascript;
    
    server {
        listen 80;
        server_name localhost;
        
        root /usr/share/nginx/html;
        index index.html;
        
        # 静态资源长期缓存
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
            expires 30d;
            add_header Cache-Control "public, immutable";
        }
        
        location / {
            try_files $uri $uri/ =404;
        }
        
        error_page 404 /404.html;
    }
}
```

### Docker 命令

#### 构建镜像

```bash
docker build -t smlyfm-blog:latest .
```

#### 运行容器

```bash
# 基本运行
docker run -d --name blog -p 80:80 smlyfm-blog:latest

# 带日志持久化
docker run -d --name blog \
    -p 80:80 \
    -v ./logs:/var/log/nginx \
    smlyfm-blog:latest
```

#### 更新部署

```bash
# 重新构建
docker build -t smlyfm-blog:latest .

# 停止旧容器
docker stop blog && docker rm blog

# 启动新容器
docker run -d --name blog -p 80:80 smlyfm-blog:latest
```

### Docker Compose（推荐）

创建 `docker-compose.yml`:

```yaml
version: '3.8'

services:
  blog:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: smlyfm-blog
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./logs:/var/log/nginx
      # 可选：挂载 SSL 证书
      # - /etc/letsencrypt:/etc/letsencrypt:ro
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost/"]
      interval: 30s
      timeout: 3s
      retries: 3
    networks:
      - webnet

networks:
  webnet:
    driver: bridge
```

使用：

```bash
# 构建并启动
docker compose up -d --build

# 查看日志
docker compose logs -f blog

# 停止
docker compose down

# 更新部署
docker compose up -d --build
```

### Makefile 集成

```makefile
# Docker 部署相关
DOCKER_IMAGE := smlyfm-blog
DOCKER_TAG := latest

.PHONY: docker-build
docker-build:  ## 构建 Docker 镜像
 docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

.PHONY: docker-run
docker-run: docker-build  ## 运行 Docker 容器
 docker run -d --name blog -p 80:80 $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: docker-stop
docker-stop:  ## 停止 Docker 容器
 docker stop blog && docker rm blog

.PHONY: docker-logs
docker-logs:  ## 查看 Docker 日志
 docker logs -f blog

.PHONY: docker-compose-up
docker-compose-up:  ## 使用 Docker Compose 启动
 docker compose up -d --build

.PHONY: docker-compose-down
docker-compose-down:  ## 使用 Docker Compose 停止
 docker compose down
```

---

## 方式三：Podman 部署

> **💡 Fedora 用户推荐**：Podman 是 Fedora 默认的容器运行时，无需守护进程，更安全。

### Podman vs Docker

| 特性 | Docker | Podman |
|------|--------|--------|
| 守护进程 | 需要 (dockerd) | 无需 |
| 权限 | 默认需要 root | 支持 rootless |
| 兼容性 | - | 兼容 Docker CLI |
| systemd 集成 | 一般 | 原生支持 |

### 安装 Podman（Fedora）

```bash
# Fedora 43 默认已安装，如未安装：
sudo dnf install podman podman-compose
```

### Podman 命令

Podman 命令与 Docker 几乎完全兼容：

```bash
# 构建镜像
podman build -t smlyfm-blog:latest .

# 运行容器
podman run -d --name blog -p 80:80 smlyfm-blog:latest

# 查看运行中的容器
podman ps

# 查看日志
podman logs -f blog

# 停止并删除
podman stop blog && podman rm blog
```

### Rootless 模式运行

```bash
# 无需 sudo，使用非特权端口
podman run -d --name blog -p 8080:80 smlyfm-blog:latest

# 访问 http://localhost:8080
```

### Podman Compose

```bash
# 使用 podman-compose（与 docker-compose.yml 兼容）
podman-compose up -d --build

# 停止
podman-compose down
```

### Systemd 集成（生产环境推荐）

自动生成 systemd 服务文件：

```bash
# 先创建并运行容器
podman run -d --name blog -p 80:80 smlyfm-blog:latest

# 生成用户级 systemd 服务
mkdir -p ~/.config/systemd/user
podman generate systemd --name blog --files --new
mv container-blog.service ~/.config/systemd/user/

# 重新加载 systemd
systemctl --user daemon-reload

# 启用开机自启
systemctl --user enable container-blog.service

# 管理服务
systemctl --user start container-blog   # 启动
systemctl --user stop container-blog    # 停止
systemctl --user restart container-blog # 重启
systemctl --user status container-blog  # 状态

# 使用户服务在登出后仍运行
loginctl enable-linger $USER
```

### Podman Quadlet（Fedora 推荐）

Fedora 43 支持 Quadlet，更简洁的 systemd 集成：

创建 `~/.config/containers/systemd/blog.container`:

```ini
[Unit]
Description=SMLYFM Blog Container
After=local-fs.target

[Container]
Image=localhost/smlyfm-blog:latest
PublishPort=8080:80
AutoUpdate=registry

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=default.target
```

启用：

```bash
systemctl --user daemon-reload
systemctl --user start blog
systemctl --user enable blog
```

### Makefile Podman 集成

```makefile
# Podman 部署相关
.PHONY: podman-build
podman-build:  ## 构建 Podman 镜像
 podman build -t smlyfm-blog:latest .

.PHONY: podman-run
podman-run: podman-build  ## 运行 Podman 容器
 podman run -d --name blog -p 8080:80 smlyfm-blog:latest

.PHONY: podman-stop
podman-stop:  ## 停止 Podman 容器
 podman stop blog && podman rm blog

.PHONY: podman-logs
podman-logs:  ## 查看 Podman 日志
 podman logs -f blog

.PHONY: podman-systemd
podman-systemd:  ## 生成 Systemd 服务文件
 podman generate systemd --name blog --files --new
 @echo "移动文件到 ~/.config/systemd/user/ 后执行:"
 @echo "systemctl --user daemon-reload"
 @echo "systemctl --user enable container-blog.service"
```

---

## 高级配置

### 1. 多环境配置

创建 `.env` 文件：

```bash
# .env.production
BLOG_PORT=80
BLOG_DOMAIN=yourdomain.com
```

Docker Compose 中使用：

```yaml
services:
  blog:
    ports:
      - "${BLOG_PORT:-80}:80"
```

### 2. 反向代理 + SSL（Traefik）

```yaml
version: '3.8'

services:
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.letsencrypt.acme.httpchallenge=true"
      - "--certificatesresolvers.letsencrypt.acme.email=your@email.com"
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./letsencrypt:/letsencrypt

  blog:
    build: .
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.blog.rule=Host(`yourdomain.com`)"
      - "traefik.http.routers.blog.entrypoints=websecure"
      - "traefik.http.routers.blog.tls.certresolver=letsencrypt"
```

### 3. CI/CD 自动部署

创建 `.github/workflows/docker-deploy.yml`:

```yaml
name: Docker Build and Deploy

on:
  push:
    branches: [master]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: yourusername/smlyfm-blog:latest
      
      - name: Deploy to Server
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            docker pull yourusername/smlyfm-blog:latest
            docker stop blog || true
            docker rm blog || true
            docker run -d --name blog -p 80:80 yourusername/smlyfm-blog:latest
```

---

## 故障排查

### 问题1：容器无法启动

```bash
# 查看详细日志
docker logs blog
# 或
podman logs blog

# 交互式调试
docker run -it --rm smlyfm-blog:latest /bin/sh
```

### 问题2：端口被占用

```bash
# 查看端口占用
sudo lsof -i :80

# 使用其他端口
docker run -d -p 8080:80 smlyfm-blog:latest
```

### 问题3：构建失败

```bash
# 清理构建缓存
docker builder prune

# 无缓存构建
docker build --no-cache -t smlyfm-blog:latest .
```

### 问题4：Podman rootless 权限问题

```bash
# 允许绑定低端口
sudo sysctl net.ipv4.ip_unprivileged_port_start=80

# 持久化
echo "net.ipv4.ip_unprivileged_port_start=80" | sudo tee /etc/sysctl.d/99-unprivileged-ports.conf
```

---

## 快速参考

### 一键命令

```bash
# 服务器部署
make deploy-server

# Docker 部署
docker compose up -d --build

# Podman 部署
podman-compose up -d --build
```

### 目录结构

```
project/
├── Dockerfile            # Docker 镜像定义
├── docker-compose.yml    # Docker Compose 配置
├── docker/
│   └── nginx.conf        # Nginx 配置
├── public/               # 构建输出（静态文件）
└── docs/
    └── SERVER_DEPLOYMENT.md  # 本文档
```

---

**更新日期**: 2026-01-25  
**作者**: CJX  
**项目**: SMLYFM.github.io
