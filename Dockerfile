# ============================================
# Hexo 博客多阶段构建 Dockerfile
# 作者: CJX
# 项目: SMLYFM.github.io
# ============================================

# ============================================
# 阶段1: 构建阶段 (Node.js 环境)
# ============================================
FROM node:18-alpine AS builder

# 💡 设置中国大陆镜像加速（可选，取消注释启用）
# RUN npm config set registry https://registry.npmmirror.com

WORKDIR /app

# 💡 先复制依赖文件，利用 Docker 缓存层
# 只有 package*.json 变化时才重新安装依赖
COPY package*.json ./

# 安装生产依赖
RUN npm ci --only=production

# 复制项目源码
COPY . .

# 构建静态文件
RUN npm run build

# ============================================
# 阶段2: 运行阶段 (轻量级 Nginx)
# ============================================
FROM nginx:alpine

LABEL maintainer="SMLYFM <yytcjx@gmail.com>"
LABEL description="SMLYFM Blog - Hexo Static Site"
LABEL version="1.0"

# 复制自定义 Nginx 配置
COPY docker/nginx.conf /etc/nginx/nginx.conf

# 从构建阶段复制静态文件到 Nginx 目录
COPY --from=builder /app/public /usr/share/nginx/html

# 暴露端口
EXPOSE 80 443

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1

# 💡 以非守护进程模式运行 Nginx
CMD ["nginx", "-g", "daemon off;"]
