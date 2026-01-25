#!/usr/bin/env bash
# ============================================
# 文章 Hash 追踪工具
# 💡 检测文章内容变化，自动更新时间戳
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
NC='\033[0m'

# 配置
POST_DIR="${POST_DIR:-source/_posts}"
HASH_FILE="${HASH_FILE:-.article-hashes}"

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# 💡 计算文章内容的 hash（排除 Front Matter 中的 updated 字段）
calculate_hash() {
    local file="$1"
    # 使用 sed 移除 updated 行后再计算 hash，这样只检测实际内容变化
    sed '/^updated:/d' "$file" | md5sum | cut -d' ' -f1
}

# 💡 获取文章标题（从文件名或 Front Matter）
get_title() {
    local file="$1"
    local title
    title=$(grep -m1 '^title:' "$file" 2>/dev/null | sed 's/title:[[:space:]]*//' | tr -d '"'"'" || basename "$file" .md)
    echo "$title"
}

# 💡 更新文章的 updated 时间戳
update_timestamp() {
    local file="$1"
    local new_time
    new_time=$(date '+%Y-%m-%d %H:%M:%S')
    
    if grep -q '^updated:' "$file"; then
        # 更新已有的 updated 字段
        sed -i "s/^updated:.*/updated: $new_time/" "$file"
    else
        # 在 date 行后插入 updated 字段
        sed -i "/^date:/a updated: $new_time" "$file"
    fi
    echo "$new_time"
}

# ============================================
# 命令实现
# ============================================

cmd_init() {
    log_info "初始化文章 hash 记录..."
    : > "$HASH_FILE"
    
    local count=0
    for file in "$POST_DIR"/*.md; do
        [ -f "$file" ] || continue
        local hash
        hash=$(calculate_hash "$file")
        echo "$(basename "$file"):$hash" >> "$HASH_FILE"
        count=$((count + 1))
    done
    
    log_success "已记录 $count 篇文章的 hash"
    echo "Hash 文件: $HASH_FILE"
}

cmd_check() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📋 检查文章修改状态"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ ! -f "$HASH_FILE" ]; then
        log_warn "Hash 文件不存在，正在初始化..."
        cmd_init
        return
    fi
    
    local modified=0
    local new=0
    local unchanged=0
    
    for file in "$POST_DIR"/*.md; do
        [ -f "$file" ] || continue
        local basename
        basename=$(basename "$file")
        local current_hash
        current_hash=$(calculate_hash "$file")
        local stored_hash
        stored_hash=$(grep "^$basename:" "$HASH_FILE" 2>/dev/null | cut -d: -f2 || echo "")
        
        if [ -z "$stored_hash" ]; then
            echo -e "  ${CYAN}[NEW]${NC}      $basename"
            new=$((new + 1))
        elif [ "$current_hash" != "$stored_hash" ]; then
            echo -e "  ${YELLOW}[MODIFIED]${NC} $basename"
            modified=$((modified + 1))
        else
            unchanged=$((unchanged + 1))
        fi
    done
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "  新文章: %d  |  已修改: %d  |  未变化: %d\n" "$new" "$modified" "$unchanged"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ $((modified + new)) -gt 0 ]; then
        echo "💡 运行 'make article-update' 更新时间戳和 hash"
    fi
}

cmd_update() {
    log_info "检查并更新已修改的文章..."
    
    if [ ! -f "$HASH_FILE" ]; then
        log_warn "Hash 文件不存在，正在初始化..."
        cmd_init
        return
    fi
    
    local updated_count=0
    
    for file in "$POST_DIR"/*.md; do
        [ -f "$file" ] || continue
        local basename
        basename=$(basename "$file")
        local current_hash
        current_hash=$(calculate_hash "$file")
        local stored_hash
        stored_hash=$(grep "^$basename:" "$HASH_FILE" 2>/dev/null | cut -d: -f2 || echo "")
        
        if [ -z "$stored_hash" ] || [ "$current_hash" != "$stored_hash" ]; then
            local title
            title=$(get_title "$file")
            local new_time
            new_time=$(update_timestamp "$file")
            
            # 更新 hash 文件
            if grep -q "^$basename:" "$HASH_FILE"; then
                sed -i "s/^$basename:.*/$basename:$current_hash/" "$HASH_FILE"
            else
                echo "$basename:$current_hash" >> "$HASH_FILE"
            fi
            
            echo -e "  ${GREEN}✓${NC} $title → updated: $new_time"
            updated_count=$((updated_count + 1))
        fi
    done
    
    if [ $updated_count -eq 0 ]; then
        log_success "没有需要更新的文章"
    else
        log_success "已更新 $updated_count 篇文章"
    fi
}

cmd_update_file() {
    local target="$1"
    
    if [ -z "$target" ]; then
        log_error "请指定文件名"
        echo "用法: $0 update-file <文件名.md>"
        exit 1
    fi
    
    local file="$POST_DIR/$target"
    if [ ! -f "$file" ]; then
        log_error "文件不存在: $file"
        exit 1
    fi
    
    local title
    title=$(get_title "$file")
    local new_time
    new_time=$(update_timestamp "$file")
    
    # 更新 hash
    local current_hash
    current_hash=$(calculate_hash "$file")
    local basename
    basename=$(basename "$file")
    
    if [ -f "$HASH_FILE" ]; then
        if grep -q "^$basename:" "$HASH_FILE"; then
            sed -i "s/^$basename:.*/$basename:$current_hash/" "$HASH_FILE"
        else
            echo "$basename:$current_hash" >> "$HASH_FILE"
        fi
    fi
    
    log_success "$title"
    echo "  updated: $new_time"
    echo "  hash: ${current_hash:0:8}..."
}

cmd_show() {
    local target="$1"
    
    if [ -z "$target" ]; then
        log_error "请指定文件名"
        echo "用法: $0 show <文件名.md>"
        exit 1
    fi
    
    local file="$POST_DIR/$target"
    if [ ! -f "$file" ]; then
        log_error "文件不存在: $file"
        exit 1
    fi
    
    local title
    title=$(get_title "$file")
    local current_hash
    current_hash=$(calculate_hash "$file")
    local stored_hash
    stored_hash=$(grep "^$target:" "$HASH_FILE" 2>/dev/null | cut -d: -f2 || echo "无记录")
    
    echo ""
    echo "📄 $title"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "文件:      $target"
    echo "当前 hash: $current_hash"
    echo "存储 hash: $stored_hash"
    if [ "$current_hash" = "$stored_hash" ]; then
        echo -e "状态:      ${GREEN}未修改${NC}"
    else
        echo -e "状态:      ${YELLOW}已修改${NC}"
    fi
    echo ""
}

cmd_clean() {
    if [ -f "$HASH_FILE" ]; then
        rm "$HASH_FILE"
        log_success "已删除 hash 文件"
    else
        log_warn "Hash 文件不存在"
    fi
}

cmd_help() {
    cat << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📋 文章 Hash 追踪工具
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

用法: $0 <命令> [参数]

命令:
  init                初始化 hash 记录
  check               检查哪些文章被修改
  update              更新所有已修改文章的时间戳
  update-file <文件>  更新指定文章的时间戳
  show <文件>         显示指定文章的 hash 信息
  clean               删除 hash 记录文件

示例:
  $0 check                           # 检查修改状态
  $0 update                          # 更新所有修改的文章
  $0 update-file zfc-set-theory.md   # 更新指定文章

EOF
}

# ============================================
# 主入口
# ============================================

case "${1:-help}" in
    init)        cmd_init ;;
    check)       cmd_check ;;
    update)      cmd_update ;;
    update-file) cmd_update_file "${2:-}" ;;
    show)        cmd_show "${2:-}" ;;
    clean)       cmd_clean ;;
    help|--help|-h) cmd_help ;;
    *)
        log_error "未知命令: $1"
        cmd_help
        exit 1
        ;;
esac
