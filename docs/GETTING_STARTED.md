# 🚀 新手部署指南：从零开始搭建你的个人博客

本指南帮助你 **Fork 或 Clone** 本项目，并部署到 **GitHub Pages** 成为你自己的个人博客。

---

## 📋 目录

- [前置要求](#前置要求)
- [Step 1: Fork 仓库](#step-1-fork-仓库)
- [Step 2: 克隆到本地](#step-2-克隆到本地)
- [Step 3: 安装依赖](#step-3-安装依赖)
- [Step 4: 修改配置](#step-4-修改配置)
- [Step 5: 本地预览](#step-5-本地预览)
- [Step 6: 部署到 GitHub Pages](#step-6-部署到-github-pages)
- [Step 7: 自定义博客内容](#step-7-自定义博客内容)（删除/新增文章、修改页面）
- [Step 8: 配置评论系统（Giscus）](#step-8-配置评论系统giscus)
- [Step 9: 其他自定义设置](#step-9-其他自定义设置)
- [日常写作流程](#日常写作流程)
- [常见问题](#常见问题)

---

## 前置要求

确保你的电脑已安装：

```bash
# 检查 Node.js（需要 v18+）
node --version

# 检查 npm
npm --version

# 检查 Git
git --version
```

**如果未安装**：

| 系统 | 安装命令 |
|------|----------|
| Fedora | `sudo dnf install nodejs git` |
| Ubuntu/Debian | `sudo apt install nodejs npm git` |
| macOS | `brew install node git` |
| Windows | 下载 [Node.js](https://nodejs.org/) 和 [Git](https://git-scm.com/) |

---

## Step 1: Fork 仓库

### 方式一：Fork（推荐，保持与原仓库关联）

1. 访问 [https://github.com/SMLYFM/SMLYFM.github.io](https://github.com/SMLYFM/SMLYFM.github.io)
2. 点击右上角 **Fork** 按钮
3. 仓库名修改为：`<你的用户名>.github.io`
   - 例如：`zhangsan.github.io`
   - **⚠️ 重要**：这个格式才能启用 GitHub Pages 的用户主页

### 方式二：使用模板（全新开始）

1. 点击仓库页面的 **Use this template** 按钮
2. 创建新仓库，命名为 `<你的用户名>.github.io`

---

## Step 2: 克隆到本地

```bash
# 克隆你 fork 的仓库（替换为你的用户名）
git clone https://github.com/<你的用户名>/<你的用户名>.github.io.git

# 进入项目目录
cd <你的用户名>.github.io

# 💡 文件夹名可以随意改，不影响部署
# 例如：
# mv SMLYFM.github.io my-blog
# cd my-blog
```

**Q: 需要改文件夹名吗？**

**A: 不需要！** 文件夹名只影响本地，不影响部署。你可以改成任何名字。

---

## Step 3: 安装依赖

```bash
# 安装项目依赖
npm install

# 或使用 make（如果有）
make install
```

安装完成后会生成 `node_modules/` 目录。

---

## Step 4: 修改配置

### 4.1 修改主配置 `_config.yml`

```yaml
# 网站信息（必须修改）
title: 你的博客名称
subtitle: 副标题
description: 博客描述
author: 你的名字
language: zh-CN
timezone: Asia/Shanghai

# URL（必须修改）
url: https://<你的用户名>.github.io
root: /

# 部署配置（必须修改）
deploy:
  type: git
  repo: git@github.com:<你的用户名>/<你的用户名>.github.io.git
  branch: main  # 或 gh-pages
```

### 4.2 修改主题配置 `_config.butterfly.yml`

```yaml
# 侧边栏信息
card_author:
  description: 你的个人简介
  button:
    text: Follow Me
    link: https://github.com/<你的用户名>

# 评论系统（需要自己配置）
giscus:
  repo: <你的用户名>/<你的用户名>.github.io
  repo_id: 你的 repo_id  # 在 giscus.app 获取
  category_id: 你的 category_id

# 侧边栏公告
card_announcement:
  content: 欢迎来到我的博客！
```

### 4.3 修改 `Makefile` 中的部署配置

```makefile
# Git 配置
GIT_BRANCH_SOURCE := master
GIT_BRANCH_DEPLOY := main
GIT_REMOTE := origin
```

---

## Step 5: 本地预览

```bash
# 启动本地服务器
make dev
# 或
npx hexo server --draft

# 访问 http://localhost:4000 预览
```

确认网站正常显示后再进行部署。

---

## Step 6: 部署到 GitHub Pages

### 6.1 配置 SSH Key（首次需要）

```bash
# 生成 SSH key
ssh-keygen -t ed25519 -C "your-email@example.com"

# 查看公钥
cat ~/.ssh/id_ed25519.pub

# 将公钥添加到 GitHub:
# Settings → SSH and GPG keys → New SSH key
```

### 6.2 设置 Git 用户信息

```bash
git config --global user.name "你的用户名"
git config --global user.email "your-email@example.com"
```

### 6.3 部署

```bash
# 一键部署（推荐）
make sync

# 或手动部署
npx hexo clean
npx hexo generate
npx hexo deploy
```

### 6.4 配置 GitHub Pages

1. 访问你的仓库 → **Settings** → **Pages**
2. Source 选择 **Deploy from a branch**
3. Branch 选择 `main`（或 `gh-pages`）
4. 保存后等待几分钟

访问 `https://<你的用户名>.github.io` 查看你的博客！

---

## Step 7: 自定义博客内容

### 7.1 删除示例文章（重要！）

Fork 后的仓库包含原作者的文章，你需要删除这些文章：

```bash
# 方法一：删除所有示例文章（推荐）
rm -rf source/_posts/*.md

# 方法二：逐个删除
ls source/_posts/           # 先查看有哪些文章
rm source/_posts/xxx.md     # 删除指定文章

# 方法三：使用 Makefile
make delete                 # 交互式选择删除
```

**删除后记得清理缓存：**

```bash
make clean
# 或
npx hexo clean
```

### 7.2 创建你的第一篇文章

#### 方式一：交互式创建（推荐新手）

```bash
make new
```

系统会引导你输入：

- 文章标题
- 分类
- 标签
- 描述

#### 方式二：指定标题直接创建

```bash
# 普通文章
make new TITLE="我的第一篇博客"

# 数学类文章（自动启用 MathJax）
make new-math TITLE="微积分入门" SUB="分析学"

# 编程类文章（自动添加代码块框架）
make new-code TITLE="Python入门" LANG="python"

# 科学计算类文章
make new-sci TITLE="有限元方法入门"

# 工具类文章
make new-tool TITLE="Git使用指南"
```

#### 方式三：创建草稿（暂不发布）

```bash
make draft TITLE="未完成的文章"

# 完成后发布草稿
make publish DRAFT="未完成的文章"
```

### 7.3 文章格式详解

新建的文章位于 `source/_posts/` 目录。每篇文章都是一个 `.md` 文件，格式如下：

```markdown
---
title: 文章标题
date: 2026-01-25 12:00:00
updated: 2026-01-25 12:00:00
categories:
  - 主分类
  - 子分类
tags:
  - 标签1
  - 标签2
description: 文章简短描述
cover: https://example.com/image.jpg  # 封面图（可选）
mathjax: true  # 启用数学公式（可选）
---

## 简介

这里是文章摘要，会显示在首页。

<!-- more -->

## 正文

正文内容从这里开始...

## 总结

总结内容...

## 参考资料

- [链接名](https://example.com)
```

#### Front Matter 字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| `title` | ✅ | 文章标题 |
| `date` | ✅ | 创建时间 |
| `updated` | ❌ | 更新时间 |
| `categories` | ❌ | 分类（支持多级） |
| `tags` | ❌ | 标签（可多个） |
| `description` | ❌ | 简短描述（用于 SEO） |
| `cover` | ❌ | 封面图 URL |
| `mathjax` | ❌ | 是否启用数学公式 |

### 7.4 管理文章

```bash
# 列出所有文章
make list

# 列出详细信息（含标签）
make list-detail

# 编辑最新文章
make edit

# 编辑指定文章
make edit-file FILE="文章标题.md"

# 搜索文章
make search KEYWORD="关键词"

# 统计字数
make count

# 更新文章修改时间
make update-time

# 给文章添加标签
make add-tag
```

### 7.5 修改关于页面

编辑 `source/about/index.md`：

```markdown
---
title: 关于我
date: 2026-01-01
type: "about"
---

## 👋 你好，我是 XXX

在这里写你的个人介绍...

### 🎓 教育背景

- XX大学 XX专业

### 💼 工作经历

- XXXX

### 🔧 技能

- 编程语言：Python, JavaScript, ...
- 框架：...

### 📫 联系方式

- Email: xxx@example.com
- GitHub: [你的用户名](https://github.com/你的用户名)
```

### 7.6 修改友链页面

编辑 `source/link/index.md`：

```markdown
---
title: 友情链接
date: 2026-01-01
type: "link"
---

{% flink %}
- class_name: 友链
  class_desc: 我的朋友们
  link_list:
    - name: 朋友A的博客
      link: https://friend-a.com
      avatar: https://friend-a.com/avatar.png
      descr: 这是朋友A的博客简介

    - name: 朋友B的博客
      link: https://friend-b.com
      avatar: https://friend-b.com/avatar.png
      descr: 这是朋友B的博客简介
{% endflink %}
```

### 7.7 修改导航菜单

编辑 `_config.butterfly.yml` 中的 `menu` 部分：

```yaml
menu:
  首页: / || fas fa-home
  归档: /archives/ || fas fa-archive
  标签: /tags/ || fas fa-tags
  分类: /categories/ || fas fa-folder-open
  # 可自定义添加更多
  关于: /about/ || fas fa-heart
  友链: /link/ || fas fa-link
```

---

## Step 8: 配置评论系统（Giscus）

本项目使用 **Giscus** 作为评论系统，它基于 GitHub Discussions，免费且美观。

### 8.1 启用仓库 Discussions

1. 访问你的仓库 → **Settings** → **General**
2. 滚动到 **Features** 部分
3. 勾选 **Discussions**

### 8.2 安装 Giscus App

1. 访问 [https://github.com/apps/giscus](https://github.com/apps/giscus)
2. 点击 **Install**
3. 选择你的仓库 `<用户名>.github.io`
4. 点击 **Install**

### 8.3 获取配置参数

1. 访问 [https://giscus.app/](https://giscus.app/)
2. 在 **Repository** 输入：`<你的用户名>/<你的用户名>.github.io`
3. **Discussion Category** 选择 **Announcements**（或创建一个新分类）
4. 其他保持默认
5. 页面下方会生成配置代码，记录以下值：
   - `data-repo`
   - `data-repo-id`
   - `data-category-id`

### 8.4 修改主题配置

编辑 `_config.butterfly.yml`：

```yaml
comments:
  use: Giscus
  text: true
  lazyload: true
  count: true
  card_post_count: true

giscus:
  repo: <你的用户名>/<你的用户名>.github.io
  repo_id: <从 giscus.app 获取的 repo_id>
  category_id: <从 giscus.app 获取的 category_id>
  light_theme: light
  dark_theme: dark_dimmed
  js:
  option:
    mapping: pathname
    inputPosition: bottom
    lang: zh-CN
    reactions-enabled: 1
```

### 8.5 验证评论系统

```bash
# 本地预览
make dev

# 打开任意文章，滚动到底部查看评论区
```

如果显示 "使用 GitHub 登录评论"，说明配置成功！

---

## Step 9: 其他自定义设置

### 9.1 修改网站图标（Favicon）

替换 `source/img/favicon.ico` 为你的图标。

### 9.2 修改侧边栏头像

编辑 `_config.butterfly.yml`：

```yaml
avatar:
  img: https://你的头像URL
  effect: true  # 鼠标悬停旋转效果
```

### 9.3 修改侧边栏公告

```yaml
card_announcement:
  enable: true
  content: 欢迎来到我的博客！这里记录我的学习和思考。
```

### 9.4 修改底部 Footer

```yaml
footer:
  owner:
    enable: true
    since: 2026  # 建站年份
  custom_text: 你的自定义文字
```

### 9.5 修改社交链接

```yaml
social:
  fab fa-github: https://github.com/<你的用户名> || Github
  fas fa-envelope: mailto:your-email@example.com || Email
```

### 9.6 添加百度/Google 统计

```yaml
# 百度统计
baidu_analytics: 你的百度统计ID

# Google Analytics
google_analytics: G-XXXXXXXXXX
```

---

## 日常写作流程

```bash
# 1. 创建新文章
make new TITLE="文章标题"

# 2. 编辑文章（用你喜欢的编辑器）
code source/_posts/文章标题.md

# 3. 本地预览
make dev
# 访问 http://localhost:4000 预览效果

# 4. 满意后一键发布
make sync
# 这会自动：提交源码 → 推送到 GitHub → 构建 → 部署
```

---

## 常见问题

### Q1: 部署后页面显示 404？

**A**:

1. 检查 GitHub Pages 是否已启用
2. 确认部署分支正确（main 或 gh-pages）
3. 等待几分钟让 GitHub 构建完成

### Q2: CSS 样式丢失？

**A**: 检查 `_config.yml` 中的 `url` 和 `root` 配置是否正确。

### Q3: 部署失败 Permission denied？

**A**: 检查 SSH key 是否正确配置：

```bash
ssh -T git@github.com
```

应该显示：`Hi <用户名>! You've successfully authenticated...`

### Q4: 如何更新主题？

**A**:

```bash
npm update hexo-theme-butterfly
```

### Q5: 如何添加自定义域名？

**A**:

1. 在 `source/` 目录创建 `CNAME` 文件，内容为你的域名
2. 在域名服务商添加 CNAME 记录指向 `<用户名>.github.io`

---

## 项目结构速览

```
.
├── source/
│   ├── _posts/          # 📝 文章目录
│   ├── _drafts/         # 📝 草稿目录
│   ├── about/           # 关于页面
│   ├── link/            # 友链页面
│   └── img/             # 图片资源
├── themes/              # 主题目录
├── _config.yml          # 🔧 Hexo 主配置
├── _config.butterfly.yml # 🔧 主题配置
├── Makefile             # 🔧 快捷命令
└── package.json         # 依赖配置
```

---

## 有用的命令

| 命令 | 说明 |
|------|------|
| `make help` | 查看所有可用命令 |
| `make dev` | 本地预览（含草稿） |
| `make new` | 创建新文章 |
| `make list` | 列出所有文章 |
| `make sync` | 一键同步发布 |
| `make doctor` | 环境诊断 |

---

## 获取帮助

- 📖 [Hexo 官方文档](https://hexo.io/zh-cn/docs/)
- 📖 [Butterfly 主题文档](https://butterfly.js.org/)
- 🐛 遇到问题？在 GitHub Issues 中提问

---

**祝你搭建成功！🎉**

---

**更新日期**: 2026-01-25  
**作者**: CJX  
**项目**: SMLYFM.github.io
