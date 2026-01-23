#!/bin/bash
# 💡 智能创建新文章脚本
# 作者: CJX
# 用途: 交互式创建Hexo博客文章,自动生成Front Matter

set -e

# 颜色定义
GREEN=''
BLUE=''
YELLOW=''
RED=''
NC='' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}    Hexo 新文章创建助手${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

# 获取文章标题
read -p "$(echo -e ${GREEN}请输入文章标题:${NC} )" title

if [ -z "$title" ]; then
    echo -e "${RED}错误: 文章标题不能为空${NC}"
    exit 1
fi

# 获取分类
echo -e "\n${YELLOW}可用分类:${NC}"
echo "1. tech (技术)"
echo "2. life (生活)"
echo "3. blog (博客)"
echo "4. math (数学)"
echo "5. programming (编程)"
read -p "$(echo -e ${GREEN}请选择分类 [1-5]:${NC} )" category_choice

case $category_choice in
    1) category="tech";;
    2) category="life";;
    3) category="blog";;
    4) category="math";;
    5) category="programming";;
    *) category="blog";;
esac

# 获取标签
read -p "$(echo -e ${GREEN}请输入标签 \(用空格分隔\):${NC} )" tags_input

# 是否为草稿
read -p "$(echo -e ${GREEN}是否创建为草稿? [y/N]:${NC} )" is_draft

# 执行创建命令
if [[ $is_draft =~ ^[Yy]$ ]]; then
    echo -e "\n${BLUE}正在创建草稿...${NC}"
    npx hexo new draft "$title"
    post_type="draft"
    post_path="source/_drafts/${title}.md"
else
    echo -e "\n${BLUE}正在创建文章...${NC}"
    npx hexo new post "$title"
    post_type="post"
    post_path="source/_posts/${title}.md"
fi

# 等待文件创建
sleep 1

# 更新Front Matter
if [ -f "$post_path" ]; then
    # 使用临时文件来更新内容
    temp_file=$(mktemp)
    
    # 读取原始内容并更新
    awk -v cat="$category" -v tags="$tags_input" '
    BEGIN { in_front_matter = 0; front_matter_count = 0 }
    /^---$/ {
        print
        front_matter_count++
        in_front_matter = (front_matter_count == 1)
        next
    }
    in_front_matter && /^categories:/ {
        print "categories: " cat
        next
    }
    in_front_matter && /^tags:/ {
        if (tags != "") {
            print "tags:"
            split(tags, tag_array, " ")
            for (i in tag_array) {
                print "  - " tag_array[i]
            }
        } else {
            print "tags:"
        }
        next
    }
    { print }
    ' "$post_path" > "$temp_file"
    
    mv "$temp_file" "$post_path"
    
    echo -e "${GREEN}✓ 文章创建成功!${NC}"
    echo -e "${BLUE}文件路径:${NC} $post_path"
    echo -e "${BLUE}分类:${NC} $category"
    echo -e "${BLUE}标签:${NC} ${tags_input:-无}"
    
    # 询问是否立即编辑
    read -p "$(echo -e ${GREEN}是否立即打开编辑? [y/N]:${NC} )" open_editor
    if [[ $open_editor =~ ^[Yy]$ ]]; then
        # 尝试使用用户的默认编辑器
        ${EDITOR:-nvim} "$post_path"
    fi
else
    echo -e "${RED}错误: 文件创建失败${NC}"
    exit 1
fi

echo -e "\n${GREEN}完成!${NC}"
