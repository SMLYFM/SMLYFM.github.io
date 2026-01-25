#!/usr/bin/env bash
# ============================================
# 容器管理统一脚本
# 💡 自动检测 Docker/Podman 并执行相应命令
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
NC='\033[0m' # No Color

# 配置
IMAGE_NAME="${IMAGE_NAME:-smlyfm-blog}"
IMAGE_TAG="${IMAGE_TAG:-latest}"
CONTAINER_NAME="${CONTAINER_NAME:-smlyfm-blog}"
DEV_PORT="${DEV_PORT:-4000}"
PROD_PORT="${PROD_PORT:-80}"

# ============================================
# 工具函数
# ============================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# 💡 自动检测容器运行时
detect_runtime() {
    if command -v podman &> /dev/null; then
        echo "podman"
    elif command -v docker &> /dev/null; then
        echo "docker"
    else
        log_error "未找到 Docker 或 Podman，请先安装容器运行时"
        exit 1
    fi
}

# 💡 检测 compose 工具
detect_compose() {
    local runtime=$1
    if [[ "$runtime" == "podman" ]]; then
        if command -v podman-compose &> /dev/null; then
            echo "podman-compose"
        elif podman compose version &> /dev/null; then
            echo "podman compose"
        else
            log_warn "podman-compose 未安装，请运行: pip install podman-compose"
            return 1
        fi
    else
        if docker compose version &> /dev/null; then
            echo "docker compose"
        elif command -v docker-compose &> /dev/null; then
            echo "docker-compose"
        else
            log_warn "docker compose 未安装"
            return 1
        fi
    fi
}

RUNTIME=$(detect_runtime)
log_info "检测到容器运行时: ${CYAN}${RUNTIME}${NC}"

# ============================================
# 命令实现
# ============================================

cmd_build() {
    log_info "构建镜像: ${IMAGE_NAME}:${IMAGE_TAG}"
    $RUNTIME build -t "${IMAGE_NAME}:${IMAGE_TAG}" .
    log_success "镜像构建完成"
}

cmd_run() {
    local port=${1:-$PROD_PORT}
    log_info "启动容器 (端口: $port)"
    
    # 停止已有容器
    $RUNTIME stop "$CONTAINER_NAME" 2>/dev/null || true
    $RUNTIME rm "$CONTAINER_NAME" 2>/dev/null || true
    
    $RUNTIME run -d \
        --name "$CONTAINER_NAME" \
        -p "${port}:80" \
        --restart unless-stopped \
        "${IMAGE_NAME}:${IMAGE_TAG}"
    
    log_success "容器已启动: http://localhost:${port}"
}

cmd_dev() {
    log_info "启动开发容器 (热重载模式)"
    
    # 停止已有容器
    $RUNTIME stop "${CONTAINER_NAME}-dev" 2>/dev/null || true
    $RUNTIME rm "${CONTAINER_NAME}-dev" 2>/dev/null || true
    
    # 💡 开发模式：挂载源码目录，运行 hexo server
    $RUNTIME run -d \
        --name "${CONTAINER_NAME}-dev" \
        -p "${DEV_PORT}:4000" \
        -v "$(pwd)/source:/app/source:ro" \
        -v "$(pwd)/_config.yml:/app/_config.yml:ro" \
        -v "$(pwd)/_config.butterfly.yml:/app/_config.butterfly.yml:ro" \
        -w /app \
        node:18-alpine \
        sh -c "npm install && npx hexo server --draft"
    
    log_success "开发容器已启动: http://localhost:${DEV_PORT}"
    log_info "修改源文件后页面会自动刷新"
}

cmd_stop() {
    log_info "停止容器..."
    $RUNTIME stop "$CONTAINER_NAME" 2>/dev/null || true
    $RUNTIME rm "$CONTAINER_NAME" 2>/dev/null || true
    $RUNTIME stop "${CONTAINER_NAME}-dev" 2>/dev/null || true
    $RUNTIME rm "${CONTAINER_NAME}-dev" 2>/dev/null || true
    log_success "容器已停止"
}

cmd_logs() {
    local container=${1:-$CONTAINER_NAME}
    $RUNTIME logs -f "$container"
}

cmd_shell() {
    local container=${1:-$CONTAINER_NAME}
    log_info "进入容器 shell..."
    $RUNTIME exec -it "$container" sh
}

cmd_status() {
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "    🐳 容器状态"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "运行时: $RUNTIME"
    echo ""
    
    # 检查容器状态
    local prod_status=$($RUNTIME ps -a --filter "name=$CONTAINER_NAME" --format "{{.Status}}" 2>/dev/null | head -1)
    local dev_status=$($RUNTIME ps -a --filter "name=${CONTAINER_NAME}-dev" --format "{{.Status}}" 2>/dev/null | head -1)
    
    if [[ -n "$prod_status" ]]; then
        echo "生产容器: $prod_status"
    else
        echo "生产容器: 未创建"
    fi
    
    if [[ -n "$dev_status" ]]; then
        echo "开发容器: $dev_status"
    else
        echo "开发容器: 未创建"
    fi
    
    echo ""
    echo "镜像列表:"
    $RUNTIME images | grep -E "^${IMAGE_NAME}|REPOSITORY" || echo "  (无相关镜像)"
    echo ""
}

cmd_clean() {
    log_info "清理悬空镜像和已停止容器..."
    
    # 清理已停止的容器
    $RUNTIME container prune -f || true
    
    # 清理悬空镜像
    $RUNTIME image prune -f || true
    
    log_success "清理完成"
}

cmd_export() {
    local output="smlyfm-blog-${IMAGE_TAG}.tar"
    log_info "导出镜像到: $output"
    $RUNTIME save -o "$output" "${IMAGE_NAME}:${IMAGE_TAG}"
    log_success "镜像已导出: $output ($(du -h "$output" | cut -f1))"
}

cmd_health() {
    log_info "检查容器健康状态..."
    
    if $RUNTIME ps --filter "name=$CONTAINER_NAME" --filter "status=running" | grep -q "$CONTAINER_NAME"; then
        # 容器运行中，检查 HTTP 响应
        local health_url="http://localhost:${PROD_PORT}/health"
        if curl -sf "$health_url" > /dev/null 2>&1; then
            log_success "容器健康: $health_url 响应正常"
        else
            log_warn "容器运行中但 HTTP 检查失败"
        fi
    else
        log_warn "容器未运行"
    fi
}

cmd_compose_up() {
    local compose_cmd
    compose_cmd=$(detect_compose "$RUNTIME") || exit 1
    log_info "使用 $compose_cmd 启动服务..."
    $compose_cmd up -d --build
    log_success "服务已启动"
}

cmd_compose_down() {
    local compose_cmd
    compose_cmd=$(detect_compose "$RUNTIME") || exit 1
    log_info "停止 compose 服务..."
    $compose_cmd down
    log_success "服务已停止"
}

cmd_help() {
    cat << EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🐳 容器管理脚本
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

用法: $0 <命令> [参数]

构建与运行:
  build             构建镜像
  run [端口]        运行生产容器 (默认端口: $PROD_PORT)
  dev               运行开发容器 (热重载, 端口: $DEV_PORT)
  stop              停止所有容器

管理:
  status            查看容器状态
  logs [容器名]     查看容器日志
  shell [容器名]    进入容器 shell
  health            检查容器健康

Compose:
  compose-up        使用 Compose 启动
  compose-down      使用 Compose 停止

维护:
  clean             清理悬空镜像和容器
  export            导出镜像为 tar 文件

环境变量:
  IMAGE_NAME        镜像名称 (默认: $IMAGE_NAME)
  IMAGE_TAG         镜像标签 (默认: $IMAGE_TAG)
  CONTAINER_NAME    容器名称 (默认: $CONTAINER_NAME)
  DEV_PORT          开发端口 (默认: $DEV_PORT)
  PROD_PORT         生产端口 (默认: $PROD_PORT)

检测到运行时: $RUNTIME

EOF
}

# ============================================
# 主入口
# ============================================

case "${1:-help}" in
    build)       cmd_build ;;
    run)         cmd_run "${2:-}" ;;
    dev)         cmd_dev ;;
    stop)        cmd_stop ;;
    logs)        cmd_logs "${2:-}" ;;
    shell)       cmd_shell "${2:-}" ;;
    status)      cmd_status ;;
    clean)       cmd_clean ;;
    export)      cmd_export ;;
    health)      cmd_health ;;
    compose-up)  cmd_compose_up ;;
    compose-down) cmd_compose_down ;;
    help|--help|-h) cmd_help ;;
    *)
        log_error "未知命令: $1"
        cmd_help
        exit 1
        ;;
esac
