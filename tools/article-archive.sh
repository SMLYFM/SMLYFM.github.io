#!/usr/bin/env bash
# ============================================
# 文章归档工具
# 💡 归档文章（移动到归档目录，不参与构建）
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
ARCHIVE_DIR="${ARCHIVE_DIR:-source/_archived}"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 日志函数
log_info()    { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warn()    { echo -e "${YELLOW}⚠️${NC} $1"; }
log_error()   { echo -e "${RED}❌${NC} $1"; }

# ============================================
# 核心函数
# ============================================

# 💡 确保归档目录存在
ensure_archive_dir() {
    if [[ ! -d "$ARCHIVE_DIR" ]]; then
        mkdir -p "$ARCHIVE_DIR"
        log_info "创建归档目录: $ARCHIVE_DIR"
    fi
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

# 💡 获取文章分类
get_category() {
    local file="$1"
    grep -A1 "^categories:" "$file" | tail -1 | sed 's/.*- //' | xargs
}

# ============================================
# 归档操作
# ============================================

cmd_move() {
    local file="${1:-}"
    
    if [[ -z "$file" ]]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "    📁 归档文章"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "选择要归档的文章:"
        echo ""
        
        local num=1
        local files_arr=()
        
        for f in "${POST_DIR}"/*.md; do
            if [[ -f "$f" ]]; then
                files_arr+=("$f")
                local title
                title=$(get_title "$f")
                printf "[%2d] %s\n" "$num" "$title"
                ((num++))
            fi
        done
        
        echo ""
        read -p "输入序号 (0 取消): " selection
        
        if [[ "$selection" == "0" || -z "$selection" ]]; then
            log_info "已取消"
            return 0
        fi
        
        file="${files_arr[$((selection-1))]:-}"
        
        if [[ -z "$file" || ! -f "$file" ]]; then
            log_error "无效选择"
            return 1
        fi
    else
        # 💡 处理相对路径
        if [[ ! -f "$file" ]]; then
            file="${POST_DIR}/${file}"
        fi
        
        if [[ ! -f "$file" ]]; then
            log_error "文件不存在: $file"
            return 1
        fi
    fi
    
    local basename title
    basename=$(basename "$file")
    title=$(get_title "$file")
    
    ensure_archive_dir
    
    echo ""
    echo "📝 文章: $title"
    echo "📁 文件: $basename"
    echo ""
    read -p "确认归档此文章? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 💡 在文件中添加归档标记
        if ! grep -q "^archived:" "$file"; then
            sed -i "/^---$/a\\archived: true\\narchived_date: ${TIMESTAMP}" "$file"
        fi
        
        mv "$file" "${ARCHIVE_DIR}/${basename}"
        log_success "已归档: $title"
        log_info "位置: ${ARCHIVE_DIR}/${basename}"
    else
        log_info "已取消"
    fi
}

cmd_restore() {
    local file="${1:-}"
    
    ensure_archive_dir
    
    # 💡 检查归档目录是否有文件
    local archived_count
    archived_count=$(find "$ARCHIVE_DIR" -name "*.md" 2>/dev/null | wc -l)
    
    if [[ "$archived_count" -eq 0 ]]; then
        log_warn "归档目录为空"
        return 0
    fi
    
    if [[ -z "$file" ]]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "    📂 恢复归档文章"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "选择要恢复的文章:"
        echo ""
        
        local num=1
        local files_arr=()
        
        for f in "${ARCHIVE_DIR}"/*.md; do
            if [[ -f "$f" ]]; then
                files_arr+=("$f")
                local title archived_date
                title=$(get_title "$f")
                archived_date=$(grep "^archived_date:" "$f" | cut -d':' -f2- | xargs)
                printf "[%2d] %s (归档于: %s)\n" "$num" "$title" "${archived_date:-未知}"
                ((num++))
            fi
        done
        
        echo ""
        read -p "输入序号 (0 取消): " selection
        
        if [[ "$selection" == "0" || -z "$selection" ]]; then
            log_info "已取消"
            return 0
        fi
        
        file="${files_arr[$((selection-1))]:-}"
        
        if [[ -z "$file" || ! -f "$file" ]]; then
            log_error "无效选择"
            return 1
        fi
    else
        if [[ ! -f "$file" ]]; then
            file="${ARCHIVE_DIR}/${file}"
        fi
        
        if [[ ! -f "$file" ]]; then
            log_error "文件不存在: $file"
            return 1
        fi
    fi
    
    local basename title
    basename=$(basename "$file")
    title=$(get_title "$file")
    
    echo ""
    echo "📝 文章: $title"
    echo "📁 文件: $basename"
    echo ""
    read -p "确认恢复此文章? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 💡 移除归档标记
        sed -i '/^archived:/d' "$file"
        sed -i '/^archived_date:/d' "$file"
        
        # 💡 更新时间戳
        sed -i "s/^updated:.*/updated: ${TIMESTAMP}/" "$file"
        
        mv "$file" "${POST_DIR}/${basename}"
        log_success "已恢复: $title"
        log_info "位置: ${POST_DIR}/${basename}"
    else
        log_info "已取消"
    fi
}

cmd_list() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📁 归档文章列表"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    ensure_archive_dir
    
    local count=0
    
    echo "序号  归档日期    分类        标题"
    echo "────  ──────────  ──────────  ────────────────────────────────"
    
    for file in "${ARCHIVE_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            ((count++))
            local title category archived_date
            title=$(get_title "$file")
            category=$(get_category "$file")
            archived_date=$(grep "^archived_date:" "$file" | cut -d' ' -f2 || echo "未知")
            
            printf "[%2d]  %s  %-10s  %s\n" "$count" "${archived_date:0:10}" "$category" "$title"
        fi
    done
    
    if [[ $count -eq 0 ]]; then
        echo "  (无归档文章)"
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "总计: $count 篇归档文章"
    echo ""
    echo "💡 使用 'restore' 命令恢复归档文章"
}

cmd_clean() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🗑️  清理归档目录"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ ! -d "$ARCHIVE_DIR" ]]; then
        log_info "归档目录不存在"
        return 0
    fi
    
    local count
    count=$(find "$ARCHIVE_DIR" -name "*.md" | wc -l)
    
    if [[ $count -eq 0 ]]; then
        log_info "归档目录为空"
        return 0
    fi
    
    echo "⚠️  将永久删除 $count 篇归档文章:"
    echo ""
    
    for file in "${ARCHIVE_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            local title
            title=$(get_title "$file")
            echo "  - $title"
        fi
    done
    
    echo ""
    read -p "确认永久删除? 此操作不可恢复! [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "${ARCHIVE_DIR}"/*.md
        log_success "已删除 $count 篇归档文章"
    else
        log_info "已取消"
    fi
}

cmd_batch_archive() {
    local filter_type=""
    local filter_value=""
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --category|-c)
                filter_type="category"
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
        log_error "用法: $0 batch --category <分类> | --before <日期>"
        return 1
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📁 批量归档文章"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "过滤条件: $filter_type = $filter_value"
    echo ""
    
    ensure_archive_dir
    
    local files=()
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            case "$filter_type" in
                category)
                    local cat
                    cat=$(get_category "$file")
                    [[ "$cat" == "$filter_value" ]] && files+=("$file")
                    ;;
                before)
                    local file_date target_ts file_ts
                    file_date=$(get_date "$file")
                    target_ts=$(date -d "$filter_value" +%s 2>/dev/null || echo "0")
                    file_ts=$(date -d "$file_date" +%s 2>/dev/null || echo "0")
                    [[ "$file_ts" -lt "$target_ts" && "$file_ts" != "0" ]] && files+=("$file")
                    ;;
            esac
        fi
    done
    
    if [[ ${#files[@]} -eq 0 ]]; then
        log_warn "未找到匹配的文章"
        return 0
    fi
    
    echo "将归档以下 ${#files[@]} 篇文章:"
    echo ""
    
    for file in "${files[@]}"; do
        local title
        title=$(get_title "$file")
        echo "  - $title"
    done
    
    echo ""
    read -p "确认归档? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        local count=0
        for file in "${files[@]}"; do
            local basename
            basename=$(basename "$file")
            
            if ! grep -q "^archived:" "$file"; then
                sed -i "/^---$/a\\archived: true\\narchived_date: ${TIMESTAMP}" "$file"
            fi
            
            mv "$file" "${ARCHIVE_DIR}/${basename}"
            ((count++))
        done
        log_success "已归档 $count 篇文章"
    else
        log_info "已取消"
    fi
}

cmd_help() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📁 文章归档工具"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "用法: $0 <命令> [参数]"
    echo ""
    echo "单篇操作:"
    echo "  move [文件]            归档文章（交互式选择或指定文件）"
    echo "  restore [文件]         恢复归档文章"
    echo ""
    echo "批量操作:"
    echo "  batch --category <分类>  批量归档指定分类的文章"
    echo "  batch --before <日期>    批量归档指定日期前的文章"
    echo ""
    echo "管理:"
    echo "  list                   列出所有归档文章"
    echo "  clean                  永久删除所有归档文章"
    echo "  help                   显示帮助"
    echo ""
    echo "示例:"
    echo "  $0 move                        # 交互式选择"
    echo "  $0 move zfc-set-theory.md      # 归档指定文章"
    echo "  $0 restore                     # 交互式恢复"
    echo "  $0 batch --category 测试"
    echo "  $0 list"
    echo ""
    echo "配置:"
    echo "  POST_DIR=$POST_DIR"
    echo "  ARCHIVE_DIR=$ARCHIVE_DIR"
    echo ""
}

# ============================================
# 主入口
# ============================================

case "${1:-help}" in
    move)     cmd_move "${2:-}" ;;
    restore)  cmd_restore "${2:-}" ;;
    batch)    shift; cmd_batch_archive "$@" ;;
    list)     cmd_list ;;
    clean)    cmd_clean ;;
    help|--help|-h) cmd_help ;;
    *)
        log_error "未知命令: $1"
        cmd_help
        exit 1
        ;;
esac
