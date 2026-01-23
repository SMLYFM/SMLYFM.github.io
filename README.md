# Hexo-CJX Blog

<div align="center">

[![Hexo](https://img.shields.io/badge/Hexo-7.3.0-blue.svg)](https://hexo.io)
[![Theme](https://img.shields.io/badge/Theme-Butterfly-pink.svg)](https://butterfly.js.org/)
[![Node](https://img.shields.io/badge/Node-%3E%3D14.0.0-green.svg)](https://nodejs.org)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Deploy](https://github.com/SMLYFM/SMLYFM.github.io/actions/workflows/deploy.yml/badge.svg)](https://github.com/SMLYFM/SMLYFM.github.io/actions/workflows/deploy.yml)

**一个数学和程序语言爱好者的个人博客**

[🌐 在线访问](https://smlyfm.github.io) · [📖 开发指南](docs/DEVELOPMENT.md) · [🚀 部署指南](docs/DEPLOYMENT.md)

</div>

---

## ✨ 特性

### 核心功能

- 🎨 **精美主题**: 使用Butterfly主题，界面美观现代
- 🌟 **现代卡片布局**: 全新的首页卡片式设计（v1.0.0新增）
- 📝 **Markdown**: 支持完整的Markdown语法和扩展
- 🔍 **本地搜索**: 快速全文搜索
- 🏷️ **分类标签**: 完善的文章分类和标签系统
- 💬 **代码高亮**: 多种语言的代码高亮支持
- 📱 **响应式**: 完美适配桌面和移动设备
- ⚡ **快速加载**: 优化的资源加载策略
- 🔧 **开发工具**: 丰富的开发脚本和配置

### 现代主题特性 (v1.0.0)

- ✨ **毛玻璃卡片**: 半透明背景 + backdrop-filter效果
- 🎭 **品牌色渐变**: 紫蓝渐变色系 (#667eea → #764ba2)
- ❄️ **粒子动画**: Canvas实现的雪花背景效果
- 💫 **动态交互**: Hover悬浮、心跳动画、阴影变化
- 🕐 **实时组件**: 动态时钟、智能问候语
- 📅 **智能日历**: 自动标记有文章的日期
- 🔗 **社交卡片**: GitHub、Email等快速链接
- 📱 **完美适配**: 桌面绝对定位，移动垂直堆叠

---

## 🚀 快速开始

### 环境要求

- **Node.js**: >= 14.0.0
- **npm**: >= 6.0.0
- **Git**: >= 2.0.0

### 安装

```bash
# 克隆仓库
git clone git@github_yytcjx:SMLYFM/SMLYFM.github.io.git
cd SMLYFM.github.io

# 切换到master分支
git checkout master

# 安装依赖
npm install

# 启动本地服务器
npm run dev
```

访问 `http://localhost:4000` 查看博客。

---

## 📁 项目结构

```
SMLYFM.github.io/
├── .github/                  # GitHub配置
│   └── workflows/            # GitHub Actions自动部署
├── docs/                     # 项目文档
│   ├── DEVELOPMENT.md        # 开发指南
│   ├── DEPLOYMENT.md         # 部署指南
│   ├── THEME_CUSTOMIZATION.md       # 主题定制指南 (新增)
│   └── MODERN_THEME_CHANGELOG.md    # 现代主题更新日志 (新增)
├── tools/                    # 开发脚本
│   ├── new-post.sh           # 创建新文章
│   ├── deploy.sh             # 一键部署
│   └── preview.sh            # 本地预览
├── source/                   # 博客源文件
│   ├── _posts/               # 文章目录
│   ├── _drafts/              # 草稿目录
│   ├── _data/                # 数据文件
│   ├── css/modern/           # 现代主题CSS (新增)
│   │   ├── variables.css     # 设计变量
│   │   ├── cards.css         # 卡片样式
│   │   ├── animations.css    # 动画效果
│   │   └── index.css         # 主入口
│   └── js/                   # JavaScript文件 (新增)
│       ├── effects/          # 特效组件
│       │   └── snowfall.js   # 雪花动画
│       └── components/       # 功能组件
│           ├── clock.js      # 实时时钟
│           └── greeting.js   # 动态问候
├── themes/                   # 主题目录
│   └── butterfly/            # Butterfly主题
│       └── layout/
│           ├── index-modern.ejs      # 现代首页模板 (新增)
│           └── modern-cards/         # 卡片组件 (新增)
├── _config.yml               # Hexo主配置
├── _config.butterfly.yml     # 主题配置
├── package.json              # 依赖配置
└── README.md                 # 项目说明
```

---

## 🛠️ 常用命令

### Makefile命令 (推荐)

```bash
make help          # 查看所有命令
make check         # 检查项目状态
make new           # 创建新文章(交互式)
make dev           # 启动开发服务器
make sync          # 一键同步:提交+部署
make list          # 列出所有文章
```

详见 [Makefile使用指南](docs/MAKEFILE.md)

### npm scripts

| 命令 | 说明 |
|------|------|
| `npm run dev` | 启动开发服务器(包含草稿) |
| `npm run build` | 构建静态文件 |
| `npm run deploy` | 一键部署(提交+构建+部署) |
| `npm run new` | 创建新文章(交互式) |
| `npm run preview` | 启动预览服务器 |
| `npm run clean` | 清理缓存 |
| `npm run lint` | 检查代码格式 |
| `npm run format` | 格式化代码 |

---

## 📝 写作工作流

### 1. 创建新文章

```bash
# 使用交互式脚本(推荐)
npm run new

# 或使用Hexo命令
npx hexo new post "文章标题"
```

### 2. 编写内容

文章保存在 `source/_posts/` 目录,使用Markdown格式。

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

### 3. 本地预览

```bash
npm run dev
```

访问 `http://localhost:4000` 预览文章。

### 4. 发布

```bash
# 一键部署(推荐)
npm run deploy

# 或手动部署
git add .
git commit -m "Update: 添加新文章"
git push origin master
```

**GitHub Actions会自动构建并部署到 `main` 分支。**

---

## 🌟 技术栈

### 核心框架

- [Hexo](https://hexo.io/) - 静态网站生成器
- [Butterfly](https://butterfly.js.org/) - 主题

### 开发工具

- [EditorConfig](https://editorconfig.org/) - 编辑器配置
- [Prettier](https://prettier.io/) - 代码格式化

### 部署

- [GitHub Pages](https://pages.github.com/) - 静态网站托管
- [GitHub Actions](https://github.com/features/actions) - CI/CD自动部署

---

## 🔧 配置说明

### Hexo配置 (`_config.yml`)

主要配置项:

- **Site**: 网站基本信息
- **URL**: 网站地址和链接格式
- **Writing**: 文章渲染配置
- **Deployment**: 部署配置

### 主题配置 (`_config.butterfly.yml`)

Butterfly主题的详细配置,包括UI、代码高亮、搜索等。

详细说明请参考 [开发指南](docs/DEVELOPMENT.md)。

---

## 🚀 部署方式

### 方式1: 自动部署 (推荐)

推送到 `master` 分支后,GitHub Actions自动构建并部署:

```bash
git push origin master
```

### 方式2: 手动部署

```bash
npm run deploy
```

### 方式3: 本地部署

```bash
npm run build
npx hexo deploy
```

详细说明请参考 [部署指南](docs/DEPLOYMENT.md)。

---

## 📊 分支说明

| 分支 | 用途 | 管理方式 |
|------|------|---------|
| `master` | 源代码(Markdown、配置等) | 手动提交 |
| `main` | 静态网站(HTML、CSS、JS) | 自动部署 |

**工作流程**:

```
编写文章 → 提交到master → GitHub Actions自动部署到main → 网站更新
```

---

## 📚 文档

### 基础文档

- [📖 开发指南](docs/DEVELOPMENT.md) - 本地开发、调试技巧
- [🚀 部署指南](docs/DEPLOYMENT.md) - SSH配置、部署流程

### 现代主题文档 (v1.0.0)

- [🎨 主题定制指南](docs/THEME_CUSTOMIZATION.md) - 详细的定制和配置说明
- [📝 现代主题更新日志](docs/MODERN_THEME_CHANGELOG.md) - 完整的修改记录和技术细节

---

## 🤝 贡献

欢迎提交Issue和Pull Request!

---

## 📮 联系方式

- **博客**: [https://smlyfm.github.io](https://smlyfm.github.io)
- **GitHub**: [@SMLYFM](https://github.com/SMLYFM)
- **Email**: <sudocjx@gmail.com>

---

## 📄 License

[MIT License](LICENSE)

---

## 🙏 致谢

- [Hexo](https://hexo.io/) - 强大的静态网站生成器
- [Butterfly](https://butterfly.js.org/) - 精美的Hexo主题
- [GitHub Pages](https://pages.github.com/) - 免费的静态网站托管
- [YYsuni/2025-blog-public](https://github.com/YYsuni/2025-blog-public) - 现代主题设计灵感来源

---

<div align="center">

**⭐ 如果觉得不错,请给个Star! ⭐**

Made with ❤️ by [CJX](https://github.com/SMLYFM)

</div>
