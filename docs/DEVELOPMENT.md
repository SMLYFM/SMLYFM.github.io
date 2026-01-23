# 开发指南

本文档介绍如何在本地开发和维护这个Hexo博客项目。

## 目录

- [环境要求](#环境要求)
- [快速开始](#快速开始)
- [开发工作流](#开发工作流)
- [项目结构](#项目结构)
- [常用命令](#常用命令)
- [配置说明](#配置说明)
- [调试技巧](#调试技巧)

---

## 环境要求

### 必需软件

- **Node.js**: >= 14.0.0 (推荐使用LTS版本)
- **npm**: >= 6.0.0
- **Git**: >= 2.0.0

### 推荐工具

- **编辑器**: VS Code / Neovim (推荐使用EditorConfig插件)
- **终端**: 支持bash的终端

### 验证环境

```bash
node --version   # v18.x.x
npm --version    # 9.x.x
git --version    # 2.x.x
```

---

## 快速开始

### 1. 克隆仓库

```bash
# 使用SSH (推荐)
git clone git@github_yytcjx:SMLYFM/SMLYFM.github.io.git
cd SMLYFM.github.io

# 或使用HTTPS
git clone https://github.com/SMLYFM/SMLYFM.github.io.git
cd SMLYFM.github.io
```

### 2. 切换到master分支

```bash
git checkout master
```

### 3. 安装依赖

```bash
npm install
```

### 4. 启动本地服务器

```bash
# 方式1: 使用npm脚本
npm run dev

# 方式2: 使用预览脚本 (推荐)
npm run preview

# 方式3: 原生Hexo命令
npx hexo server --draft
```

访问 `http://localhost:4000` 查看博客。

---

## 开发工作流

### 创建新文章

#### 方式1: 使用智能脚本 (推荐)

```bash
npm run new
```

这个脚本会交互式地引导你:

1. 输入文章标题
2. 选择分类
3. 输入标签
4. 选择是否为草稿

#### 方式2: 使用Hexo命令

```bash
# 创建正式文章
npx hexo new post "文章标题"

# 创建草稿
npx hexo new draft "草稿标题"

# 发布草稿
npx hexo publish draft "草稿标题"
```

### 编写文章

文章使用Markdown格式,保存在`source/_posts/`目录。

**Front Matter示例**:

```yaml
---
title: 文章标题
date: 2026-01-23 18:00:00
categories: tech
tags:
  - Hexo
  - Blog
---
```

### 预览文章

```bash
# 启动本地服务器(包含草稿)
npm run dev

# 或使用预览脚本
npm run preview --draft
```

### 部署博客

#### 一键部署 (推荐)

```bash
npm run deploy
```

这个脚本会自动:

1. 提交源码到master分支
2. 生成静态文件
3. 部署到main分支

#### 手动部署

```bash
# 1. 提交源码
git add .
git commit -m "Update: 添加新文章"
git push origin master

# 2. 生成静态文件
npm run build

# 3. 部署到GitHub Pages
npx hexo deploy
```

---

## 项目结构

```
SMLYFM.github.io/
├── .github/              # GitHub配置
│   └── workflows/        # GitHub Actions (待添加)
├── docs/                 # 项目文档
│   ├── DEVELOPMENT.md    # 开发指南 (本文档)
│   ├── DEPLOYMENT.md     # 部署指南
│   └── CONTRIBUTING.md   # 贡献指南
├── tools/              # 开发脚本
│   ├── new-post.sh      # 创建新文章
│   ├── deploy.sh        # 一键部署
│   └── preview.sh       # 本地预览
├── source/               # 博客源文件
│   ├── _posts/          # 文章目录
│   ├── _drafts/         # 草稿目录
│   ├── _data/           # 数据文件
│   └── images/          # 图片资源
├── themes/               # 主题目录
│   └── butterfly/       # Butterfly主题
├── _config.yml          # Hexo主配置
├── _config.butterfly.yml # Butterfly主题配置
├── package.json         # Node.js依赖
├── .gitignore           # Git忽略规则
├── .editorconfig        # 编辑器配置
├── .prettierrc          # 代码格式化配置
└── README.md            # 项目说明
```

---

## 常用命令

### npm scripts

| 命令 | 说明 |
|------|------|
| `npm run dev` | 启动开发服务器(包含草稿) |
| `npm run build` | 构建静态文件 |
| `npm run deploy` | 一键部署 |
| `npm run server` | 启动服务器(不含草稿) |
| `npm run clean` | 清理缓存 |
| `npm run new` | 创建新文章 |
| `npm run preview` | 启动预览服务器 |
| `npm run lint` | 检查代码格式 |
| `npm run format` | 格式化代码 |

### Hexo原生命令

```bash
# 生成静态文件
npx hexo generate  # 或 hexo g

# 启动服务器
npx hexo server    # 或 hexo s

# 部署
npx hexo deploy    # 或 hexo d

# 清理缓存
npx hexo clean

# 创建新文章
npx hexo new [layout] <title>

# 发布草稿
npx hexo publish [layout] <title>
```

---

## 配置说明

### Hexo主配置 (`_config.yml`)

主要配置项:

- **Site**: 网站基本信息(标题、作者等)
- **URL**: 网站地址和永久链接格式
- **Directory**: 目录结构
- **Writing**: 文章渲染配置
- **Deployment**: 部署配置

### 主题配置 (`_config.butterfly.yml`)

Butterfly主题的详细配置,包括:

- UI样式
- 代码高亮
- 评论系统
- 搜索功能
- CDN配置

**修改配置后需要重启服务器或重新生成**。

---

## 调试技巧

### 清理缓存

如果遇到奇怪的问题,首先尝试清理缓存:

```bash
npm run clean
rm -rf .deploy_git/
```

### 查看详细日志

```bash
npx hexo server --debug
```

### 检查依赖

```bash
npm list hexo
npm outdated
```

### 重新安装依赖

```bash
rm -rf node_modules package-lock.json
npm install
```

### Git问题排查

```bash
# 查看当前分支
git branch

# 查看远程配置
git remote -v

# 查看提交历史
git log --oneline -n 10
```

---

## 开发最佳实践

### 1. 文章命名规范

- 使用小写字母
- 单词之间用连字符`-`分隔
- 避免使用特殊字符
- 示例: `my-first-blog-post.md`

### 2. 图片管理

启用`post_asset_folder: true`后,每篇文章会有同名文件夹:

```
source/_posts/
├── my-article.md
└── my-article/
    ├── image1.png
    └── image2.jpg
```

在文章中引用:

```markdown
![图片描述](image1.png)
```

### 3. 提交规范

使用语义化提交信息:

```bash
git commit -m "Update: 添加新文章《Rust学习笔记》"
git commit -m "Fix: 修复代码高亮问题"
git commit -m "Feat: 添加评论系统"
git commit -m "Refactor: 重构主题配置"
```

### 4. 分支管理

- **master**: 存放源码,日常开发在这个分支
- **main**: 自动部署分支,由`hexo deploy`管理,不要手动修改

---

## 故障排查

### 问题1: 本地预览正常,部署后样式丢失

**原因**: URL配置不正确

**解决**:

```yaml
# _config.yml
url: https://smlyfm.github.io/
root: /
```

### 问题2: 部署失败

**检查清单**:

1. SSH密钥是否配置正确
2. `_config.yml`中的`deploy`配置是否正确
3. 网络连接是否正常

### 问题3: 主题不生效

**解决**:

```bash
# 清理缓存
npm run clean

# 检查主题配置
cat _config.yml | grep theme

# 确保主题文件存在
ls themes/butterfly
```

---

## 相关资源

- [Hexo官方文档](https://hexo.io/zh-cn/docs/)
- [Butterfly主题文档](https://butterfly.js.org/)
- [Markdown语法](https://www.markdownguide.org/)
- [GitHub Pages文档](https://docs.github.com/en/pages)

---

## 获取帮助

遇到问题?

- 查看[部署指南](./DEPLOYMENT.md)
- 阅读[Hexo文档](https://hexo.io/zh-cn/docs/troubleshooting.html)
- 提交[GitHub Issue](https://github.com/SMLYFM/SMLYFM.github.io/issues)
