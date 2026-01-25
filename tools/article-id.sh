#!/usr/bin/env bash
# ============================================
# 文章 ID 管理系统
# 💡 为每篇文章分配唯一 ID，支持查看详细信息
# 规则：
# - 文章内容修改时 ID 保持不变
# - 删除文章或重命名时，ID 可被新文章复用
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
ID_FILE="${ID_FILE:-.article-ids}"
HASH_FILE="${HASH_FILE:-.article-hashes}"
MAX_ID=9999

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

# ============================================
# ID 管理核心函数
# ============================================

# 💡 获取下一个可用 ID（优先使用回收的 ID）
get_next_id() {
    if [ ! -f "$ID_FILE" ]; then
        echo "1"
        return
    fi
    
    # 获取所有已使用的 ID
    local used_ids
    used_ids=$(cut -d: -f1 "$ID_FILE" | sort -n)
    
    # 从 1 开始找第一个未使用的 ID
    local next_id=1
    for id in $used_ids; do
        if [ "$id" -eq "$next_id" ]; then
            next_id=$((next_id + 1))
        else
            break
        fi
    done
    
    echo "$next_id"
}

# 💡 根据文件名获取 ID
get_id_by_file() {
    local filename="$1"
    if [ -f "$ID_FILE" ]; then
        grep ":$filename$" "$ID_FILE" 2>/dev/null | cut -d: -f1 || echo ""
    else
        echo ""
    fi
}

# 💡 根据 ID 获取文件名
get_file_by_id() {
    local id="$1"
    if [ -f "$ID_FILE" ]; then
        grep "^$id:" "$ID_FILE" 2>/dev/null | cut -d: -f2 || echo ""
    else
        echo ""
    fi
}

# 💡 分配 ID 给文章
assign_id() {
    local filename="$1"
    local existing_id
    existing_id=$(get_id_by_file "$filename")
    
    if [ -n "$existing_id" ]; then
        echo "$existing_id"
        return
    fi
    
    local new_id
    new_id=$(get_next_id)
    echo "$new_id:$filename" >> "$ID_FILE"
    
    # 排序 ID 文件
    sort -t: -k1 -n "$ID_FILE" -o "$ID_FILE"
    
    echo "$new_id"
}

# 💡 释放 ID（删除文章时调用）
release_id() {
    local filename="$1"
    if [ -f "$ID_FILE" ]; then
        sed -i "/:$filename$/d" "$ID_FILE"
    fi
}

# 💡 更新 ID 映射（重命名文章时调用）
update_id_mapping() {
    local old_filename="$1"
    local new_filename="$2"
    
    if [ -f "$ID_FILE" ]; then
        sed -i "s/:$old_filename$/:$new_filename/" "$ID_FILE"
    fi
}

# ============================================
# 命令实现
# ============================================

cmd_init() {
    log_info "初始化文章 ID 系统..."
    : > "$ID_FILE"
    
    local count=0
    for file in "$POST_DIR"/*.md; do
        [ -f "$file" ] || continue
        local basename
        basename=$(basename "$file")
        local id
        id=$(assign_id "$basename")
        count=$((count + 1))
    done
    
    log_success "已为 $count 篇文章分配 ID"
    echo "ID 文件: $ID_FILE"
}

cmd_list() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📋 文章 ID 列表"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [ ! -f "$ID_FILE" ]; then
        log_warn "ID 文件不存在，请运行 'make article-id-init'"
        return
    fi
    
    printf "  ${BOLD}%-6s %-40s %s${NC}\n" "ID" "标题" "文件"
    echo "  ────── ──────────────────────────────────────── ────────────────────────"
    
    while IFS=: read -r id filename; do
        local file="$POST_DIR/$filename"
        if [ -f "$file" ]; then
            local title
            title=$(grep "^title:" "$file" | head -1 | cut -d':' -f2- | xargs)
            title="${title:0:38}"
            printf "  ${CYAN}#%-5s${NC} %-40s %s\n" "$id" "$title" "$filename"
        else
            printf "  ${RED}#%-5s${NC} ${RED}[已删除]${NC}%-32s %s\n" "$id" "" "$filename"
        fi
    done < "$ID_FILE"
    
    echo ""
}

cmd_info() {
    local target="$1"
    
    if [ -z "$target" ]; then
        log_error "请指定文章 ID 或文件名"
        echo "用法: $0 info <ID 或 文件名.md>"
        exit 1
    fi
    
    local filename=""
    local id=""
    
    # 判断输入是 ID 还是文件名
    if [[ "$target" =~ ^[0-9]+$ ]]; then
        id="$target"
        filename=$(get_file_by_id "$id")
        if [ -z "$filename" ]; then
            log_error "未找到 ID #$id 对应的文章"
            exit 1
        fi
    else
        filename="$target"
        id=$(get_id_by_file "$filename")
    fi
    
    local file="$POST_DIR/$filename"
    if [ ! -f "$file" ]; then
        log_error "文件不存在: $file"
        exit 1
    fi
    
    # 提取文章信息
    local title date updated categories tags description cover mathjax
    title=$(grep "^title:" "$file" | head -1 | sed 's/title:[[:space:]]*//')
    date=$(grep "^date:" "$file" | head -1 | sed 's/date:[[:space:]]*//')
    updated=$(grep "^updated:" "$file" | head -1 | sed 's/updated:[[:space:]]*//' || echo "未设置")
    categories=$(awk '/^categories:/,/^[a-z]/' "$file" | grep "  - " | sed 's/  - //' | tr '\n' ' ' || true)
    tags=$(awk '/^tags:/,/^[a-z]/' "$file" | grep "  - " | sed 's/  - //' | tr '\n' ' ' || true)
    description=$(grep "^description:" "$file" 2>/dev/null | head -1 | sed 's/description:[[:space:]]*//' || true)
    cover=$(grep "^cover:" "$file" 2>/dev/null | head -1 | sed 's/cover:[[:space:]]*//' || true)
    mathjax=$(grep "^mathjax:" "$file" 2>/dev/null | head -1 | sed 's/mathjax:[[:space:]]*//' || true)
    
    # Hash 信息
    local current_hash stored_hash hash_status
    current_hash=$(sed '/^updated:/d' "$file" | md5sum | cut -d' ' -f1)
    if [ -f "$HASH_FILE" ]; then
        stored_hash=$(grep "^$filename:" "$HASH_FILE" 2>/dev/null | cut -d: -f2 || echo "无记录")
        if [ "$current_hash" = "$stored_hash" ]; then
            hash_status="未修改"
        elif [ "$stored_hash" = "无记录" ]; then
            hash_status="新文章"
        else
            hash_status="已修改"
        fi
    else
        stored_hash="未初始化"
        hash_status="未初始化"
    fi
    
    # 文件信息
    local file_size word_count line_count
    file_size=$(du -h "$file" | cut -f1)
    word_count=$(wc -m < "$file")
    line_count=$(wc -l < "$file")
    
    # Git 提交记录
    local git_commits
    git_commits=$(git log --oneline -5 -- "$file" 2>/dev/null || echo "无提交记录")
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "    📄 文章详情: ${BOLD}${CYAN}#${id:-?}${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo -e "  ${BOLD}📝 基本信息${NC}"
    echo "  ─────────────────────────────────────────────────────────────────────"
    printf "  %-12s %s\n" "标题:" "$title"
    printf "  %-12s %s\n" "文件:" "$filename"
    printf "  %-12s %s\n" "ID:" "#${id:-未分配}"
    echo ""
    echo -e "  ${BOLD}📅 时间信息${NC}"
    echo "  ─────────────────────────────────────────────────────────────────────"
    printf "  %-12s %s\n" "创建时间:" "$date"
    printf "  %-12s %s\n" "更新时间:" "$updated"
    echo ""
    echo -e "  ${BOLD}📂 分类与标签${NC}"
    echo "  ─────────────────────────────────────────────────────────────────────"
    printf "  %-12s %s\n" "分类:" "${categories:-无}"
    printf "  %-12s %s\n" "标签:" "${tags:-无}"
    echo ""
    echo -e "  ${BOLD}📊 统计信息${NC}"
    echo "  ─────────────────────────────────────────────────────────────────────"
    printf "  %-12s %s\n" "文件大小:" "$file_size"
    printf "  %-12s %s 字符\n" "字符数:" "$word_count"
    printf "  %-12s %s 行\n" "行数:" "$line_count"
    printf "  %-12s %s\n" "数学公式:" "${mathjax:-false}"
    echo ""
    echo -e "  ${BOLD}🔐 Hash 信息${NC}"
    echo "  ─────────────────────────────────────────────────────────────────────"
    printf "  %-12s %s\n" "当前 Hash:" "${current_hash:0:16}..."
    printf "  %-12s %s\n" "存储 Hash:" "${stored_hash:0:16}..."
    printf "  %-12s %s\n" "状态:" "$hash_status"
    echo ""
    echo -e "  ${BOLD}📜 Git 提交记录（最近 5 条）${NC}"
    echo "  ─────────────────────────────────────────────────────────────────────"
    echo "$git_commits" | while read -r line; do
        echo "  $line"
    done
    echo ""
    
    if [ -n "$description" ]; then
        echo -e "  ${BOLD}📋 描述${NC}"
        echo "  ─────────────────────────────────────────────────────────────────────"
        echo "  $description"
        echo ""
    fi
    
    if [ -n "$cover" ]; then
        echo -e "  ${BOLD}🖼️  封面${NC}"
        echo "  ─────────────────────────────────────────────────────────────────────"
        echo "  $cover"
        echo ""
    fi
}

cmd_sync() {
    log_info "同步文章 ID..."
    
    if [ ! -f "$ID_FILE" ]; then
        log_warn "ID 文件不存在，正在初始化..."
        cmd_init
        return
    fi
    
    local added=0
    local removed=0
    
    # 检查新文章，分配 ID
    for file in "$POST_DIR"/*.md; do
        [ -f "$file" ] || continue
        local basename
        basename=$(basename "$file")
        local existing_id
        existing_id=$(get_id_by_file "$basename")
        
        if [ -z "$existing_id" ]; then
            local new_id
            new_id=$(assign_id "$basename")
            echo -e "  ${GREEN}+${NC} 分配 ID #$new_id → $basename"
            added=$((added + 1))
        fi
    done
    
    # 检查已删除的文章，释放 ID
    while IFS=: read -r id filename; do
        if [ ! -f "$POST_DIR/$filename" ]; then
            release_id "$filename"
            echo -e "  ${RED}-${NC} 释放 ID #$id ← $filename (已删除)"
            removed=$((removed + 1))
        fi
    done < "$ID_FILE"
    
    if [ $added -eq 0 ] && [ $removed -eq 0 ]; then
        log_success "ID 已是最新状态"
    else
        log_success "同步完成: 新增 $added, 释放 $removed"
    fi
}

cmd_clean() {
    log_info "清理无效的 ID 记录..."
    
    if [ ! -f "$ID_FILE" ]; then
        log_warn "ID 文件不存在"
        return
    fi
    
    local cleaned=0
    local temp_file
    temp_file=$(mktemp)
    
    while IFS=: read -r id filename; do
        if [ -f "$POST_DIR/$filename" ]; then
            echo "$id:$filename" >> "$temp_file"
        else
            echo -e "  ${RED}删除${NC} ID #$id ($filename 不存在)"
            cleaned=$((cleaned + 1))
        fi
    done < "$ID_FILE"
    
    mv "$temp_file" "$ID_FILE"
    
    if [ $cleaned -eq 0 ]; then
        log_success "没有需要清理的记录"
    else
        log_success "已清理 $cleaned 条无效记录"
    fi
}

cmd_help() {
    cat << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📋 文章 ID 管理系统
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

用法: $0 <命令> [参数]

命令:
  init              初始化 ID 系统，为所有文章分配 ID
  list              列出所有文章 ID
  info <ID或文件名> 显示文章详细信息
  sync              同步 ID（分配新文章，释放已删除）
  clean             清理无效的 ID 记录

示例:
  $0 init                           # 初始化
  $0 list                           # 列出所有 ID
  $0 info 1                         # 按 ID 查看文章详情
  $0 info zfc-set-theory.md         # 按文件名查看
  $0 sync                           # 同步 ID

ID 规则:
  - 文章内容修改时，ID 保持不变
  - 删除文章时，ID 被释放可供新文章使用
  - 重命名文章时，ID 保持不变（需手动运行 sync）

EOF
}

# ============================================
# 主入口
# ============================================

case "${1:-help}" in
    init)   cmd_init ;;
    list)   cmd_list ;;
    info)   cmd_info "${2:-}" ;;
    sync)   cmd_sync ;;
    clean)  cmd_clean ;;
    help|--help|-h) cmd_help ;;
    *)
        log_error "未知命令: $1"
        cmd_help
        exit 1
        ;;
esac
