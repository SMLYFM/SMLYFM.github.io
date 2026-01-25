#!/usr/bin/env bash
# ============================================
# 文章批量操作工具
# 💡 支持批量删除、修改分类、标签等操作
# 作者: CJX
# 项目: SMLYFM.github.io
# ============================================

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
BOLD='\033[1m'

# 配置
POST_DIR="${POST_DIR:-source/_posts}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 日志函数
log_info()    { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warn()    { echo -e "${YELLOW}⚠️${NC} $1"; }
log_error()   { echo -e "${RED}❌${NC} $1"; }

# ============================================
# 核心函数
# ============================================

# 💡 获取文章的分类
get_category() {
    local file="$1"
    grep -A1 "^categories:" "$file" | tail -1 | sed 's/.*- //' | xargs
}

# 💡 获取文章的标签列表
get_tags() {
    local file="$1"
    awk '/^tags:/,/^[a-z]/' "$file" | grep "  - " | sed 's/  - //' | tr '\n' ' '
}

# 💡 获取文章标题
get_title() {
    local file="$1"
    grep "^title:" "$file" | head -1 | cut -d':' -f2- | xargs
}

# 💡 获取文章日期
get_date() {
    local file="$1"
    grep "^date:" "$file" | head -1 | cut -d' ' -f2
}

# 💡 检查文章是否包含指定标签
has_tag() {
    local file="$1"
    local tag="$2"
    grep -qE "^  - ${tag}$" "$file"
}

# 💡 更新文章时间戳
update_timestamp() {
    local file="$1"
    sed -i "s/^updated:.*/updated: ${TIMESTAMP}/" "$file"
}

# 💡 按分类过滤文章
filter_by_category() {
    local category="$1"
    local files=()
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            local cat
            cat=$(get_category "$file")
            if [[ "$cat" == "$category" ]]; then
                files+=("$file")
            fi
        fi
    done
    
    printf '%s\n' "${files[@]}"
}

# 💡 按标签过滤文章
filter_by_tag() {
    local tag="$1"
    local files=()
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            if has_tag "$file" "$tag"; then
                files+=("$file")
            fi
        fi
    done
    
    printf '%s\n' "${files[@]}"
}

# 💡 按日期过滤文章（早于指定日期）
filter_by_date_before() {
    local target_date="$1"
    local target_ts
    target_ts=$(date -d "$target_date" +%s 2>/dev/null || echo "0")
    
    if [[ "$target_ts" == "0" ]]; then
        log_error "无效日期格式: $target_date"
        return 1
    fi
    
    local files=()
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            local file_date file_ts
            file_date=$(get_date "$file")
            file_ts=$(date -d "$file_date" +%s 2>/dev/null || echo "0")
            
            if [[ "$file_ts" -lt "$target_ts" && "$file_ts" != "0" ]]; then
                files+=("$file")
            fi
        fi
    done
    
    printf '%s\n' "${files[@]}"
}

# ============================================
# 批量删除
# ============================================

cmd_delete() {
    local filter_type=""
    local filter_value=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --category|-c)
                filter_type="category"
                filter_value="$2"
                shift 2
                ;;
            --tag|-t)
                filter_type="tag"
                filter_value="$2"
                shift 2
                ;;
            --before|-b)
                filter_type="before"
                filter_value="$2"
                shift 2
                ;;
            *)
                log_error "未知参数: $1"
                return 1
                ;;
        esac
    done
    
    if [[ -z "$filter_type" ]]; then
        log_error "用法: $0 delete --category <分类> | --tag <标签> | --before <日期>"
        echo ""
        echo "示例:"
        echo "  $0 delete --category blog"
        echo "  $0 delete --tag 测试"
        echo "  $0 delete --before 2025-01-01"
        return 1
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🗑️  批量删除文章"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "过滤条件: $filter_type = $filter_value"
    echo ""
    
    local files=()
    
    case "$filter_type" in
        category) mapfile -t files < <(filter_by_category "$filter_value") ;;
        tag)      mapfile -t files < <(filter_by_tag "$filter_value") ;;
        before)   mapfile -t files < <(filter_by_date_before "$filter_value") ;;
    esac
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_warn "未找到匹配的文章"
        return 0
    fi
    
    echo "将删除以下 ${#files[@]} 篇文章:"
    echo ""
    
    for file in "${files[@]}"; do
        local title
        title=$(get_title "$file")
        echo "  - $title ($(basename "$file"))"
    done
    
    echo ""
    read -p "⚠️  确认删除这些文章? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local count=0
        for file in "${files[@]}"; do
            rm "$file"
            ((count++))
        done
        log_success "已删除 $count 篇文章"
    else
        log_info "已取消"
    fi
}

# ============================================
# 批量修改分类
# ============================================

cmd_modify_category() {
    local from_cat=""
    local to_cat=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --from|-f)
                from_cat="$2"
                shift 2
                ;;
            --to|-t)
                to_cat="$2"
                shift 2
                ;;
            *)
                log_error "未知参数: $1"
                return 1
                ;;
        esac
    done
    
    if [[ -z "$from_cat" || -z "$to_cat" ]]; then
        log_error "用法: $0 modify-category --from <原分类> --to <新分类>"
        return 1
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📂 批量修改分类"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "从: $from_cat  →  到: $to_cat"
    echo ""
    
    mapfile -t files < <(filter_by_category "$from_cat")
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_warn "未找到分类为 '$from_cat' 的文章"
        return 0
    fi
    
    echo "将修改以下 ${#files[@]} 篇文章的分类:"
    echo ""
    
    for file in "${files[@]}"; do
        local title
        title=$(get_title "$file")
        echo "  - $title"
    done
    
    echo ""
    read -p "确认修改? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local count=0
        for file in "${files[@]}"; do
            # 💡 使用 awk 替换分类
            awk -v from_cat="$from_cat" -v to_cat="$to_cat" '
                /^categories:/ { in_cat=1; print; next }
                in_cat && /^  - / {
                    gsub(from_cat, to_cat)
                    print
                    next
                }
                in_cat && /^[a-z]/ { in_cat=0 }
                { print }
            ' "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
            
            update_timestamp "$file"
            ((count++))
        done
        log_success "已修改 $count 篇文章的分类"
    else
        log_info "已取消"
    fi
}

# ============================================
# 批量添加标签
# ============================================

cmd_add_tag() {
    local tag=""
    local category=""
    local all=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --tag|-t)
                tag="$2"
                shift 2
                ;;
            --category|-c)
                category="$2"
                shift 2
                ;;
            --all|-a)
                all=true
                shift
                ;;
            *)
                log_error "未知参数: $1"
                return 1
                ;;
        esac
    done
    
    if [[ -z "$tag" ]]; then
        log_error "用法: $0 add-tag --tag <标签> [--category <分类>] [--all]"
        return 1
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🏷️  批量添加标签"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "标签: $tag"
    
    local files=()
    
    if [[ -n "$category" ]]; then
        echo "范围: 分类 '$category'"
        mapfile -t files < <(filter_by_category "$category")
    elif [[ "$all" == true ]]; then
        echo "范围: 所有文章"
        for file in "${POST_DIR}"/*.md; do
            [[ -f "$file" ]] && files+=("$file")
        done
    else
        log_error "请指定 --category 或 --all"
        return 1
    fi
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_warn "未找到匹配的文章"
        return 0
    fi
    
    # 💡 过滤掉已有该标签的文章
    local target_files=()
    for file in "${files[@]}"; do
        if ! has_tag "$file" "$tag"; then
            target_files+=("$file")
        fi
    done
    
    if [[ ${#target_files[@]} -eq 0 ]]; then
        log_info "所有文章都已有标签 '$tag'"
        return 0
    fi
    
    echo ""
    echo "将为以下 ${#target_files[@]} 篇文章添加标签:"
    echo ""
    
    for file in "${target_files[@]}"; do
        local title
        title=$(get_title "$file")
        echo "  - $title"
    done
    
    echo ""
    read -p "确认添加? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local count=0
        for file in "${target_files[@]}"; do
            sed -i "/^tags:/a\\  - ${tag}" "$file"
            update_timestamp "$file"
            ((count++))
        done
        log_success "已为 $count 篇文章添加标签 '$tag'"
    else
        log_info "已取消"
    fi
}

# ============================================
# 批量移除标签
# ============================================

cmd_remove_tag() {
    local tag=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --tag|-t)
                tag="$2"
                shift 2
                ;;
            *)
                log_error "未知参数: $1"
                return 1
                ;;
        esac
    done
    
    if [[ -z "$tag" ]]; then
        log_error "用法: $0 remove-tag --tag <标签>"
        return 1
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🏷️  批量移除标签"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "标签: $tag"
    echo ""
    
    mapfile -t files < <(filter_by_tag "$tag")
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_warn "未找到包含标签 '$tag' 的文章"
        return 0
    fi
    
    echo "将从以下 ${#files[@]} 篇文章中移除标签:"
    echo ""
    
    for file in "${files[@]}"; do
        local title
        title=$(get_title "$file")
        echo "  - $title"
    done
    
    echo ""
    read -p "确认移除? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local count=0
        for file in "${files[@]}"; do
            sed -i "/^  - ${tag}$/d" "$file"
            update_timestamp "$file"
            ((count++))
        done
        log_success "已从 $count 篇文章中移除标签 '$tag'"
    else
        log_info "已取消"
    fi
}

# ============================================
# 批量更新时间戳
# ============================================

cmd_update_time() {
    local category=""
    local all=false
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --category|-c)
                category="$2"
                shift 2
                ;;
            --all|-a)
                all=true
                shift
                ;;
            *)
                log_error "未知参数: $1"
                return 1
                ;;
        esac
    done
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    ⏰ 批量更新时间戳"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "新时间戳: $TIMESTAMP"
    
    local files=()
    
    if [[ -n "$category" ]]; then
        echo "范围: 分类 '$category'"
        mapfile -t files < <(filter_by_category "$category")
    elif [[ "$all" == true ]]; then
        echo "范围: 所有文章"
        for file in "${POST_DIR}"/*.md; do
            [[ -f "$file" ]] && files+=("$file")
        done
    else
        log_error "请指定 --category 或 --all"
        return 1
    fi
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_warn "未找到匹配的文章"
        return 0
    fi
    
    echo ""
    echo "将更新以下 ${#files[@]} 篇文章的时间戳:"
    echo ""
    
    for file in "${files[@]}"; do
        local title
        title=$(get_title "$file")
        echo "  - $title"
    done
    
    echo ""
    read -p "确认更新? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local count=0
        for file in "${files[@]}"; do
            update_timestamp "$file"
            ((count++))
        done
        log_success "已更新 $count 篇文章的时间戳"
    else
        log_info "已取消"
    fi
}

# ============================================
# 统计信息
# ============================================

cmd_stats() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📊 批量操作统计"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    local total=0
    declare -A categories
    declare -A tags
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            ((total++)) || true
            
            # 统计分类
            local cat
            cat=$(get_category "$file")
            if [[ -n "$cat" ]]; then
                categories["$cat"]=$((${categories["$cat"]:-0} + 1))
            fi
            
            # 统计标签
            while IFS= read -r tag; do
                tag=$(echo "$tag" | xargs)
                if [[ -n "$tag" ]]; then
                    tags["$tag"]=$((${tags["$tag"]:-0} + 1))
                fi
            done < <(awk '/^tags:/,/^[a-z]/' "$file" | grep "  - " | sed 's/  - //')
        fi
    done
    
    echo "📝 总文章数: $total"
    echo ""
    
    echo "📂 分类分布:"
    for cat in "${!categories[@]}"; do
        printf "  %-20s %d 篇\n" "$cat" "${categories[$cat]}"
    done | sort -t':' -k2 -rn
    
    echo ""
    echo "🏷️  标签分布 (前10):"
    for tag in "${!tags[@]}"; do
        printf "  %-20s %d 篇\n" "$tag" "${tags[$tag]}"
    done | sort -t':' -k2 -rn | head -10
    
    echo ""
}

cmd_help() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📦 文章批量操作工具"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "用法: $0 <命令> [参数]"
    echo ""
    echo "批量删除:"
    echo "  delete --category <分类>   删除指定分类的文章"
    echo "  delete --tag <标签>        删除含指定标签的文章"
    echo "  delete --before <日期>     删除指定日期前的文章"
    echo ""
    echo "批量修改分类:"
    echo "  modify-category --from <原> --to <新>"
    echo ""
    echo "批量标签操作:"
    echo "  add-tag --tag <标签> --category <分类>"
    echo "  add-tag --tag <标签> --all"
    echo "  remove-tag --tag <标签>"
    echo ""
    echo "批量更新时间:"
    echo "  update-time --category <分类>"
    echo "  update-time --all"
    echo ""
    echo "统计:"
    echo "  stats                      显示分类/标签统计"
    echo ""
    echo "示例:"
    echo "  $0 delete --category 测试"
    echo "  $0 modify-category --from blog --to 技术"
    echo "  $0 add-tag --tag \"学习笔记\" --category 数学"
    echo "  $0 stats"
    echo ""
}

# ============================================
# 主入口
# ============================================

case "${1:-help}" in
    delete)          shift; cmd_delete "$@" ;;
    modify-category) shift; cmd_modify_category "$@" ;;
    add-tag)         shift; cmd_add_tag "$@" ;;
    remove-tag)      shift; cmd_remove_tag "$@" ;;
    update-time)     shift; cmd_update_time "$@" ;;
    stats)           cmd_stats ;;
    help|--help|-h)  cmd_help ;;
    *)
        log_error "未知命令: $1"
        cmd_help
        exit 1
        ;;
esac
