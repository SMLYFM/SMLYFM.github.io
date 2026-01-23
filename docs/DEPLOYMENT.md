# 部署指南

本文档介绍如何将博客部署到GitHub Pages。

## 目录

- [部署架构](#部署架构)
- [初始配置](#初始配置)
- [SSH密钥配置](#ssh密钥配置)
- [部署流程](#部署流程)
- [自动化部署](#自动化部署)
- [故障排查](#故障排查)

---

## 部署架构

### 双分支策略

本项目采用双分支管理:

```
┌─────────────────────────────────────────┐
│           本地开发环境                    │
│  (编写文章、修改配置、调试主题)             │
└────────────┬────────────────────────────┘
             │
             │ git push origin master
             ▼
┌─────────────────────────────────────────┐
│     GitHub: master分支                   │
│   (源代码仓库 - Markdown、配置文件等)      │
└─────────────────────────────────────────┘

             │
             │ hexo deploy
             ▼
┌─────────────────────────────────────────┐
│     GitHub: main分支                     │
│   (静态网站 - HTML、CSS、JS等)            │
│   ↓                                      │
│   GitHub Pages自动发布                    │
└─────────────────────────────────────────┘
             │
             ▼
    https://smlyfm.github.io
```

**优点**:

- 源码和生成文件分离,仓库结构清晰
- 可以随时回滚到任何历史版本
- 方便协作和版本控制

---

## 初始配置

### 1. GitHub仓库设置

确保你的GitHub仓库已创建: `SMLYFM/SMLYFM.github.io`

### 2. GitHub Pages配置

在GitHub仓库中:

1. 进入 **Settings** → **Pages**
2. **Source**: 选择 `main` 分支
3. **Folder**: 选择 `/ (root)`
4. 点击 **Save**

### 3. Hexo部署配置

编辑 `_config.yml`:

```yaml
# Deployment
deploy:
  type: git
  repo: github_yytcjx:SMLYFM/SMLYFM.github.io.git
  branch: main
```

> **注意**: 使用SSH别名 `github_yytcjx` 而不是完整的Git URL

---

## SSH密钥配置

### 为什么需要SSH?

- 无需每次输入密码
- 更安全
- 支持多账号管理

### 配置步骤

#### 1. 生成SSH密钥 (如果还没有)

```bash
ssh-keygen -t ed25519 -C "yytcjx@gmail.com" -f ~/.ssh/id_ed25519_github
```

#### 2. 添加SSH密钥到GitHub

```bash
# 复制公钥
cat ~/.ssh/id_ed25519_github.pub

# 或使用xclip直接复制到剪贴板
xclip -sel clip < ~/.ssh/id_ed25519_github.pub
```

访问 [GitHub SSH设置](https://github.com/settings/keys),点击 **New SSH key**:

- **Title**: `Fedora 43 - Blog Deployment`
- **Key**: 粘贴公钥内容

#### 3. 配置SSH别名

编辑 `~/.ssh/config`:

```
Host github_yytcjx
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes
```

#### 4. 测试连接

```bash
ssh -T github_yytcjx
```

应该看到:

```
Hi SMLYFM! You've successfully authenticated, but GitHub does not provide shell access.
```

#### 5. 配置Git远程仓库

```bash
# 查看当前远程配置
git remote -v

# 如果需要修改
git remote set-url origin github_yytcjx:SMLYFM/SMLYFM.github.io.git
```

---

## 部署流程

### 方式1: 一键部署 (推荐)

```bash
npm run deploy
```

这个脚本会自动:

1. ✅ 提交源码到master分支
2. ✅ 清理缓存
3. ✅ 生成静态文件
4. ✅ 部署到main分支

### 方式2: 手动部署

#### 步骤1: 提交源码到master分支

```bash
git add .
git commit -m "Update: 添加新文章"
git push origin master
```

#### 步骤2: 生成静态文件

```bash
npm run build
```

#### 步骤3: 部署到main分支

```bash
npx hexo deploy
```

### 方式3: 仅部署(不提交源码)

如果你只想更新网站,不提交源码:

```bash
npm run build
npx hexo deploy
```

---

## 自动化部署

### 使用GitHub Actions (推荐)

创建 `.github/workflows/deploy.yml`:

```yaml
name: Deploy Hexo Blog

on:
  push:
    branches:
      - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: true
          fetch-depth: 0
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install Dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
      
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./public
          publish_branch: main
          user_name: 'github-actions[bot]'
          user_email: 'github-actions[bot]@users.noreply.github.com'
```

**优点**:

- 推送到master分支自动触发部署
- 无需本地运行`hexo deploy`
- 部署日志可追溯

**启用方法**:

1. 创建上述文件
2. 提交到master分支
3. 推送到GitHub
4. GitHub Actions会自动运行

---

## 部署验证

### 检查清单

部署完成后,验证以下内容:

- [ ] 网站可以访问: <https://smlyfm.github.io>
- [ ] 最新文章已显示
- [ ] 样式、图片正常加载
- [ ] 代码高亮正常
- [ ] 搜索功能正常
- [ ] 分类/标签页面正常
- [ ] 响应式布局正常

### 查看部署状态

#### GitHub仓库

访问仓库的 **Environments** → **github-pages**,查看部署历史

#### 本地检查

```bash
# 查看main分支的最新提交
git log main -n 5 --oneline

# 查看部署分支
ls -la .deploy_git/
```

---

## 故障排查

### 问题1: 部署失败 - SSH认证失败

**错误信息**:

```
fatal: Could not read from remote repository.
Please make sure you have the correct access rights
```

**解决方案**:

1. 检查SSH密钥是否添加到GitHub
2. 测试SSH连接: `ssh -T github_yytcjx`
3. 确认`_config.yml`中的repo地址正确

### 问题2: 部署后网站404

**原因**: GitHub Pages还在构建中

**解决**:

- 等待3-5分钟
- 检查GitHub仓库的Actions/Pages构建状态

### 问题3: 样式丢失

**原因**: URL配置不正确

**解决**:

```yaml
# _config.yml
url: https://smlyfm.github.io/
root: /
```

### 问题4: 图片无法显示

**检查**:

1. 图片路径是否正确
2. 是否启用了`post_asset_folder`
3. 图片文件是否已提交到Git

### 问题5: main分支提交历史过多,仓库体积大

**解决**: 使用orphan分支重建

参考 [清理main分支](#清理main分支)

---

## 清理main分支

如果main分支的Git历史导致仓库体积过大,可以清理:

### 方法: Orphan分支重建

```bash
# 1. 切换到main分支
git checkout main

# 2. 创建新的orphan分支
git checkout --orphan main-new

# 3. 删除所有文件
git rm -rf .

# 4. 创建初始提交
echo "# SMLYFM Blog" > README.md
git add README.md
git commit -m "Initial commit for deployment branch"

# 5. 删除旧main分支
git branch -D main

# 6. 重命名新分支
git branch -m main

# 7. 强制推送到远程
git push -f origin main

# 8. 回到master分支
git checkout master

# 9. 清理本地缓存
git gc --aggressive --prune=now
```

**注意**: 这会删除所有部署历史,但不影响源码(master分支)

---

## 部署最佳实践

### 1. 提交前预览

```bash
npm run dev
# 在浏览器中检查文章
```

### 2. 使用语义化提交

```bash
git commit -m "Update: 添加Rust学习笔记"
git commit -m "Fix: 修复代码高亮bug"
git commit -m "Feat: 添加评论功能"
```

### 3. 定期备份

```bash
# 定期推送到远程
git push origin master
```

### 4. 监控部署状态

- 订阅GitHub仓库的通知
- 检查GitHub Actions运行状态
- 定期访问网站验证

---

## 部署时间表

| 操作 | 预计时间 |
|------|---------|
| 生成静态文件 | 10-30秒 |
| 推送到GitHub | 5-15秒 |
| GitHub Pages构建 | 1-3分钟 |
| **总计** | **约2-4分钟** |

---

## 相关资源

- [GitHub Pages文档](https://docs.github.com/en/pages)
- [GitHub Actions文档](https://docs.github.com/en/actions)
- [Hexo部署文档](https://hexo.io/zh-cn/docs/one-command-deployment)
- [SSH密钥配置](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)

---

## 获取帮助

部署遇到问题?

- 查看[开发指南](./DEVELOPMENT.md)
- 查看[Hexo故障排查](https://hexo.io/zh-cn/docs/troubleshooting.html)
- 提交[GitHub Issue](https://github.com/SMLYFM/SMLYFM.github.io/issues)
