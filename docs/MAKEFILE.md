# Makefile 使用指南

本文档详细介绍博客项目中Makefile的使用方法。

## 📋 目录

- [快速开始](#快速开始)
- [常用命令](#常用命令)
- [内容管理](#内容管理)
- [构建部署](#构建部署)
- [维护工具](#维护工具)
- [高级功能](#高级功能)
- [📐 数学公式写作注意事项](#-数学公式写作注意事项)

---

## 快速开始

### 查看所有命令

```bash
make help
# 或简单使用
make
```

这将显示所有可用命令和说明。

### 环境检查

```bash
make check
```

检查项目状态,包括:

- Node.js 和 npm 版本
- Hexo 版本
- Git 状态
- 文章统计

---

## 常用命令

### 项目管理

| 命令 | 说明 | 示例 |
|------|------|------|
| `make install` | 安装项目依赖 | `make install` |
| `make upgrade` | 升级依赖包 | `make upgrade` |
| `make check` | 检查项目状态 | `make check` |
| `make status` | 查看Git状态 | `make status` |

---

## 内容管理

### 创建新文章

#### 方式1: 交互式创建(推荐)

```bash
make new
```

运行交互式脚本,引导你输入标题、分类、标签等。

#### 方式2: 指定标题创建

```bash
make new TITLE="我的第一篇文章"
```

使用Hexo原生命令快速创建。

#### 方式3: 使用模板创建(最强大)

```bash
make template-post TITLE="Rust学习笔记" CAT="tech" TAGS="rust programming"
```

创建带有完整模板的文章,包括:

- 自动填充时间戳
- 预定义分类和标签
- 结构化的内容模板

**参数说明**:

- `TITLE`: 文章标题(必需)
- `CAT`: 分类(可选,默认: blog)
- `TAGS`: 标签,空格分隔(可选)

**示例**:

```bash
# 技术文章
make template-post TITLE="Docker容器化实践" CAT="tech" TAGS="docker devops"

# 数学文章
make template-post TITLE="偏微分方程入门" CAT="math" TAGS="pde analysis"

# 生活文章
make template-post TITLE="2026年总结" CAT="life" TAGS="summary"
```

---

### 创建草稿

```bash
make draft TITLE="草稿标题"
```

草稿保存在`source/_drafts/`,不会发布到网站。

---

### 发布草稿

```bash
make publish DRAFT="草稿名"
```

将草稿移动到`source/_posts/`,成为正式文章。

---

### 列出所有文章

```bash
make list
```

显示所有正式文章和草稿。

---

### 使用Markdown模板生成器

```bash
bash tools/create-markdown.sh
```

提供4种专业模板:

1. **基础文章** - 适合一般内容
2. **技术文章** - 包含代码块、技术选型、性能对比等
3. **数学/学术文章** - 支持LaTeX公式、定理证明
4. **教程文章** - 包含步骤、常见问题、最佳实践

**特性**:

- ✅ 自动填充当前时间
- ✅ 智能分类和标签
- ✅ 预定义内容结构
- ✅ 支持草稿和正式文章
- ✅ 可选择是否立即打开编辑器

---

## 构建部署

### 本地开发

```bash
# 启动本地服务器(不含草稿)
make server
# 或使用别名
make s

# 开发模式(包含草稿)
make dev
# 或使用别名
make d
```

访问 `http://localhost:4000` 预览博客。

---

### 清理缓存

```bash
make clean
# 或使用别名
make c
```

清理Hexo缓存和生成的文件。

---

### 构建网站

```bash
make build
# 或使用别名
make b
```

生成静态文件到`public/`目录。

---

### 部署到GitHub Pages

```bash
make deploy
# 或使用别名
make dp
```

将静态文件部署到`main`分支。

---

### 一键同步(推荐)

```bash
make sync
```

**这是最常用的命令!**

自动执行以下步骤:

1. 提交源码到`master`分支
2. 推送到远程仓库
3. 清理缓存
4. 构建静态文件
5. 部署到`main`分支

**完整的写作→发布流程**:

```bash
# 1. 创建文章
make new TITLE="新文章"

# 2. 编写内容...

# 3. 一键同步
make sync
```

---

## 维护工具

### Git操作

#### 提交并推送源码

```bash
make push
# 或使用别名
make p
```

交互式提交并推送到`master`分支。

#### 拉取远程更新

```bash
make pull
```

从远程仓库拉取最新更改。

---

### 备份与恢复

#### 备份博客内容

```bash
make backup
```

将`source/`、配置文件等打包备份到`../backup/`目录。

**备份内容**:

- source/ (所有文章和资源)
- _config.yml
- _config.butterfly.yml
- package.json

**不备份**:

- node_modules/
- public/
- .deploy_git/
- .git/

#### 恢复备份

```bash
make restore
```

恢复最新的备份文件。

---

## 高级功能

### 文章统计

#### 字数统计

```bash
make count
```

统计每篇文章的字数和总字数。

**示例输出**:

```
hello-world.md                                        150 字
Rust-学习.md                                          2340 字
my-first-rust-article.md                              890 字

总计: 5 篇文章, 8920 字
```

---

### 搜索文章

```bash
make grep-posts KEYWORD="关键词"
```

在所有文章中搜索关键词。

**示例**:

```bash
make grep-posts KEYWORD="Docker"
make grep-posts KEYWORD="函数"
```

---

### 监听文件变化

```bash
make watch
```

监听`source/`目录的变化,自动重新构建。

**注意**: 需要安装`inotify-tools`:

```bash
sudo dnf install inotify-tools
```

---

### CI/CD命令

#### CI测试

```bash
make ci-test
```

模拟CI环境进行测试:

- 使用`npm ci`安装依赖(更快)
- 清理缓存
- 构建静态文件

#### CI部署

```bash
make ci-deploy
```

CI环境完整部署流程。

---

### 版本信息

```bash
make version
```

显示详细的版本信息:

- Node.js, npm, Hexo版本
- Git分支和提交信息
- 项目路径

---

### 依赖管理

#### 查看依赖树

```bash
make deps-tree
```

显示顶层依赖包。

#### 安全审计

```bash
make audit
```

检查依赖的安全漏洞。

---

## 别名命令

为了提高效率,Makefile提供了简短的别名:

| 别名 | 原命令 | 说明 |
|------|--------|------|
| `make s` | `make server` | 启动服务器 |
| `make d` | `make dev` | 开发模式 |
| `make b` | `make build` | 构建 |
| `make dp` | `make deploy` | 部署 |
| `make n` | `make new` | 新文章 |
| `make p` | `make push` | 推送 |
| `make l` | `make list` | 列表 |
| `make c` | `make clean` | 清理 |

---

## 工作流示例

### 日常写作流程

```bash
# 1. 检查项目状态
make check

# 2. 创建新文章(使用模板)
make template-post TITLE="深入理解Rust所有权" CAT="tech" TAGS="rust programming"

# 3. 编辑文章
nvim source/_posts/深入理解Rust所有权.md

# 4. 本地预览
make dev

# 5. 满意后,一键同步
make sync
```

---

### 协作开发流程

```bash
# 1. 拉取最新更新
make pull

# 2. 查看状态
make status

# 3. 进行修改...

# 4. 提交并推送
make push

# 5. 部署
make deploy
```

---

### 定期维护流程

```bash
# 1. 备份内容
make backup

# 2. 升级依赖
make upgrade

# 3. 安全审计
make audit

# 4. 统计文章
make count
make list
```

---

## 脚本说明

### tools/deploy.sh

增强的部署脚本,提供:

- ✅ 完整的环境检查
- ✅ Git状态摘要
- ✅ 交互式提交
- ✅ 构建和部署
- ✅ 错误处理和提示

**使用**:

```bash
# 交互模式
bash tools/deploy.sh

# 自动模式
bash tools/deploy.sh manual
```

---

### tools/create-markdown.sh

专业的Markdown模板生成器。

**使用**:

```bash
bash tools/create-markdown.sh
```

**生成的模板包含**:

- Front Matter(标题、日期、分类、标签)
- 结构化内容框架
- 相关元数据
- 代码块示例(技术文章)
- 数学公式框架(学术文章)
- 步骤指南(教程)

---

## 常见问题

### Q: make命令找不到?

**A**: 确保已安装`make`:

```bash
sudo dnf install make
```

### Q: 如何自定义Makefile?

**A**: 编辑项目根目录的`Makefile`文件:

```bash
nvim Makefile
```

### Q: 模板文章的格式如何修改?

**A**: 编辑`tools/create-markdown.sh`,修改相应的模板函数。

### Q: 如何添加新的分类和标签?

**A**:

1. 编辑`_config.yml`中的`category_map`和`tag_map`
2. 编辑`tools/create-markdown.sh`中的分类选项

---

## 最佳实践

### 1. 使用模板创建文章

优先使用`make template-post`或`tools/create-markdown.sh`,它们提供:

- 一致的结构
- 完整的元数据
- 专业的格式

### 2. 定期备份

```bash
# 每周备份
make backup
```

### 3. 使用sync命令

```bash
# 替代多个命令
make sync
```

一步完成所有操作。

### 4. 利用别名

```bash
make d   # 比 make dev 更快
make s   # 比 make server 更快
```

### 5. 监听模式开发

```bash
make watch
```

修改文件自动重新构建。

---

## 📐 数学公式写作注意事项

> **💡 重要提示**：Hexo 使用 markdown 渲染器处理文章，某些 LaTeX 语法可能与 markdown 冲突。以下是常见问题和解决方案。

### 1. 下划线转义问题

**问题**：在列表项或行内公式中，下划线 `_` 可能被解析为斜体标记，导致公式渲染失败。

**❌ 错误写法**：

```markdown
- $\aleph_{\alpha+1}$ = $\aleph_\alpha$ 的后继基数
- $L_{\alpha+1} = \text{Def}(L_\alpha)$
```

渲染结果：`$\aleph{\alpha+1}=\aleph\alpha$`（下划线被吃掉）

**✅ 正确写法**：使用 `\_` 转义下划线

```markdown
- $\aleph\_{\alpha+1}$ = $\aleph\_\alpha$ 的后继基数
- $L\_{\alpha+1} = \text{Def}(L\_\alpha)$
```

### 2. 小于号问题

**问题**：`<` 符号可能被解析为 HTML 标签开始。

**❌ 错误写法**：

```markdown
对于所有 $\alpha < \beta$，有...
```

**✅ 正确写法**：在 `<` 前后加空格，或使用块级公式

```markdown
对于所有 $\alpha \lt \beta$，有...
```

或使用双美元符号块级公式：

```markdown
$$
\alpha < \beta
$$
```

### 3. 花括号问题

**问题**：单独的 `{` `}` 在某些情况下可能导致解析错误。

**✅ 最佳实践**：复杂公式使用块级显示

```markdown
$$
f(x) = \begin{cases}
  x^2 & \text{if } x > 0 \\
  0 & \text{otherwise}
\end{cases}
$$
```

### 4. 推荐的公式写作方式

| 场景 | 推荐写法 | 说明 |
|------|----------|------|
| 简单行内公式 | `$x^2 + y^2$` | 无下划线，无特殊符号 |
| 带下标的行内公式 | `$a\_i + b\_j$` | 转义下划线 |
| 复杂公式 | `$$...$$` 块级 | 避免 markdown 解析干扰 |
| 列表中的公式 | 转义下划线 | 列表环境更容易出问题 |

### 5. Front Matter 配置

确保在包含数学公式的文章 Front Matter 中启用 MathJax：

```yaml
---
title: 我的数学文章
mathjax: true  # 必须添加
---
```

### 6. 验证公式渲染

```bash
# 本地预览
make dev

# 访问 http://localhost:4000 检查公式是否正确渲染
```

### 7. 常见符号转义速查

| 符号 | Markdown 中的问题 | 解决方案 |
|------|------------------|----------|
| `_` | 被解析为斜体 | 使用 `\_` |
| `*` | 被解析为加粗/斜体 | 使用 `\*` |
| `<` | 被解析为 HTML | 使用 `\lt` 或块级公式 |
| `>` | 被解析为引用 | 使用 `\gt` 或块级公式 |
| `|` | 表格分隔符冲突 | 使用 `\|` 或 `\vert` |
| `\\` | 换行符 | 使用 `\\\\` 在行内公式中 |

### 8. 示例：正确编写复杂数学文章

```markdown
## 阿列夫数

无穷基数用 $\aleph$（aleph）表示：

- $\aleph\_0 = |\mathbb{N}|$（最小无穷基数）
- $\aleph\_1$ = 最小不可数基数
- $\aleph\_{\alpha+1}$ = $\aleph\_\alpha$ 的后继基数

对于极限情形，有：

$$
\aleph_\lambda = \sup_{\alpha < \lambda} \aleph_\alpha
$$

**广义连续统假设（GCH）**：

$$
2^{\aleph_\alpha} = \aleph_{\alpha+1}
$$
```

## 技术细节

### Makefile特性

- 使用`.PHONY`声明伪目标
- 彩色输出提升可读性
- 自动生成帮助文档
- 变量化配置
- 错误处理

### 时间戳变量

Makefile中定义的时间变量:

- `TIMESTAMP`: 完整时间戳 (YYYY-MM-DD HH:MM:SS)
- `DATE`: 日期 (YYYY-MM-DD)
- `TIME`: 时间 (HH:MM:SS)

### 目录变量

- `POST_DIR`: 文章目录
- `DRAFT_DIR`: 草稿目录
- `PUBLIC_DIR`: 构建输出目录
- `DEPLOY_DIR`: 部署临时目录

---

## 参考资料

- [GNU Make文档](https://www.gnu.org/software/make/manual/)
- [Hexo文档](https://hexo.io/zh-cn/docs/)
- [Bash脚本教程](https://www.gnu.org/software/bash/manual/)

---

## 总结

Makefile提供了完整的博客管理解决方案:

✅ **一体化管理**: 从创建到部署的全流程  
✅ **高效工作流**: 单命令完成复杂操作  
✅ **专业模板**: 多种文章类型模板  
✅ **自动化**: Git、构建、部署自动化  
✅ **易用性**: 清晰的帮助文档和别名

**立即开始使用**:

```bash
make help   # 查看所有命令
make check  # 检查项目状态
make sync   # 一键同步发布
```

---

**更新日期**: 2026-01-23  
**作者**: CJX  
**项目**: SMLYFM.github.io
