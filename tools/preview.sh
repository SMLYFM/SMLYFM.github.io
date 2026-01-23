#!/bin/bash
# 💡 本地预览脚本
# 作者: CJX
# 用途: 启动Hexo本地服务器,支持草稿预览和自动打开浏览器

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}    Hexo 本地预览服务${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# 解析参数
SHOW_DRAFTS=false
PORT=4000
OPEN_BROWSER=true

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--draft)
            SHOW_DRAFTS=true
            shift
            ;;
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        --no-browser)
            OPEN_BROWSER=false
            shift
            ;;
        -h|--help)
            echo "用法: $0 [选项]"
            echo "选项:"
            echo "  -d, --draft        显示草稿"
            echo "  -p, --port PORT    指定端口 (默认: 4000)"
            echo "  --no-browser       不自动打开浏览器"
            echo "  -h, --help         显示帮助信息"
            exit 0
            ;;
        *)
            echo -e "${YELLOW}未知选项: $1${NC}"
            shift
            ;;
    esac
done

# 构建启动命令
CMD="npx hexo server -p $PORT"

if [ "$SHOW_DRAFTS" = true ]; then
    CMD="$CMD --draft"
    echo -e "${YELLOW}📝 草稿模式已启用${NC}"
fi

echo -e "${BLUE}正在启动服务器...${NC}"
echo -e "${BLUE}端口: ${PORT}${NC}"
echo -e "${BLUE}地址: http://localhost:${PORT}${NC}\n"

# 在后台启动服务器
$CMD &
SERVER_PID=$!

# 等待服务器启动
sleep 3

# 自动打开浏览器
if [ "$OPEN_BROWSER" = true ]; then
    if command -v xdg-open &> /dev/null; then
        echo -e "${GREEN}🌐 正在打开浏览器...${NC}"
        xdg-open "http://localhost:${PORT}" &
    fi
fi

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✓ 服务器已启动 (PID: $SERVER_PID)${NC}"
echo -e "${GREEN}按 Ctrl+C 停止服务器${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# 等待用户中断
wait $SERVER_PID
