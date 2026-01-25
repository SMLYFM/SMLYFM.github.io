#!/usr/bin/env bash
# ============================================
# 文章备份/恢复工具
# 💡 支持完整备份、增量备份、单篇备份和恢复
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
BACKUP_BASE="${BACKUP_BASE:-backups/articles}"
HASH_FILE="${HASH_FILE:-.article-hashes}"
DATE=$(date '+%Y-%m-%d')
TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')

# 日志函数
log_info()    { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warn()    { echo -e "${YELLOW}⚠️${NC} $1"; }
log_error()   { echo -e "${RED}❌${NC} $1"; }

# ============================================
# 核心函数
# ============================================

# 💡 确保备份目录存在
ensure_backup_dir() {
    local subdir="${1:-}"
    local target="${BACKUP_BASE}"
    
    if [[ -n "$subdir" ]]; then
        target="${BACKUP_BASE}/${subdir}"
    fi
    
    if [[ ! -d "$target" ]]; then
        mkdir -p "$target"
        log_info "创建备份目录: $target"
    fi
}

# 💡 获取文章标题
get_title() {
    local file="$1"
    grep "^title:" "$file" | head -1 | cut -d':' -f2- | xargs
}

# 💡 计算文件 hash
calculate_hash() {
    local file="$1"
    # 💡 排除 updated 字段计算 hash
    sed '/^updated:/d' "$file" | md5sum | cut -d' ' -f1
}

# 💡 获取备份信息
get_backup_info() {
    local backup_file="$1"
    local info_file="${backup_file%.tar.gz}.info"
    
    if [[ -f "$info_file" ]]; then
        cat "$info_file"
    fi
}

# 💡 创建备份信息文件
create_backup_info() {
    local backup_file="$1"
    local backup_type="$2"
    local count="$3"
    local info_file="${backup_file%.tar.gz}.info"
    
    {
        echo "type: $backup_type"
        echo "date: $TIMESTAMP"
        echo "count: $count"
        echo "size: $(du -h "$backup_file" | cut -f1)"
        echo "hash: $(md5sum "$backup_file" | cut -d' ' -f1)"
    } > "$info_file"
}

# ============================================
# 完整备份
# ============================================

cmd_full() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    💾 完整备份"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    ensure_backup_dir
    
    local count=0
    for f in "${POST_DIR}"/*.md; do
        [[ -f "$f" ]] && ((count++))
    done
    
    if [[ $count -eq 0 ]]; then
        log_warn "没有文章需要备份"
        return 0
    fi
    
    local backup_file="${BACKUP_BASE}/full_${TIMESTAMP}.tar.gz"
    
    log_info "正在备份 $count 篇文章..."
    
    # 💡 创建 tar.gz 备份
    tar -czf "$backup_file" -C "$(dirname "$POST_DIR")" "$(basename "$POST_DIR")"
    
    # 💡 创建元数据
    create_backup_info "$backup_file" "full" "$count"
    
    log_success "完整备份完成"
    echo ""
    echo "  📁 文件: $backup_file"
    echo "  📊 文章: $count 篇"
    echo "  💿 大小: $(du -h "$backup_file" | cut -f1)"
}

# ============================================
# 增量备份
# ============================================

cmd_incremental() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    💾 增量备份"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ ! -f "$HASH_FILE" ]]; then
        log_warn "未找到 hash 记录文件，将执行完整备份"
        cmd_full
        return
    fi
    
    ensure_backup_dir "incremental"
    
    # 💡 找出已修改和新增的文章
    local modified_files=()
    local new_files=()
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            local basename current_hash stored_hash
            basename=$(basename "$file")
            current_hash=$(calculate_hash "$file")
            stored_hash=$(grep "^${basename}:" "$HASH_FILE" 2>/dev/null | cut -d: -f2 || echo "")
            
            if [[ -z "$stored_hash" ]]; then
                new_files+=("$file")
            elif [[ "$current_hash" != "$stored_hash" ]]; then
                modified_files+=("$file")
            fi
        fi
    done
    
    local total=$((${#modified_files[@]} + ${#new_files[@]}))
    
    if [[ $total -eq 0 ]]; then
        log_info "没有文章需要备份（自上次备份以来无变化）"
        return 0
    fi
    
    echo "检测到变化:"
    echo "  新文章: ${#new_files[@]} 篇"
    echo "  已修改: ${#modified_files[@]} 篇"
    echo ""
    
    local backup_dir="${BACKUP_BASE}/incremental/${TIMESTAMP}"
    mkdir -p "$backup_dir"
    
    # 💡 复制变化的文件
    for file in "${modified_files[@]}" "${new_files[@]}"; do
        cp "$file" "$backup_dir/"
    done
    
    # 💡 创建 tar.gz
    local backup_file="${BACKUP_BASE}/incremental_${TIMESTAMP}.tar.gz"
    tar -czf "$backup_file" -C "${BACKUP_BASE}/incremental" "${TIMESTAMP}"
    rm -rf "$backup_dir"
    
    # 💡 创建元数据
    create_backup_info "$backup_file" "incremental" "$total"
    
    log_success "增量备份完成"
    echo ""
    echo "  📁 文件: $backup_file"
    echo "  📊 文章: $total 篇"
    echo "  💿 大小: $(du -h "$backup_file" | cut -f1)"
}

# ============================================
# 单篇备份
# ============================================

cmd_single() {
    local file="${1:-}"
    
    if [[ -z "$file" ]]; then
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "    💾 单篇备份"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "选择要备份的文章:"
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
        read -p "输入序号: " selection
        
        file="${files_arr[$((selection-1))]:-}"
        
        if [[ -z "$file" || ! -f "$file" ]]; then
            log_error "无效选择"
            return 1
        fi
    else
        if [[ ! -f "$file" ]]; then
            file="${POST_DIR}/${file}"
        fi
        
        if [[ ! -f "$file" ]]; then
            log_error "文件不存在: $file"
            return 1
        fi
    fi
    
    ensure_backup_dir "single"
    
    local basename title
    basename=$(basename "$file" .md)
    title=$(get_title "$file")
    
    local backup_file="${BACKUP_BASE}/single/${basename}_${TIMESTAMP}.md"
    
    cp "$file" "$backup_file"
    
    log_success "单篇备份完成"
    echo ""
    echo "  📝 文章: $title"
    echo "  📁 备份: $backup_file"
}

# ============================================
# 列出备份
# ============================================

cmd_list() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📋 备份列表"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ ! -d "$BACKUP_BASE" ]]; then
        log_warn "备份目录不存在"
        return 0
    fi
    
    # 💡 完整备份
    echo "📦 完整备份:"
    local full_count=0
    for backup in "${BACKUP_BASE}"/full_*.tar.gz; do
        if [[ -f "$backup" ]]; then
            ((full_count++))
            local name size date
            name=$(basename "$backup")
            size=$(du -h "$backup" | cut -f1)
            date=${name#full_}
            date=${date%.tar.gz}
            date=${date//_/ }
            printf "  [%d] %s (%s)\n" "$full_count" "$date" "$size"
        fi
    done
    [[ $full_count -eq 0 ]] && echo "  (无)"
    echo ""
    
    # 💡 增量备份
    echo "📈 增量备份:"
    local incr_count=0
    for backup in "${BACKUP_BASE}"/incremental_*.tar.gz; do
        if [[ -f "$backup" ]]; then
            ((incr_count++))
            local name size date info articles
            name=$(basename "$backup")
            size=$(du -h "$backup" | cut -f1)
            date=${name#incremental_}
            date=${date%.tar.gz}
            date=${date//_/ }
            
            info="${backup%.tar.gz}.info"
            if [[ -f "$info" ]]; then
                articles=$(grep "^count:" "$info" | cut -d: -f2 | xargs)
            else
                articles="?"
            fi
            
            printf "  [%d] %s (%s, %s 篇)\n" "$incr_count" "$date" "$size" "$articles"
        fi
    done
    [[ $incr_count -eq 0 ]] && echo "  (无)"
    echo ""
    
    # 💡 单篇备份
    echo "📄 单篇备份:"
    if [[ -d "${BACKUP_BASE}/single" ]]; then
        local single_count=0
        for backup in "${BACKUP_BASE}/single"/*.md; do
            if [[ -f "$backup" ]]; then
                ((single_count++))
                local name
                name=$(basename "$backup")
                printf "  [%d] %s\n" "$single_count" "$name"
            fi
        done
        [[ $single_count -eq 0 ]] && echo "  (无)"
    else
        echo "  (无)"
    fi
    
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [[ -d "$BACKUP_BASE" ]]; then
        echo "总大小: $(du -sh "$BACKUP_BASE" 2>/dev/null | cut -f1 || echo "0")"
    fi
}

# ============================================
# 从完整备份恢复
# ============================================

cmd_restore_full() {
    local backup="${1:-}"
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🔄 从完整备份恢复"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ -z "$backup" ]]; then
        echo "选择备份:"
        echo ""
        
        local num=1
        local backups_arr=()
        
        for b in "${BACKUP_BASE}"/full_*.tar.gz; do
            if [[ -f "$b" ]]; then
                backups_arr+=("$b")
                local name size date
                name=$(basename "$b")
                size=$(du -h "$b" | cut -f1)
                date=${name#full_}
                date=${date%.tar.gz}
                date=${date//_/ }
                printf "[%d] %s (%s)\n" "$num" "$date" "$size"
                ((num++))
            fi
        done
        
        if [[ ${#backups_arr[@]} -eq 0 ]]; then
            log_warn "未找到完整备份"
            return 1
        fi
        
        echo ""
        read -p "输入序号: " selection
        
        backup="${backups_arr[$((selection-1))]:-}"
        
        if [[ -z "$backup" || ! -f "$backup" ]]; then
            log_error "无效选择"
            return 1
        fi
    else
        if [[ ! -f "$backup" ]]; then
            backup="${BACKUP_BASE}/${backup}"
        fi
        
        if [[ ! -f "$backup" ]]; then
            log_error "备份文件不存在: $backup"
            return 1
        fi
    fi
    
    echo ""
    log_warn "⚠️  此操作将覆盖现有的所有文章！"
    echo ""
    echo "备份文件: $backup"
    echo ""
    read -p "确认恢复? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 💡 先备份当前状态
        log_info "备份当前状态..."
        local pre_restore="${BACKUP_BASE}/pre_restore_${TIMESTAMP}.tar.gz"
        tar -czf "$pre_restore" -C "$(dirname "$POST_DIR")" "$(basename "$POST_DIR")" 2>/dev/null || true
        
        # 💡 恢复备份
        log_info "恢复备份..."
        rm -rf "$POST_DIR"
        mkdir -p "$POST_DIR"
        tar -xzf "$backup" -C "$(dirname "$POST_DIR")"
        
        log_success "恢复完成"
        echo ""
        echo "  📁 恢复前备份: $pre_restore"
        echo "  📊 文章数: $(find "$POST_DIR" -name '*.md' | wc -l) 篇"
    else
        log_info "已取消"
    fi
}

# ============================================
# 恢复单篇文章
# ============================================

cmd_restore_single() {
    local file="${1:-}"
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🔄 恢复单篇文章"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ ! -d "${BACKUP_BASE}/single" ]]; then
        log_warn "未找到单篇备份"
        return 1
    fi
    
    if [[ -z "$file" ]]; then
        echo "选择要恢复的备份:"
        echo ""
        
        local num=1
        local backups_arr=()
        
        for b in "${BACKUP_BASE}/single"/*.md; do
            if [[ -f "$b" ]]; then
                backups_arr+=("$b")
                printf "[%d] %s\n" "$num" "$(basename "$b")"
                ((num++))
            fi
        done
        
        if [[ ${#backups_arr[@]} -eq 0 ]]; then
            log_warn "未找到单篇备份"
            return 1
        fi
        
        echo ""
        read -p "输入序号: " selection
        
        file="${backups_arr[$((selection-1))]:-}"
        
        if [[ -z "$file" || ! -f "$file" ]]; then
            log_error "无效选择"
            return 1
        fi
    else
        if [[ ! -f "$file" ]]; then
            file="${BACKUP_BASE}/single/${file}"
        fi
        
        if [[ ! -f "$file" ]]; then
            log_error "备份文件不存在: $file"
            return 1
        fi
    fi
    
    local basename
    basename=$(basename "$file")
    # 💡 从备份文件名提取原始文件名（移除时间戳）
    local original_name
    original_name=$(echo "$basename" | sed 's/_[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}_[0-9]\{6\}\.md$/.md/')
    
    local target="${POST_DIR}/${original_name}"
    
    echo "备份文件: $file"
    echo "目标位置: $target"
    
    if [[ -f "$target" ]]; then
        log_warn "目标文件已存在，将被覆盖"
    fi
    
    echo ""
    read -p "确认恢复? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp "$file" "$target"
        log_success "文章已恢复: $target"
    else
        log_info "已取消"
    fi
}

# ============================================
# 清理备份
# ============================================

cmd_clean() {
    local keep=5
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --keep|-k)
                keep="$2"
                shift 2
                ;;
            *)
                shift
                ;;
        esac
    done
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🧹 清理旧备份"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "保留最近 $keep 个完整备份和增量备份"
    echo ""
    
    if [[ ! -d "$BACKUP_BASE" ]]; then
        log_info "备份目录不存在"
        return 0
    fi
    
    local deleted=0
    
    # 💡 清理完整备份
    local full_backups
    mapfile -t full_backups < <(ls -t "${BACKUP_BASE}"/full_*.tar.gz 2>/dev/null)
    
    if [[ ${#full_backups[@]} -gt $keep ]]; then
        echo "完整备份: 保留 $keep，删除 $((${#full_backups[@]} - keep))"
        for ((i=keep; i<${#full_backups[@]}; i++)); do
            rm -f "${full_backups[$i]}"
            rm -f "${full_backups[$i]%.tar.gz}.info"
            ((deleted++))
        done
    fi
    
    # 💡 清理增量备份
    local incr_backups
    mapfile -t incr_backups < <(ls -t "${BACKUP_BASE}"/incremental_*.tar.gz 2>/dev/null)
    
    if [[ ${#incr_backups[@]} -gt $keep ]]; then
        echo "增量备份: 保留 $keep，删除 $((${#incr_backups[@]} - keep))"
        for ((i=keep; i<${#incr_backups[@]}; i++)); do
            rm -f "${incr_backups[$i]}"
            rm -f "${incr_backups[$i]%.tar.gz}.info"
            ((deleted++))
        done
    fi
    
    echo ""
    
    if [[ $deleted -gt 0 ]]; then
        log_success "已删除 $deleted 个旧备份"
    else
        log_info "无需清理"
    fi
}

cmd_help() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    💾 文章备份/恢复工具"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "用法: $0 <命令> [参数]"
    echo ""
    echo "备份:"
    echo "  full                   完整备份所有文章"
    echo "  incremental            增量备份（仅已修改/新增文章）"
    echo "  single [文件]          备份单篇文章"
    echo ""
    echo "恢复:"
    echo "  restore-full [备份]    从完整备份恢复（覆盖所有）"
    echo "  restore-single [备份]  恢复单篇文章"
    echo ""
    echo "管理:"
    echo "  list                   列出所有备份"
    echo "  clean [--keep n]       清理旧备份，保留最近 n 个（默认 5）"
    echo "  help                   显示帮助"
    echo ""
    echo "示例:"
    echo "  $0 full                       # 完整备份"
    echo "  $0 incremental                # 增量备份"
    echo "  $0 single zfc-set-theory.md   # 备份单篇"
    echo "  $0 restore-full               # 交互式恢复"
    echo "  $0 clean --keep 3             # 保留最近 3 个备份"
    echo ""
    echo "配置:"
    echo "  POST_DIR=$POST_DIR"
    echo "  BACKUP_BASE=$BACKUP_BASE"
    echo ""
}

# ============================================
# 主入口
# ============================================

case "${1:-help}" in
    full)           cmd_full ;;
    incremental)    cmd_incremental ;;
    single)         cmd_single "${2:-}" ;;
    restore-full)   cmd_restore_full "${2:-}" ;;
    restore-single) cmd_restore_single "${2:-}" ;;
    list)           cmd_list ;;
    clean)          shift; cmd_clean "$@" ;;
    help|--help|-h) cmd_help ;;
    *)
        log_error "未知命令: $1"
        cmd_help
        exit 1
        ;;
esac
