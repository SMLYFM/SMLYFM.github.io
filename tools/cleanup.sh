#!/bin/bash
# ============================================
# 博客内容清理和main分支重建脚本
# ============================================
# 💡 作者: CJX
# 💡 用途: 删除所有文章并清理main分支历史

set -e

# ============================================
# 颜色定义
# ============================================
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
DIM='\033[2m'
NC='\033[0m' # No Color

# ============================================
# 工具函数
# ============================================
print_success() { echo -e "${GREEN}✓ $1${NC}"; }
print_error() { echo -e "${RED}✗ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠ $1${NC}"; }
print_info() { echo -e "${BLUE}ℹ $1${NC}"; }

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}    博客内容清理脚本${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# 步骤1: 提交当前更改
echo -e "${CYAN}[步骤 1/6]${NC} ${YELLOW}提交当前更改到master分支${NC}"
echo ""

if [ -n "$(git status --porcelain)" ]; then
    print_info "检测到未提交的更改:"
    git status --short
    echo ""
    
    read -p "$(echo -e ${CYAN}提交信息 [默认: Refactor: 移除颜色定义]:${NC} )" commit_msg
    commit_msg=${commit_msg:-"Refactor: 移除颜色定义并准备清理"}
    
    git add -A
    git commit -m "$commit_msg"
    print_success "已提交"
else
    print_success "工作区干净"
fi

echo ""

# 步骤2: 清理文章
echo -e "${CYAN}[步骤 2/6]${NC} ${YELLOW}清理所有文章${NC}"
echo ""

echo -e "${BLUE}当前文章列表:${NC}"
ls -1 source/_posts/*.md 2>/dev/null || echo -e "  ${DIM}(无文章)${NC}"
echo ""

read -p "$(echo -e ${YELLOW}确认删除所有文章? [y/N]:${NC} )" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf source/_posts/*.md
    print_success "所有文章已删除"
else
    print_warning "已跳过删除文章"
fi

echo ""

# 步骤3: 清理分类和标签目录
echo -e "${CYAN}[步骤 3/6]${NC} ${YELLOW}清理分类和标签目录${NC}"
echo ""

rm -rf source/categories-* source/tags/
print_success "分类和标签目录已清理"

echo ""

# 步骤4: 提交清理后的更改
echo -e "${CYAN}[步骤 4/6]${NC} ${YELLOW}提交清理后的更改${NC}"
echo ""

if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "Clean: 删除所有旧文章,准备重新开始"
    git push origin master
    print_success "已提交并推送到master分支"
else
    print_success "无需提交"
fi

echo ""

# 步骤5: 清理main分支
echo -e "${CYAN}[步骤 5/6]${NC} ${YELLOW}清理main分支历史${NC}"
echo ""

print_info "即将清理main分支的所有历史记录"
print_warning "这将删除main分支的所有提交历史!"
echo ""
read -p "$(echo -e ${RED}确认继续? [y/N]:${NC} )" -n 1 -r
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
    print_info "准备强制推送到远程..."
    read -p "$(echo -e ${RED}最后确认: 是否强制推送? [y/N]:${NC} )" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push -f origin main
        print_success "main分支已清理并推送"
    else
        print_warning "已取消推送"
    fi
    
    # 切回master分支
    git checkout master
    
    # 清理本地仓库
    git gc --aggressive --prune=now
    print_success "本地仓库已优化"
else
    print_warning "已取消清理main分支"
fi

echo ""

# 步骤6: 显示最终状态
echo -e "${CYAN}[步骤 6/6]${NC} ${YELLOW}显示最终状态${NC}"
echo ""

echo -e "${BLUE}Git仓库大小:${NC}"
du -sh .git

echo ""
echo -e "${BLUE}当前分支:${NC}"
git branch --show-current

echo ""
echo -e "${BLUE}文章统计:${NC}"
echo -e "  正式文章: ${GREEN}$(find source/_posts -name '*.md' 2>/dev/null | wc -l)${NC} 篇"

echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}    🎉 清理完成!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}下一步:${NC}"
echo -e "  ${CYAN}1.${NC} 重新设计博客UI和pages"
echo -e "  ${CYAN}2.${NC} 创建新的文章"
echo -e "  ${CYAN}3.${NC} 运行 ${GREEN}make sync${NC} 部署新网站"
echo ""
