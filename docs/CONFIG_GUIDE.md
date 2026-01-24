# Hexo Butterfly 博客配置修改指南

本文档介绍如何修改博客的各个可自定义部分。

## 📁 文件结构速查

```
├── _config.yml              # Hexo 主配置
├── _config.butterfly.yml    # Butterfly 主题配置 ⭐
├── source/
│   ├── _posts/              # 文章目录
│   ├── about/index.md       # 关于页面
│   ├── categories/index.md  # 分类页面
│   ├── tags/index.md        # 标签页面
│   └── img/                 # 图片资源
└── themes/butterfly/        # 主题文件（一般不修改）
```

---

## 🔧 常用配置修改

### 1. 修改公告 (Announcement)

**文件**: `_config.butterfly.yml`  
**位置**: 搜索 `announcement`

```yaml
announcement:
  content: "欢迎来到我的博客！这里分享数学和编程的知识。"
```

### 2. 修改个人信息

**文件**: `_config.butterfly.yml`

```yaml
# 网站描述 (搜索 description)
description: 一个数学和程序语言爱好者的个人博客

# 头像 (搜索 avatar)
avatar:
  img: /img/avatar.png
  effect: true  # 头像旋转效果

# 作者名 (在 _config.yml 中)
# 搜索 author
author: CJX
```

### 3. 修改社交链接

**文件**: `_config.butterfly.yml`  
**位置**: 搜索 `social`

```yaml
social:
  fab fa-github: https://github.com/你的用户名 || Github || '#24292e'
  fas fa-envelope: mailto:你的邮箱 || Email || '#4a7dbe'
```

---

## 🖼️ 图片与背景

### 4. 修改默认封面图

**文件**: `_config.butterfly.yml`  
**位置**: 搜索 `default_cover`

```yaml
cover:
  default_cover:
    - https://example.com/image1.jpg
    - https://example.com/image2.jpg
    # 添加更多图片...
```

### 5. 修改网站背景

**文件**: `_config.butterfly.yml`  
**位置**: 搜索 `background`

```yaml
# 纯色背景
background: '#f5f5f5'

# 图片背景
background: url(/img/background.jpg)

# 渐变背景
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)
```

### 6. 修改 Favicon 图标

**文件**: `_config.butterfly.yml`

```yaml
favicon: /img/favicon.png
```

> 将图标文件放到 `source/img/` 目录下

---

## 📝 页面内容

### 7. 修改"关于"页面

**文件**: `source/about/index.md`

```markdown
---
title: 关于
date: 2024-01-01
type: about
---

这里写你的自我介绍...
```

### 8. 修改标签页内容

**文件**: `source/tags/index.md`

### 9. 修改分类页内容

**文件**: `source/categories/index.md`

---

## 🎨 菜单与导航

### 10. 修改导航菜单

**文件**: `_config.butterfly.yml`  
**位置**: 搜索 `menu`

```yaml
menu:
  Home: / || fas fa-home
  Archives: /archives/ || fas fa-archive
  Tags: /tags/ || fas fa-tags
  Categories: /categories/ || fas fa-folder-open
  # 下拉菜单示例
  List||fas fa-list||hide:
    Music: /music/ || fas fa-music
    Movie: /movies/ || fas fa-video
```

---

## ⚙️ 功能开关

### 11. 暗黑模式

**文件**: `_config.butterfly.yml`

```yaml
darkmode:
  enable: true
  button: true
  autoChangeMode: false  # 或 1/2 自动切换
```

### 12. 繁简切换

```yaml
translate:
  enable: true
```

### 13. 阅读模式

```yaml
readmode: true
```

### 14. 访问统计

```yaml
busuanzi:
  site_uv: true  # 访客数
  site_pv: true  # 访问量
  page_pv: true  # 文章阅读量
```

---

## ⚠️ 修改注意事项

1. **YAML 格式**: 注意缩进使用空格（不是 Tab），冒号后必须有空格
2. **中文路径**: 分类名使用中文时，URL 会自动编码
3. **图片路径**:
   - 本地图片放 `source/img/`，引用为 `/img/xxx.png`
   - 也可使用外部图片 URL
4. **修改后预览**: 运行 `hexo clean && hexo s` 本地预览
5. **部署**: 确认无误后运行 `hexo d` 部署

---

## 🚀 常用命令

```bash
# 本地预览
hexo clean && hexo server

# 部署
hexo deploy

# 新建文章
hexo new "文章标题"

# 新建页面
hexo new page "页面名"
```

---

## 📚 更多资源

- [Butterfly 官方文档](https://butterfly.js.org/)
- [Hexo 官方文档](https://hexo.io/zh-cn/docs/)
