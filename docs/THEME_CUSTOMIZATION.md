# 现代主题定制指南

## 📚 概述

本指南说明如何使用和定制现代博客主题。该主题基于Hexo Butterfly,添加了现代卡片式布局、动画效果和交互功能。

---

## 🎨 主题特性

### 视觉效果

- ✨ **毛玻璃卡片**: 使用 `backdrop-filter` 实现半透明毛玻璃效果
- 🎭 **渐变色系**: 品牌色渐变 (#667eea → #764ba2)
- 🔄 **圆角设计**: 支持 CSS Squircle 圆角
- 🌟 **动画效果**: 淡入、悬hover浮、心跳等动画

### 功能组件

- 👋 **Hi Card**: 个人介绍卡片（头像 + 动态问候语）
- 📝 **Article Card**: 最新文章列表
- 🕐 **Clock Card**: 实时时钟和日期
- 🔗 **Social Card**: 社交媒体链接
- 📅 **Calendar Card**: 月历（标记有文章的日期）

### 动态效果

- ❄️ **雪花背景**: Canvas实现的粒子动画
- 🖱️ **交互动画**: Hover效果、心跳动画
- 📱 **响应式**: 桌面卡片布局，移动端垂直堆叠

---

## 📁 文件结构

```
SMLYFM.github.io/
├── source/
│   ├── css/
│   │   └── modern/           # 现代主题CSS
│   │       ├── variables.css # 设计变量
│   │       ├── cards.css     # 卡片样式
│   │       ├── animations.css# 动画效果
│   │       └── index.css     # 主入口
│   └── js/
│       ├── effects/
│       │   └── snowfall.js   # 雪花效果
│       └── components/
│           ├── clock.js      # 时钟组件
│           └── greeting.js   # 问候语
├── themes/butterfly/
│   └── layout/
│       ├── index-modern.ejs  # 现代首页模板
│       └── modern-cards/     # 卡片组件
│           ├── hi-card.ejs
│           ├── article-card.ejs
│           ├── clock-card.ejs
│           ├── social-card.ejs
│           └── calendar-card.ejs
└── _config.butterfly.yml     # 主题配置
```

---

## ⚙️ 配置

### 在 `_config.butterfly.yml` 中启用

```yaml
# Inject现代主题资源
inject:
  head:
    - <link rel="stylesheet" href="/css/modern/index.css">
  bottom:
    - <script src="/js/effects/snowfall.js"></script>
    - <script src="/js/components/clock.js"></script>
    - <script src="/js/components/greeting.js"></script>

# 现代卡片配置
modern_cards:
  enable: true              # 启用/禁用现代首页
  calendar_enabled: true    # 显示日历卡片
  snowfall_enabled: true    # 显示雪花背景
```

### 社交链接配置

```yaml
social:
  fab fa-github: https://github.com/SMLYFM || Github || '#24292e'
  fas fa-envelope: mailto:sudocjx@gmail.com || Email || '#4a7dbe'
  github: https://github.com/SMLYFM
  email: sudocjx@gmail.com
```

---

## 🎨 自定义样式

### 修改品牌色

编辑 `source/css/modern/variables.css`:

```css
:root {
  --color-brand-primary: #667eea;     /* 主品牌色 */
  --color-brand-secondary: #764ba2;   /* 次品牌色 */
}
```

### 调整卡片圆角

```css
:root {
  --radius-card: 40px;  /* 卡片圆角大小 */
}
```

### 修改卡片间距

```css
:root {
  --card-spacing: 36px;     /* 桌面端间距 */
  --card-spacing-sm: 24px;  /* 移动端间距 */
}
```

---

## 📍 卡片位置调整

在 `themes/butterfly/layout/modern-cards/hi-card.ejs` 中找到 `getCardPosition()` 函数：

```javascript
const positions = {
  hiCard: {
    left: '50%',
    top: '50%',
    transform: 'translate(-50%, -50%)',
    width: '360px'
  },
  articleCard: {
    left: 'calc(50% + 400px)',  // 调整水平位置
    top: '50%',
    width: '320px'
  }
  // ... 其他卡片
}
```

**调整距离**:

- 增大 `+ 400px` →卡片右移
- 减小 `- 400px` → 卡片左移
- 调整 `top` 值 → 卡片垂直移动

---

## ❄️ 背景效果配置

### 调整雪花数量

编辑 `source/js/effects/snowfall.js`:

```javascript
this.config = {
  count: options.count || (window.innerWidth < 768 ? 30 : 100),
  // 移动端30个，桌面端100个
  speed: 1,    // 下落速度
  wind: 0.5,   // 风力
}
```

### 禁用雪花效果

在 `_config.butterfly.yml`:

```yaml
modern_cards:
  snowfall_enabled: false  # 关闭雪花
```

或删除 `inject.bottom` 中的雪花脚本：

```yaml
inject:
  bottom:
    # - <script src="/js/effects/snowfall.js"></script>  # 注释掉
```

---

## 🔄 切换首页布局

### 使用现代布局

修改 `themes/butterfly/layout/index.ejs`,加载现代模板：

```ejs
<%包含('index-modern') %>
```

### 恢复传统布局

恢复原始 `index.ejs` 或将 `modern_cards.enable` 设为 `false`。

---

## 📱 响应式断点

断点定义在 `source/css/modern/variables.css`:

```css
:root {
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;   /* 主要断点 */
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
}
```

**移动端适配**: `max-width: 768px` 时自动切换为垂直堆叠布局。

---

## 🎭 添加自定义卡片

### 1. 创建EJS模板

创建 `themes/butterfly/layout/modern-cards/my-card.ejs`:

```ejs
<div class="card-container modern-card" style="<%= getCardPosition('myCard') %>">
  <h3>我的卡片</h3>
  <p>自定义内容</p>
</div>
```

### 2. 添加到首页

在 `index-modern.ejs` 中引入：

```ejs
<%- partial('modern-cards/my-card') %>
```

### 3. 配置位置

在 `getCardPosition()` 函数中添加：

```javascript
myCard: {
  left: 'calc(50% + 200px)',
  top: 'calc(50% - 200px)',
  width: '280px'
}
```

---

## 🐛 故障排查

### 样式未生效

1. **清理缓存**:

   ```bash
   hexo clean
   hexo generate
   ```

2. **检查文件路径**: 确保 `inject` 中的路径正确。

3. **查看浏览器控制台**: 检查CSS/JS加载错误。

### 卡片位置错乱

- **检查响应式**: 在桌面端查看（宽度 > 768px）
- **调整transform**: 确保 `transform` 属性正确
- **检查z-index**: 确保卡片层级正确

### 雪花效果卡顿

- **减少粒子数**: 降低 `count` 值
- **禁用动画**: 移除雪花脚本
- **性能优化**: 在低端设备上禁用

---

## 🔧 高级定制

### 添加新动画

在 `source/css/modern/animations.css`:

```css
@keyframes myAnimation {
  from { opacity: 0; }
  to { opacity: 1; }
}

.my-element {
  animation: myAnimation 1s ease;
}
```

### 自定义字体

在 `source/css/modern/index.css`:

```css
@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@400;700&display=swap');

body {
  font-family: 'Noto Sans SC', var(--font-sans);
}
```

---

## 📊 性能优化

### CSS优化

- **压缩CSS**: 使用构建工具压缩
- **减少导入**: 合并CSS文件
- **删除未使用样式**: 使用PurgeCSS

### JavaScript优化

- **延迟加载**: 使用 `defer` 或 `async`
- **减少粒子数**: 移动端降低动画复杂度
- **防抖throttle**: 优化scroll/resize事件

---

## 🚀 部署

确保以下文件都部署到GitHub Pages:

```bash
# 构建
hexo generate

# 部署
hexo deploy
```

或使用GitHub Actions自动部署。

---

## 📞 支持

如有问题，请查阅：

- [Hexo文档](https://hexo.io/zh-cn/docs/)
- [Butterfly主题文档](https://butterfly.js.org/)
- 提交Issue到您的GitHub仓库

---

**Made with ❤️ by CJX**
