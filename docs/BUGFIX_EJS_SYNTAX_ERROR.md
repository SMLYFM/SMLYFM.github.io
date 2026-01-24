# Hexo EJS 模板语法错误深度分析与修复报告

**日期**: 2026-01-23  
**问题**: `SyntaxError: Unexpected token ':' in index-modern.ejs`  
**状态**: ✅ 已解决

---

## 📋 问题症状

执行 `hexo generate` 时出现以下错误：

```
ERROR Process failed: layout/index-modern.ejs
SyntaxError: Unexpected token ':' in /home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/index-modern.ejs while compiling ejs
```

随后引发连锁错误：

```
ERROR
Error: /home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/index.ejs:1
 >> 1| <%- partial('index-modern') %>

Partial index-modern does not exist. (in index.ejs)
```

---

## 🔍 根本原因分析

### **核心问题 1: EJS 代码块格式化错误**

**位置**: [`themes/butterfly/layout/index-modern.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/index-modern.ejs) 第 3-12 行

**问题代码**:

```ejs
<% // 💡 卡片位置计算函数（桌面端绝对定位） function getCardPosition(cardName) { // 服务器端渲染时无window对象，直接返回绝对定位样式 var positions={ hiCard:
    { left: '50%' , top: '50%' , transform: 'translate(-50%, -50%)' , width: '360px' }, articleCard: {
    left: 'calc(50% + 400px)' , top: '50%' , transform: 'translate(0, -50%)' , width: '320px' }, clockCard: {
    // ... 更多压缩代码
    return styleStr; } %>
```

**原因**:

1. JavaScript 对象字面量 `{ left: '50%' }` 中的冒号 `:` 被 EJS 解析器误认为是模板语法
2. 整个函数定义被压缩成几行，违反了 EJS 的语法规则
3. 代码块未正确闭合，导致编译失败

---

### **核心问题 2: Partial 模板作用域问题**

**位置**:

- [`modern-cards/hi-card.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/modern-cards/hi-card.ejs)
- [`modern-cards/article-card.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/modern-cards/article-card.ejs)
- [`modern-cards/clock-card.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/modern-cards/clock-card.ejs)
- [`modern-cards/social-card.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/modern-cards/social-card.ejs)

**问题代码**:

```ejs
<div class="card-container modern-card hi-card" style="<%= getCardPosition('hiCard') %>">
```

**原因**:
子模板（partial）尝试调用在父模板中定义的 `getCardPosition()` 函数，但在 Hexo EJS 中：

- **Partial 模板拥有独立的作用域**
- 父模板中定义的函数无法在子模板中访问
- 导致 `ReferenceError: getCardPosition is not defined`

---

### **核心问题 3: 变量声明问题**

**位置**: [`modern-cards/article-card.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/modern-cards/article-card.ejs)

**原始代码**:

```ejs
<% const recentPosts = site.posts.sort('date', -1).limit(5).toArray(); %>
```

**问题**:
使用 `const` 声明的变量在某些 EJS 版本中可能存在作用域问题，应使用 `var`

---

## ✅ 解决方案

### **Solution 1: 移除 JavaScript 函数逻辑**

将卡片定位从 JavaScript 计算改为 **纯 CSS 样式**：

**修改后的** [`index-modern.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/index-modern.ejs):

```ejs
<%# 现代首页布局 💡 卡片式设计，不包含完整HTML结构，由Hexo自动注入 %>

<!-- 💡 雪花背景Canvas -->
<div class="modern-background">
  <canvas id="snowfall-canvas"></canvas>
</div>

<!-- 💡 主内容区 -->
<main id="content-inner" class="modern-homepage">
  <%# Hi Card - 个人介绍卡片 %>
  <%- partial('modern-cards/hi-card') %>
  
  <%# Article Card - 最新文章卡片 %>
  <%- partial('modern-cards/article-card') %>
  
  <!-- 其他卡片... -->
</main>
```

---

### **Solution 2: 使用 CSS 定位替代 JavaScript**

在 [`source/css/modern/index.css`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/source/css/modern/index.css) 中添加：

```css
/* 💡 桌面端:绝对定位卡片布局 */
@media screen and (min-width: 768px) {
    .modern-homepage {
        position: relative;
        height: 100vh;
        overflow: hidden;
    }

    .modern-homepage .card-container {
        position: absolute;
    }

    /* 💡 Hi Card - 居中主卡片 */
    .modern-homepage .hi-card {
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 360px;
    }

    /* 💡 Article Card - 右侧文章卡片 */
    .modern-homepage .article-card {
        left: calc(50% + 400px);
        top: 50%;
        transform: translate(0, -50%);
        width: 320px;
    }

    /* 💡 Clock Card - 左上时钟卡片 */
    .modern-homepage .clock-card {
        left: calc(50% - 400px);
        top: calc(50% - 150px);
        transform: translate(-100%, 0);
        width: 220px;
    }

    /* 💡 Social Card - 左下社交卡片 */
    .modern-homepage .social-card {
        left: calc(50% - 400px);
        top: calc(50% + 100px);
        transform: translate(-100%, 0);
        width: 220px;
    }

    /* 💡 Calendar Card - 右上日历卡片 */
    .modern-homepage .calendar-card {
        left: calc(50% + 200px);
        top: calc(50% - 200px);
        width: 280px;
    }
}
```

---

### **Solution 3: 修复所有 Partial 模板**

移除所有 `getCardPosition()` 调用，使用纯 CSS 类名：

**修改前**:

```ejs
<div class="card-container modern-card hi-card" style="<%= getCardPosition('hiCard') %>">
```

**修改后**:

```ejs
<div class="card-container modern-card hi-card">
```

受影响文件：

- ✅ `modern-cards/hi-card.ejs`
- ✅ `modern-cards/article-card.ejs`
- ✅ `modern-cards/clock-card.ejs`
- ✅ `modern-cards/social-card.ejs`
- ✅ `modern-cards/calendar-card.ejs`

---

### **Solution 4: 标准化变量声明**

将 `const` 改为 `var` 以确保兼容性：

```ejs
<% var recentPosts = site.posts.sort('date', -1).limit(5).toArray(); %>
```

---

### **Solution 5: 规范化 EJS 代码块格式**

重写 [`calendar-card.ejs`](file:///home/yyt/Documents/Blog/SMLYFM.github.io/themes/butterfly/layout/modern-cards/calendar-card.ejs)，确保：

1. **每个 EJS 标签独占一行或正确闭合**
2. **JavaScript 代码块内使用标准格式**
3. **避免在单行中混合多个语句**

```ejs
<%
var now = new Date();
var year = now.getFullYear();
var month = now.getMonth();
var postsThisMonth = [];
var postDates = [];

if (site.posts && site.posts.length > 0) {
  site.posts.forEach(function(post) {
    if (post.date) {
      var postDate = post.date.toDate();
      if (postDate.getFullYear() === year && postDate.getMonth() === month) {
        postsThisMonth.push(post);
        postDates.push(post.date.date());
      }
    }
  });
}

var firstDay = new Date(year, month, 1).getDay();
var daysInMonth = new Date(year, month + 1, 0).getDate();
%>
```

---

## 📊 修复效果验证

### **构建测试**

```bash
hexo clean && hexo generate
```

**结果**:

```
INFO  15 files generated in 17 ms  ✅
```

### **服务器测试**

```bash
hexo server
```

**结果**:

```
INFO  Hexo is running at http://localhost:4000/ . Press Ctrl+C to stop.  ✅
```

---

## 🎯 架构改进优势

### **Before (JavaScript 动态定位)**

- ❌ 需要在服务端执行 JavaScript 函数
- ❌ Partial 模板作用域限制
- ❌ EJS 语法复杂度高
- ❌ 难以调试和维护

### **After (CSS 静态定位)**

- ✅ 纯 CSS 实现，性能更优
- ✅ 关注点分离（样式归 CSS 管理）
- ✅ 响应式布局更灵活
- ✅ 易于维护和调试
- ✅ 符合现代 Web 最佳实践

---

## 🛡️ 预防措施

### **EJS 模板编写规范**

1. **避免在 `<% %>` 中编写复杂逻辑**

   ```ejs
   <!-- ❌ 不推荐 -->
   <% var obj = { key: 'value', nested: { a: 1 } }; %>
   
   <!-- ✅ 推荐 -->
   <%
   var obj = {
     key: 'value',
     nested: { a: 1 }
   };
   %>
   ```

2. **使用 `var` 替代 `const`/`let` 以确保兼容性**

3. **将样式逻辑移至 CSS 文件**
   - JavaScript 仅用于动态数据处理
   - 布局和定位交给 CSS

4. **定期使用 EJS-Lint 检查**

   ```bash
   npm install -g ejs-lint
   ejs-lint themes/butterfly/layout/**/*.ejs
   ```

---

## 📚 相关资源

- [Hexo 模板文档](https://hexo.io/docs/templates.html)
- [EJS 语法指南](https://ejs.co/#docs)
- [CSS Grid 布局](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout)
- [现代 CSS 定位](https://developer.mozilla.org/en-US/docs/Web/CSS/position)

---

## 🎉 总结

通过 **架构重构** 替代简单的语法修复，我们不仅解决了当前的 EJS 编译错误，还：

1. **提升了代码质量** - 关注点分离，CSS 负责样式
2. **增强了可维护性** - 纯声明式布局，无需 JavaScript 计算
3. **改善了性能** - 服务端渲染无需执行函数
4. **符合最佳实践** - 现代 Web 开发标准

博客现已成功运行在 `http://localhost:4000`！✨
