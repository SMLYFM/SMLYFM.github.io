#!/bin/bash
# ============================================
# 博客内容清理和main分支重建脚本
# ============================================
# 作者: CJX
# 用途: 删除所有文章并清理main分支历史

set -e

echo "============================================"
echo "    博客内容清理脚本"
echo "============================================"
echo ""

# 步骤1: 提交当前更改
echo "[步骤 1/6] 提交当前更改到master分支"
echo ""

if [ -n "$(git status --porcelain)" ]; then
    echo "检测到未提交的更改:"
    git status --short
    echo ""
    
    read -p "提交信息 [默认: Refactor: 移除颜色定义]: " commit_msg
    commit_msg=${commit_msg:-"Refactor: 移除颜色定义并准备清理"}
    
    git add -A
    git commit -m "$commit_msg"
    echo "✓ 已提交"
else
    echo "✓ 工作区干净"
fi

echo ""

# 步骤2: 清理文章
echo "[步骤 2/6] 清理所有文章"
echo ""

echo "当前文章列表:"
ls -1 source/_posts/*.md 2>/dev/null || echo "  (无文章)"
echo ""

read -p "确认删除所有文章? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf source/_posts/*.md
    echo "✓ 所有文章已删除"
else
    echo "! 已跳过删除文章"
fi

echo ""

# 步骤3: 清理分类和标签目录
echo "[步骤 3/6] 清理分类和标签目录"
echo ""

rm -rf source/categories-* source/tags/
echo "✓ 分类和标签目录已清理"

echo ""

# 步骤4: 提交清理后的更改
echo "[步骤 4/6] 提交清理后的更改"
echo ""

if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "Clean: 删除所有旧文章,准备重新开始"
    git push origin master
    echo "✓ 已提交并推送到master分支"
else
    echo "✓ 无需提交"
fi

echo ""

# 步骤5: 清理main分支
echo "[步骤 5/6] 清理main分支历史"
echo ""

echo "即将清理main分支的所有历史记录"
echo "警告: 这将删除main分支的所有提交历史!"
echo ""
read -p "确认继续? [y/N] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 切换到main分支
    git checkout main
    
    # 创建新的orphan分支
    git checkout --orphan main-new
    
    # 删除所有内容
    git rm -rf .
    
    # 创建初始化README
    cat > README.md << 'EOF'
# SMLYFM Blog

个人博客静态文件部署分支

**网站**: https://smlyfm.github.io

---

此分支由Hexo自动管理,请勿手动修改。

源代码位于`master`分支。
EOF
    
    git add README.md
    git commit -m "Initial commit: 清理后的部署分支"
    
    # 删除旧main分支
    git branch -D main
    
    # 重命名新分支
    git branch -m main
    
    # 强制推送到远程
    echo ""
    echo "准备强制推送到远程..."
    read -p "最后确认: 是否强制推送? [y/N] " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push -f origin main
        echo "✓ main分支已清理并推送"
    else
        echo "! 已取消推送"
    fi
    
    # 切回master分支
    git checkout master
    
    # 清理本地仓库
    git gc --aggressive --prune=now
    echo "✓ 本地仓库已优化"
else
    echo "! 已取消清理main分支"
fi

echo ""

# 步骤6: 显示最终状态
echo "[步骤 6/6] 显示最终状态"
echo ""

echo "Git仓库大小:"
du -sh .git

echo ""
echo "当前分支:"
git branch --show-current

echo ""
echo "文章统计:"
echo "  正式文章: $(find source/_posts -name '*.md' 2>/dev/null | wc -l) 篇"

echo ""
echo "============================================"
echo "    清理完成!"
echo "============================================"
echo ""
echo "下一步:"
echo "  1. 重新设计博客UI和pages"
echo "  2. 创建新的文章"
echo "  3. 运行 make sync 部署新网站"
echo ""
