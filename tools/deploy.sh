#!/bin/bash
# ============================================
# Hexo 博客全功能部署脚本
# ============================================
# 💡 集成源码提交、构建和部署功能
# 💡 作者: CJX
# 💡 支持交互式和非交互式模式

set -e

# ============================================
# 颜色和样式定义
# ============================================
BOLD=''
DIM=''
GREEN=''
BLUE=''
YELLOW=''
RED=''
CYAN=''
NC=''

# ============================================
# 配置变量
# ============================================
GIT_BRANCH_SOURCE="master"
GIT_BRANCH_DEPLOY="main"
GIT_REMOTE="origin"

# 模式: auto(自动) / manual(手动)
MODE="${1:-auto}"

# ============================================
# 工具函数
# ============================================

# 打印带颜色的消息
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}${BOLD}    $1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_step() {
    echo -e "${CYAN}${BOLD}[$1/$2]${NC} ${YELLOW}$3${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 获取Git状态摘要
git_status_summary() {
    local modified=$(git status --porcelain | grep '^ M' | wc -l)
    local added=$(git status --porcelain | grep '^A' | wc -l)
    local deleted=$(git status --porcelain | grep '^ D' | wc -l)
    local untracked=$(git status --porcelain | grep '^??' | wc -l)
    
    echo "修改: ${modified} | 新增: ${added} | 删除: ${deleted} | 未跟踪: ${untracked}"
}

# ============================================
# 主要功能
# ============================================

# 步骤1: 环境检查
check_environment() {
    print_step 1 5 "环境检查"
    echo ""
    
    # 检查必要命令
    local required_cmds=("git" "node" "npm")
    for cmd in "${required_cmds[@]}"; do
        if command_exists "$cmd"; then
            local version
            case "$cmd" in
                node) version=$(node --version) ;;
                npm) version=$(npm --version) ;;
                git) version=$(git --version | cut -d' ' -f3) ;;
            esac
            print_success "$cmd: $version"
        else
            print_error "$cmd 未安装"
            exit 1
        fi
    done
    
    # 检查Hexo
    if npx hexo version >/dev/null 2>&1; then
        local hexo_ver=$(npx hexo version | grep hexo: | cut -d':' -f2 | xargs)
        print_success "Hexo: $hexo_ver"
    else
        print_error "Hexo 未安装或配置不正确"
        exit 1
    fi
    
    echo ""
}

# 步骤2: Git状态检查
check_git_status() {
    print_step 2 5 "检查Git状态"
    echo ""
    
    # 检查是否在Git仓库中
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "不在Git仓库中"
        exit 1
    fi
    
    # 检查当前分支
    local current_branch=$(git branch --show-current)
    if [ "$current_branch" != "$GIT_BRANCH_SOURCE" ]; then
        print_warning "当前分支: $current_branch (期望: $GIT_BRANCH_SOURCE)"
        read -p "是否切换到 $GIT_BRANCH_SOURCE 分支? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git checkout $GIT_BRANCH_SOURCE
            print_success "已切换到 $GIT_BRANCH_SOURCE 分支"
        else
            print_info "继续在 $current_branch 分支操作"
        fi
    else
        print_success "当前分支: $current_branch"
    fi
    
    # 显示未提交的更改
    if [ -n "$(git status --porcelain)" ]; then
        echo ""
        print_info "$(git_status_summary)"
        echo ""
        git status --short | head -20
        if [ $(git status --porcelain | wc -l) -gt 20 ]; then
            echo "${DIM}... 还有 $(($(git status --porcelain | wc -l) - 20)) 个文件${NC}"
        fi
    else
        print_success "工作区干净"
    fi
    
    echo ""
}

# 步骤3: 提交源码
commit_source() {
    print_step 3 5 "提交源码到 $GIT_BRANCH_SOURCE"
    echo ""
    
    # 检查是否有更改
    if [ -z "$(git status --porcelain)" ]; then
        print_info "没有需要提交的更改"
        echo ""
        return 0
    fi
    
    # 获取提交信息
    local commit_msg=""
    
    if [ "$MODE" = "auto" ]; then
        # 自动模式:交互式输入
        echo -e "${CYAN}请输入提交信息:${NC}"
        read -e commit_msg
        
        if [ -z "$commit_msg" ]; then
            commit_msg="Update: $(date '+%Y-%m-%d %H:%M:%S')"
            print_info "使用默认提交信息: $commit_msg"
        fi
    else
        # 手动模式:使用默认信息
        commit_msg="Update: $(date '+%Y-%m-%d %H:%M:%S')"
        print_info "提交信息: $commit_msg"
    fi
    
    # 执行提交
    git add .
    git commit -m "$commit_msg"
    
    print_success "源码已提交"
    
    # 推送到远程
    echo ""
    print_info "推送到远程 $GIT_REMOTE/$GIT_BRANCH_SOURCE..."
    
    if git push $GIT_REMOTE $GIT_BRANCH_SOURCE; then
        print_success "推送成功"
    else
        print_error "推送失败"
        exit 1
    fi
    
    echo ""
}

# 步骤4: 构建网站
build_site() {
    print_step 4 5 "构建静态网站"
    echo ""
    
    # 清理旧文件
    print_info "清理缓存..."
    npx hexo clean > /dev/null 2>&1
    
    # 生成静态文件
    print_info "生成静态文件..."
    if npx hexo generate; then
        print_success "构建完成"
        
        # 统计生成的文件
        local file_count=$(find public -type f | wc -l)
        local total_size=$(du -sh public | cut -f1)
        print_info "生成了 $file_count 个文件,总大小: $total_size"
    else
        print_error "构建失败"
        exit 1
    fi
    
    echo ""
}

# 步骤5: 部署到GitHub Pages
deploy_site() {
    print_step 5 5 "部署到 GitHub Pages"
    echo ""
    
    print_info "部署到 $GIT_BRANCH_DEPLOY 分支..."
    
    if npx hexo deploy; then
        print_success "部署成功"
    else
        print_error "部署失败"
        exit 1
    fi
    
    echo ""
}

# 完成总结
show_summary() {
    print_header "🎉 部署完成"
    echo ""
    
    echo -e "${GREEN}${BOLD}操作摘要:${NC}"
    echo -e "  ${CYAN}源码分支:${NC}   $GIT_BRANCH_SOURCE (已推送)"
    echo -e "  ${CYAN}部署分支:${NC}   $GIT_BRANCH_DEPLOY (已部署)"
    echo -e "  ${CYAN}最后提交:${NC}   $(git log -1 --oneline)"
    echo -e "  ${CYAN}提交时间:${NC}   $(git log -1 --format=%cd --date=format:'%Y-%m-%d %H:%M:%S')"
    echo ""
    
    echo -e "${YELLOW}${BOLD}访问链接:${NC}"
    echo -e "  ${BLUE}https://smlyfm.github.io${NC}"
    echo ""
    
    echo -e "${DIM}注意: GitHub Pages 可能需要 1-3 分钟来更新网站${NC}"
    echo ""
    
    print_header ""
}

# ============================================
# 错误处理
# ============================================

# 捕获错误
trap 'handle_error $? $LINENO' ERR

handle_error() {
    local exit_code=$1
    local line_num=$2
    
    echo ""
    print_error "部署失败 (退出码: $exit_code, 行号: $line_num)"
    echo ""
    
    echo -e "${YELLOW}可能的解决方案:${NC}"
    echo "  1. 检查网络连接"
    echo "  2. 验证 SSH 密钥配置: ssh -T github_yytcjx"
    echo "  3. 检查 _config.yml 中的部署配置"
    echo "  4. 查看详细日志: npx hexo deploy --debug"
    echo ""
    
    exit $exit_code
}

# ============================================
# 主流程
# ============================================

main() {
    # 打印标题
    print_header "Hexo 博客全功能部署"
    echo ""
    
    # 显示模式
    if [ "$MODE" = "auto" ]; then
        print_info "运行模式: 交互式"
    else
        print_info "运行模式: 自动化"
    fi
    echo ""
    
    # 执行步骤
    check_environment
    check_git_status
    commit_source
    build_site
    deploy_site
    
    # 显示总结
    show_summary
}

# 运行主函数
main
