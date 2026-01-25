#!/usr/bin/env bash
# ============================================
# 文章导出工具
# 💡 支持导出为 Markdown 和 PDF 格式
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
EXPORT_DIR="${EXPORT_DIR:-exports}"
TIMESTAMP=$(date '+%Y-%m-%d_%H%M%S')

# 日志函数
log_info()    { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warn()    { echo -e "${YELLOW}⚠️${NC} $1"; }
log_error()   { echo -e "${RED}❌${NC} $1"; }

# ============================================
# 核心函数
# ============================================

# 💡 确保导出目录存在
ensure_export_dir() {
    local subdir="${1:-}"
    local target="${EXPORT_DIR}"
    
    if [[ -n "$subdir" ]]; then
        target="${EXPORT_DIR}/${subdir}"
    fi
    
    if [[ ! -d "$target" ]]; then
        mkdir -p "$target"
        log_info "创建导出目录: $target"
    fi
}

# 💡 获取文章标题
get_title() {
    local file="$1"
    grep "^title:" "$file" | head -1 | cut -d':' -f2- | xargs
}

# 💡 获取文章的 Front Matter 结束行
get_frontmatter_end() {
    local file="$1"
    # 💡 Front Matter 以 --- 开始和结束
    awk '/^---$/ { count++; if (count == 2) { print NR; exit } }' "$file"
}

# 💡 导出为 Markdown（带 Front Matter）
export_md() {
    local file="$1"
    local basename
    basename=$(basename "$file")
    
    ensure_export_dir "markdown"
    
    cp "$file" "${EXPORT_DIR}/markdown/${basename}"
    log_success "导出 Markdown: ${EXPORT_DIR}/markdown/${basename}"
}

# 💡 导出为 Markdown（不含 Front Matter）
export_md_clean() {
    local file="$1"
    local basename title
    basename=$(basename "$file" .md)
    title=$(get_title "$file")
    
    ensure_export_dir "markdown-clean"
    
    local output="${EXPORT_DIR}/markdown-clean/${basename}.md"
    local fm_end
    fm_end=$(get_frontmatter_end "$file")
    
    # 💡 写入标题和内容（跳过 Front Matter）
    {
        echo "# ${title}"
        echo ""
        tail -n +"$((fm_end + 1))" "$file"
    } > "$output"
    
    log_success "导出 Markdown (无 Front Matter): $output"
}

# 💡 导出为 PDF（需要 pandoc）
export_pdf() {
    local file="$1"
    local basename title
    basename=$(basename "$file" .md)
    title=$(get_title "$file")
    
    # 💡 检查 pandoc 是否安装
    if ! command -v pandoc &> /dev/null; then
        log_error "pandoc 未安装。请先安装 pandoc:"
        echo "  Fedora: sudo dnf install pandoc texlive-xetex texlive-collection-xetex texlive-collection-langchinese"
        echo "  Ubuntu: sudo apt install pandoc texlive-xetex texlive-lang-chinese"
        return 1
    fi
    
    ensure_export_dir "pdf"
    
    local output="${EXPORT_DIR}/pdf/${basename}.pdf"
    local temp_md="/tmp/${basename}_export.md"
    local fm_end
    fm_end=$(get_frontmatter_end "$file")
    
    # 💡 创建临时文件（带标题，无 Front Matter）
    {
        echo "---"
        echo "title: \"${title}\""
        echo "documentclass: article"
        echo "geometry: margin=2.5cm"
        echo "mainfont: Noto Serif CJK SC"
        echo "monofont: 0xProto Nerd Font Mono"
        echo "CJKmainfont: Noto Serif CJK SC"
        echo "---"
        echo ""
        tail -n +"$((fm_end + 1))" "$file"
    } > "$temp_md"
    
    log_info "正在生成 PDF..."
    
    if pandoc "$temp_md" \
        --pdf-engine=xelatex \
        -V geometry:margin=2.5cm \
        -V fontsize=11pt \
        --highlight-style=tango \
        -o "$output" 2>/dev/null; then
        log_success "导出 PDF: $output"
    else
        log_error "PDF 生成失败，尝试不使用 CJK 字体..."
        # 💡 回退：不使用 CJK 特定字体
        if pandoc "$temp_md" \
            --pdf-engine=xelatex \
            -V geometry:margin=2.5cm \
            -V fontsize=11pt \
            --highlight-style=tango \
            -o "$output"; then
            log_success "导出 PDF: $output"
        else
            log_error "PDF 生成失败，请检查 LaTeX 环境"
            rm -f "$temp_md"
            return 1
        fi
    fi
    
    rm -f "$temp_md"
}

# ============================================
# 命令实现
# ============================================

cmd_md() {
    local file="${1:-}"
    
    if [[ -z "$file" ]]; then
        log_error "用法: $0 md <文件名.md>"
        echo ""
        echo "可用文章:"
        ls -1 "${POST_DIR}"/*.md 2>/dev/null | xargs -n1 basename | head -10
        return 1
    fi
    
    # 💡 支持文件名或完整路径
    if [[ ! -f "$file" ]]; then
        file="${POST_DIR}/${file}"
    fi
    
    if [[ ! -f "$file" ]]; then
        log_error "文件不存在: $file"
        return 1
    fi
    
    export_md "$file"
}

cmd_md_clean() {
    local file="${1:-}"
    
    if [[ -z "$file" ]]; then
        log_error "用法: $0 md-clean <文件名.md>"
        return 1
    fi
    
    if [[ ! -f "$file" ]]; then
        file="${POST_DIR}/${file}"
    fi
    
    if [[ ! -f "$file" ]]; then
        log_error "文件不存在: $file"
        return 1
    fi
    
    export_md_clean "$file"
}

cmd_pdf() {
    local file="${1:-}"
    
    if [[ -z "$file" ]]; then
        log_error "用法: $0 pdf <文件名.md>"
        return 1
    fi
    
    if [[ ! -f "$file" ]]; then
        file="${POST_DIR}/${file}"
    fi
    
    if [[ ! -f "$file" ]]; then
        log_error "文件不存在: $file"
        return 1
    fi
    
    export_pdf "$file"
}

cmd_all_md() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📤 批量导出所有文章为 Markdown"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    ensure_export_dir "markdown"
    local count=0
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            export_md "$file"
            ((count++))
        fi
    done
    
    echo ""
    log_success "已导出 $count 篇文章到 ${EXPORT_DIR}/markdown/"
}

cmd_all_md_clean() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📤 批量导出所有文章 (无 Front Matter)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    ensure_export_dir "markdown-clean"
    local count=0
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            export_md_clean "$file"
            ((count++))
        fi
    done
    
    echo ""
    log_success "已导出 $count 篇文章到 ${EXPORT_DIR}/markdown-clean/"
}

cmd_all_pdf() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📤 批量导出所有文章为 PDF"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if ! command -v pandoc &> /dev/null; then
        log_error "pandoc 未安装，无法导出 PDF"
        return 1
    fi
    
    ensure_export_dir "pdf"
    local count=0
    local failed=0
    
    for file in "${POST_DIR}"/*.md; do
        if [[ -f "$file" ]]; then
            if export_pdf "$file"; then
                ((count++))
            else
                ((failed++))
            fi
        fi
    done
    
    echo ""
    log_success "已导出 $count 篇文章到 ${EXPORT_DIR}/pdf/"
    if [[ $failed -gt 0 ]]; then
        log_warn "$failed 篇文章导出失败"
    fi
}

cmd_list() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📁 已导出文件列表"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ ! -d "$EXPORT_DIR" ]]; then
        log_warn "导出目录不存在: $EXPORT_DIR"
        return 0
    fi
    
    if [[ -d "${EXPORT_DIR}/markdown" ]]; then
        echo "📄 Markdown 文件:"
        ls -lh "${EXPORT_DIR}/markdown"/*.md 2>/dev/null || echo "  (空)"
        echo ""
    fi
    
    if [[ -d "${EXPORT_DIR}/markdown-clean" ]]; then
        echo "📄 Markdown (无 Front Matter):"
        ls -lh "${EXPORT_DIR}/markdown-clean"/*.md 2>/dev/null || echo "  (空)"
        echo ""
    fi
    
    if [[ -d "${EXPORT_DIR}/pdf" ]]; then
        echo "📕 PDF 文件:"
        ls -lh "${EXPORT_DIR}/pdf"/*.pdf 2>/dev/null || echo "  (空)"
        echo ""
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "总大小: $(du -sh "$EXPORT_DIR" 2>/dev/null | cut -f1 || echo "0")"
}

cmd_clean() {
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🧹 清理导出目录"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    if [[ ! -d "$EXPORT_DIR" ]]; then
        log_info "导出目录不存在，无需清理"
        return 0
    fi
    
    local size
    size=$(du -sh "$EXPORT_DIR" 2>/dev/null | cut -f1 || echo "0")
    
    read -p "确认删除 $EXPORT_DIR (大小: $size)? [y/N] " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$EXPORT_DIR"
        log_success "已清理导出目录"
    else
        log_info "已取消"
    fi
}

cmd_help() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    📤 文章导出工具"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "用法: $0 <命令> [参数]"
    echo ""
    echo "单篇导出:"
    echo "  md <文件>        导出为 Markdown（含 Front Matter）"
    echo "  md-clean <文件>  导出为 Markdown（不含 Front Matter）"
    echo "  pdf <文件>       导出为 PDF（需要 pandoc + xelatex）"
    echo ""
    echo "批量导出:"
    echo "  all-md           导出所有文章为 Markdown"
    echo "  all-md-clean     导出所有文章为 Markdown (无 Front Matter)"
    echo "  all-pdf          导出所有文章为 PDF"
    echo ""
    echo "管理:"
    echo "  list             查看已导出文件"
    echo "  clean            清理导出目录"
    echo "  help             显示帮助"
    echo ""
    echo "示例:"
    echo "  $0 md zfc-set-theory.md"
    echo "  $0 pdf pytorch-autograd.md"
    echo "  $0 all-md"
    echo ""
    echo "配置:"
    echo "  POST_DIR=$POST_DIR"
    echo "  EXPORT_DIR=$EXPORT_DIR"
    echo ""
}

# ============================================
# 主入口
# ============================================

case "${1:-help}" in
    md)           cmd_md "${2:-}" ;;
    md-clean)     cmd_md_clean "${2:-}" ;;
    pdf)          cmd_pdf "${2:-}" ;;
    all-md)       cmd_all_md ;;
    all-md-clean) cmd_all_md_clean ;;
    all-pdf)      cmd_all_pdf ;;
    list)         cmd_list ;;
    clean)        cmd_clean ;;
    help|--help|-h) cmd_help ;;
    *)
        log_error "未知命令: $1"
        cmd_help
        exit 1
        ;;
esac
