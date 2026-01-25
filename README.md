# SMLYFM.github.io

> 🌟 **Hexo-CJX Blog** - 一个热爱数学与编程的探索者的个人博客

[![Hexo](https://img.shields.io/badge/Framework-Hexo%207.3-blue?logo=hexo)](https://hexo.io/)
[![Butterfly](https://img.shields.io/badge/Theme-Butterfly%205.3.5-6513df?logo=bitdefender)](https://butterfly.js.org/)
[![Deploy](https://img.shields.io/github/actions/workflow/status/SMLYFM/SMLYFM.github.io/deploy.yml?label=Deploy&logo=github)](https://github.com/SMLYFM/SMLYFM.github.io/actions)
[![PWA](https://img.shields.io/badge/PWA-Ready-5A0FC8?logo=pwa)](https://smlyfm.github.io)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 📚 目录

- [快速开始](#-快速开始)
- [项目结构详解](#-项目结构详解)
- [文章管理完整指南](#️-文章管理完整指南)
- [文章管理系统](#-文章管理系统)（Hash 追踪 & ID 管理）
- [配置说明](#️-配置说明)
- [分支管理](#-分支管理)
- [常用命令速查](#-常用命令速查)

### 📖 详细文档

| 文档 | 说明 |
|------|------|
| [🚀 新手指南](docs/GETTING_STARTED.md) | Fork/Clone 到部署的完整流程 |
| [📝 配置修改指南](docs/CONFIG_GUIDE.md) | 公告、背景、导航菜单、社交链接等修改方法 |
| [🔧 开发指南](docs/DEVELOPMENT.md) | 本地开发环境设置和工作流程 |
| [🚀 部署指南](docs/DEPLOYMENT.md) | GitHub Pages 部署步骤 |
| [🖥️ 服务器部署](docs/SERVER_DEPLOYMENT.md) | Docker/VPS 服务器部署指南 |
| [📋 Makefile 说明](docs/MAKEFILE.md) | 所有 make 命令详细说明 |
| [🎨 主题定制](docs/THEME_CUSTOMIZATION.md) | Butterfly 主题自定义配置 |
| [🆕 UI 更新日志](docs/MODERN_THEME_CHANGELOG.md) | 现代化 UI 改造记录 |
| [🐛 CSS 加载修复](docs/BUGFIX_CSS_LOADING.md) | 现代首页样式加载问题修复记录 |
| [🔧 EJS 语法修复](docs/BUGFIX_EJS_SYNTAX_ERROR.md) | EJS 模板语法错误分析与解决方案 |
| [📐 UI 重构计划](docs/UI_REFACTOR_PLAN.md) | 首页 UI 重构设计计划 |

---

## 🚀 快速开始

```bash
# 克隆仓库
git clone git@github_yytcjx:SMLYFM/SMLYFM.github.io.git
cd SMLYFM.github.io

# 安装依赖
npm install

# 查看新手引导
make quick-start

# 本地预览
make dev
# 访问 http://localhost:4000
```

---

## 📁 项目结构详解

```
SMLYFM.github.io/
│
├── 📄 _config.yml              # Hexo 主配置文件（站点标题、URL、语言等）
├── 📄 _config.butterfly.yml    # Butterfly 主题配置（导航栏、侧边栏、功能开关）
├── 📄 Makefile                 # 博客管理自动化脚本（创建文章、部署等）
├── 📄 package.json             # Node.js 依赖配置
├── 📄 README.md                # 本文档
│
├── 📂 source/                  # 📝 博客内容源文件（最常编辑）
│   ├── 📂 _posts/              # ✍️ 正式发布的文章（Markdown 格式）
│   │   ├── complex-analysis-intro.md       # 复分析入门
│   │   ├── deep-learning-optimizers.md     # 深度学习优化器
│   │   ├── functional-analysis-basics.md   # 泛函分析基础
│   │   ├── latex-math-guide.md             # LaTeX 数学公式排版
│   │   ├── lebesgue-measure-theory.md      # 勒贝格测度理论
│   │   ├── ml-regularization.md            # 机器学习正则化
│   │   ├── pde-finite-difference.md        # PDE 有限差分法
│   │   ├── pde-numerical-methods.md        # PDE 数值方法
│   │   ├── pinns-introduction.md           # PINNs 简介
│   │   ├── python-decorators.md            # Python 装饰器
│   │   ├── pytorch-autograd.md             # PyTorch 自动微分
│   │   ├── rust-ownership.md               # Rust 所有权
│   │   └── topology-basics.md              # 点集拓扑基础
│   │
│   ├── 📂 _drafts/             # 📝 草稿箱（未发布的文章）
│   │
│   ├── 📂 about/               # 📄 关于页面
│   │   └── index.md            #    个人介绍内容
│   ├── 📂 categories/          # 📄 分类页面
│   │   └── index.md            #    分类列表入口
│   ├── 📂 tags/                # 📄 标签页面
│   │   └── index.md            #    标签云入口
│   ├── 📂 link/                # 📄 友链页面
│   │   └── index.md            #    友情链接内容
│   ├── 📂 music/               # 📄 音乐推荐页面
│   │   └── index.md            #    音乐收藏
│   ├── 📂 movies/              # 📄 电影推荐页面
│   │   └── index.md            #    电影收藏
│   │
│   ├── 📂 css/                 # 🎨 自定义 CSS 样式
│   │   └── 📂 modern/          # 现代化 UI 样式
│   │       ├── index.css       #    样式入口文件（引入其他模块）
│   │       ├── variables.css   #    CSS 变量（颜色、间距、字体）
│   │       ├── cards.css       #    卡片组件样式
│   │       ├── animations.css  #    动画效果
│   │       └── dark-mode.css   #    深色模式增强
│   │
│   ├── 📂 js/                  # 📜 自定义 JavaScript
│   │   ├── 📂 components/      # UI 组件脚本
│   │   │   ├── clock.js        #    实时时钟
│   │   │   └── greeting.js     #    问候语（早上好/下午好等）
│   │   └── 📂 effects/         # 视觉效果
│   │       └── snowfall.js     #    雪花飘落效果
│   │
│   └── 📂 img/                 # 🖼️ 图片资源
│       ├── avatar.png          #    头像
│       ├── 404.jpg             #    404 错误页背景
│       └── ...                 #    其他图片
│
├── 📂 themes/                  # 🎨 Hexo 主题
│   └── 📂 butterfly/           # Butterfly 主题
│       ├── 📂 layout/          # 页面布局模板
│       │   ├── index.pug       #    🏠 首页布局（现代化卡片）
│       │   ├── post.pug        #    📄 文章详情页
│       │   ├── page.pug        #    📃 普通页面
│       │   └── 📂 includes/    # 可复用组件
│       │       ├── layout.pug  #       主布局框架
│       │       ├── head.pug    #       HTML head 部分
│       │       └── 📂 widget/  #       侧边栏组件
│       ├── 📂 source/          # 主题静态资源
│       │   ├── 📂 css/         #    主题 CSS
│       │   └── 📂 js/          #    主题 JavaScript
│       └── _config.yml         # 主题默认配置（被 _config.butterfly.yml 覆盖）
│
├── 📂 scaffolds/               # 📋 文章模板
│   ├── post.md                 #    新文章模板（包含 Front Matter）
│   ├── draft.md                #    草稿模板
│   └── page.md                 #    页面模板
│
├── 📂 docs/                    # 📖 项目文档
│   ├── BUGFIX_CSS_LOADING.md   #    CSS 加载问题修复记录
│   └── ...                     #    其他文档
│
├── 📂 tools/                   # 🔧 辅助工具脚本
│   └── ...                     #    各种自动化脚本
│
├── 📂 .github/                 # ⚙️ GitHub 配置
│   ├── 📂 workflows/           # GitHub Actions 工作流
│   │   ├── deploy.yml          #    自动部署到 GitHub Pages
│   │   ├── compress-images.yml #    PR 图片自动压缩
│   │   ├── docker-build.yml    #    Docker 镜像构建
│   │   └── lighthouse-ci.yml   #    性能监控审计
│   └── dependabot.yml          # 依赖自动更新配置
│
├── 📂 docker/                  # 🐳 Docker 配置
│   └── nginx.conf              #    Nginx 配置（含安全头）
│
├── 📄 Dockerfile               # Docker 镜像构建
├── 📄 docker-compose.yml       # Docker Compose 配置
├── 📄 lighthouserc.js          # Lighthouse CI 配置
│
├── 📂 public/                  # 🌐 生成的静态网站（自动生成，勿编辑）
├── 📂 .deploy_git/             # 📤 部署缓存（自动生成，勿编辑）
└── 📂 node_modules/            # 📦 依赖（自动生成，勿编辑）
```

### 📝 关键文件说明

| 文件 | 作用 | 常见修改场景 |
|------|------|-------------|
| `_config.yml` | Hexo 主配置 | 修改站点标题、URL、作者信息 |
| `_config.butterfly.yml` | 主题配置 | 修改导航栏、侧边栏、功能开关 |
| `source/_posts/*.md` | 博客文章 | 撰写/编辑文章 |
| `source/about/index.md` | 关于页面 | 更新个人介绍 |
| `source/css/modern/*.css` | 自定义样式 | 调整 UI 样式 |
| `themes/butterfly/layout/index.pug` | 首页布局 | 修改首页结构 |
| `Makefile` | 管理脚本 | 添加新的自动化命令 |

---

## ✍️ 文章管理完整指南

### 工作流程图

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  创建文章   │ ──▶ │  本地预览   │ ──▶ │  提交部署   │
│  make new   │     │  make dev   │     │  make sync  │
└─────────────┘     └─────────────┘     └─────────────┘
                           │
                           ▼
                    修改 ──▶ 刷新 ──▶ 满意？
                           │           │
                           └─── No ────┘
```

### Step 1: 创建新文章

```bash
# 方式1: 交互式创建（推荐新手）
make new

# 方式2: 数学文章模板
make new-math TITLE="泛函分析中的Riesz表示定理"

# 方式3: 编程文章模板
make new-code TITLE="PyTorch模型部署实践" LANG="python"
```

### Step 2: 编辑文章

文章 Front Matter 示例：

```yaml
---
title: 文章标题
date: 2026-01-25 01:40:00        # 创建时间（不要修改）
updated: 2026-01-25 02:30:00     # 修改时间（每次编辑后更新）
categories:
  - 数学                          # 主分类
tags:
  - 泛函分析
  - Riesz表示定理
description: 文章简介（可选）
cover: /img/xxx.jpg              # 封面图（可选）
mathjax: true                    # 启用数学公式（数学文章必须）
---

## 正文开始...
```

### Step 3: 时间字段说明

| 字段 | 含义 | 何时修改 |
|------|------|---------|
| `date` | 创建时间 | ❌ **永不修改** |
| `updated` | 最后更新时间 | ✅ 每次编辑后更新 |

```bash
# 自动更新修改时间
make update-time
```

### Step 4: 本地预览

```bash
make dev    # 启动开发服务器
# 访问 http://localhost:4000
```

### Step 5: 提交和部署

```bash
# 🚀 一键同步（推荐）
make sync

# 或分步操作：
make push    # 提交源码到 master
make deploy  # 部署网站到 main
```

---

## ⚙️ 配置说明

### 导航栏配置 (`_config.butterfly.yml`)

```yaml
menu:
  Home: / || fas fa-home
  Archives: /archives/ || fas fa-archive
  Tags: /tags/ || fas fa-tags
  Categories: /categories/ || fas fa-folder-open
  
  # 下拉菜单格式: 名称||图标||hide
  Math||fas fa-calculator||hide:
    数学: /categories/数学/ || fas fa-infinity
    PDE: /categories/pde/ || fas fa-wave-square
```

### 社交链接配置

```yaml
social:
  github: https://github.com/SMLYFM || fab fa-github
  email: yytcjx@gmail.com || fas fa-envelope
```

### 侧边栏配置

```yaml
aside:
  enable: true
  card_author:
    enable: true
    description: 一个数学和程序语言爱好者
  card_announcement:
    enable: true
    content: This is my Blog
```

---

## 🌿 分支管理

```
          ┌─────────────────────────────────────────┐
          │           GitHub Repository             │
          ├─────────────┬───────────────────────────┤
          │   master    │          main             │
          │  (源代码)   │       (静态网站)          │
          ├─────────────┼───────────────────────────┤
          │ *.md        │  index.html               │
          │ _config.yml │  css/, js/                │
          │ themes/     │  archives/, tags/         │
          │ source/     │  2026/*.html              │
          └─────────────┴───────────────────────────┘
                │                    │
                │  make push         │  make deploy
                ▼                    ▼
          提交源码变更         部署生成的网站
```

| 分支 | 用途 | 操作命令 |
|------|------|---------|
| `master` | 存放博客源代码 | `make push` |
| `main` | 存放 Hexo 生成的静态网站 | `make deploy` |

---

## 📋 常用命令速查

### Makefile 命令

```bash
# 📝 文章管理
make new              # 交互式创建文章
make new-math TITLE="标题"   # 数学文章模板
make new-code TITLE="标题"   # 编程文章模板
make list             # 列出所有文章（含 Hash 状态）
make list-detail      # 详细列表（含 Hash 和标签）
make edit             # 编辑最新文章
make edit-file FILE="xxx.md"  # 编辑指定文章
make delete           # 删除文章
make search KEYWORD="关键词"  # 搜索文章

# 📋 文章 ID 系统
make article-id-init        # 初始化 ID 系统
make article-id-list        # 列出所有文章 ID
make article-info ID=1      # 按 ID 查看文章详情
make article-info FILE="xxx.md"  # 按文件名查看详情
make article-id-sync        # 同步 ID（新增/删除）

# 🔐 Hash 追踪系统
make article-init           # 初始化 Hash 记录
make article-check          # 检查哪些文章被修改
make article-update         # 更新已修改文章的时间戳
make article-show FILE="xxx.md"  # 显示文章 Hash 信息

# 🏗️ 构建部署
make dev              # 开发服务器（含草稿）
make server           # 生产服务器
make build            # 构建静态网站
make deploy           # 部署到 main 分支
make push             # 提交到 master 分支
make sync             # 一键同步（提交+部署）

# 🔧 维护
make clean            # 清理缓存
make check            # 检查项目状态
make count            # 统计文章字数
make backup           # 备份博客

# 📤 导出
make export-md FILE="xxx.md"    # 导出为 Markdown
make export-pdf FILE="xxx.md"   # 导出为 PDF
make export-all-md              # 批量导出所有

# 📦 批量操作
make batch-stats                # 分类/标签统计
make batch-add-tag TAG="..." CATEGORY="..."
make batch-delete ARGS="--category 测试"

# 📁 归档
make archive-move               # 归档文章
make archive-restore            # 恢复归档
make archive-list               # 列出归档

# 💾 备份/恢复
make backup-full                # 完整备份
make backup-incremental         # 增量备份
make restore-full               # 从备份恢复

# 🐳 Docker
make docker-build     # 构建 Docker 镜像
make docker-run       # 运行容器
make docker-stop      # 停止容器
```

---

## 📋 文章管理系统

### Hash 追踪系统

自动检测文章内容变化，帮助你管理文章更新：

```bash
# 初始化（首次使用）
make article-init

# 检查哪些文章被修改
make article-check
# 输出: [MODIFIED] python-decorators.md
#       新文章: 0 | 已修改: 1 | 未变化: 18

# 更新已修改文章的时间戳
make article-update

# 查看文章列表（带状态）
make list
# 输出带有 ✓/MOD/NEW 状态标识
```

### ID 管理系统

为每篇文章分配唯一 ID，方便引用和管理：

```bash
# 初始化（首次使用）
make article-id-init

# 列出所有文章 ID
make article-id-list
# 输出: #1 卷积神经网络... cnn-deep-dive.md
#       #2 复分析入门... complex-analysis-intro.md

# 查看文章详情
make article-info ID=19
# 显示：基本信息、时间、分类标签、统计、Hash、Git 提交记录
```

**ID 规则：**

- ✅ 文章内容修改时，ID 保持不变
- ✅ 删除文章时，ID 被释放可供新文章使用
- ✅ 优先使用小的 ID 号（1 → 2 → 3...）

---

## 🔧 技术特性

### 🔒 安全加固

- **CSP** - 内容安全策略，防止 XSS 攻击
- **HSTS** - 强制 HTTPS，预加载列表就绪
- **Permissions-Policy** - 限制浏览器 API 权限
- **X-Frame-Options** - 防止点击劫持

### 📱 PWA 支持

- **Service Worker** - 离线访问支持
- **Web App Manifest** - 可安装到主屏幕
- **缓存策略** - 网络优先，离线兜底

### 🔄 CI/CD 自动化

| 工作流 | 触发条件 | 功能 |
|--------|----------|------|
| `deploy.yml` | push → master | 构建验证 + 部署 |
| `compress-images.yml` | PR 包含图片 | 自动压缩优化 |
| `docker-build.yml` | 手动/push | GHCR 镜像发布 |
| `lighthouse-ci.yml` | 部署后/每周 | 性能审计报告 |

### 📊 监控与分析

- **Lighthouse CI** - 自动性能评分
- **Busuanzi** - 访问统计
- **Sitemap** - 自动生成 SEO sitemap

### npm 脚本

```bash
npm run server        # 启动服务器
npm run build         # 构建网站
npm run deploy        # 部署
npm run clean         # 清理
```

---

## 📞 联系方式

- **GitHub**: [@SMLYFM](https://github.com/SMLYFM)
- **Email**: <yytcjx@gmail.com>
- **Blog**: [https://smlyfm.github.io](https://smlyfm.github.io)

---

## 📄 许可证

本项目采用 [MIT License](LICENSE) 许可证。

博客内容采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 许可协议。
