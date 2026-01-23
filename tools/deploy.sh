#!/bin/bash
# 💡 一键部署脚本
# 作者: CJX
# 用途: 自动提交源码到master分支并部署到main分支

set -e

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}    Hexo 博客一键部署${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# 检查是否有未提交的更改
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}检测到未提交的更改${NC}"
    git status --short
    echo
    
    read -p "$(echo -e ${GREEN}请输入提交信息:${NC} )" commit_msg
    
    if [ -z "$commit_msg" ]; then
        commit_msg="Update: $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    
    echo -e "\n${BLUE}[1/4] 提交源码到master分支...${NC}"
    git add .
    git commit -m "$commit_msg"
    
    echo -e "${GREEN}✓ 源码提交完成${NC}\n"
else
    echo -e "${GREEN}✓ 工作区干净,无需提交${NC}\n"
fi

# 推送到远程master分支
echo -e "${BLUE}[2/4] 推送到远程master分支...${NC}"
git push origin master
echo -e "${GREEN}✓ 推送成功${NC}\n"

# 清理并生成静态文件
echo -e "${BLUE}[3/4] 生成静态文件...${NC}"
npx hexo clean
npx hexo generate
echo -e "${GREEN}✓ 静态文件生成完成${NC}\n"

# 部署到main分支
echo -e "${BLUE}[4/4] 部署到GitHub Pages (main分支)...${NC}"
npx hexo deploy
echo -e "${GREEN}✓ 部署成功${NC}\n"

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}    🎉 部署完成!${NC}"
echo -e "${GREEN}    访问: https://smlyfm.github.io${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
