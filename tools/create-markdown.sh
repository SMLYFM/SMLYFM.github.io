#!/bin/bash
# ============================================
# Markdown 文章模板生成器
# ============================================
# 💡 支持多种模板、自动填充时间和元数据
# 💡 作者: CJX

set -e

# ============================================
# 颜色定义
# ============================================
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================
# 时间变量
# ============================================
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
CURRENT_YEAR=$(date '+%Y')
CURRENT_MONTH=$(date '+%m')
CURRENT_DAY=$(date '+%d')

# ============================================
# 配置
# ============================================
POST_DIR="source/_posts"
DRAFT_DIR="source/_drafts"
AUTHOR="CJX"

# ============================================
# 模板定义
# ============================================

# 基础文章模板
template_basic() {
    local title="$1"
    local category="${2:-blog}"
    local tags="$3"
    
    cat << EOF
---
title: ${title}
date: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
categories: ${category}
tags:
EOF
    
    # 处理标签
    if [ -n "$tags" ]; then
        IFS=' ' read -ra TAG_ARRAY <<< "$tags"
        for tag in "${TAG_ARRAY[@]}"; do
            echo "  - $tag"
        done
    fi
    
    cat << EOF
---

## 简介

在这里写文章简介...

<!-- more -->

## 正文

在这里写正文内容...

## 总结

在这里写总结...

---

**参考资料**:
- 

**相关文章**:
- 
EOF
}

# 技术文章模板
template_tech() {
    local title="$1"
    local category="${2:-tech}"
    local tags="$3"
    
    cat << EOF
---
title: ${title}
date: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
categories: ${category}
tags:
EOF
    
    if [ -n "$tags" ]; then
        IFS=' ' read -ra TAG_ARRAY <<< "$tags"
        for tag in "${TAG_ARRAY[@]}"; do
            echo "  - $tag"
        done
    fi
    
    cat << EOF
author: ${AUTHOR}
description: 
keywords: 
---

## 📌 背景

在这里描述技术背景和问题...

<!-- more -->

## 🎯 目标

- 目标1
- 目标2
- 目标3

## 💡 解决方案

### 方案概述

在这里描述整体方案...

### 技术选型

| 技术 | 版本 | 用途 |
|------|------|------|
|      |      |      |

### 实现步骤

#### 步骤1: 

\`\`\`bash
# 代码示例
\`\`\`

#### 步骤2:

\`\`\`bash
# 代码示例
\`\`\`

## 🔍 关键代码

\`\`\`python
# 示例代码
\`\`\`

## ⚠️ 注意事项

- 注意事项1
- 注意事项2

## 🧪 测试验证

\`\`\`bash
# 测试命令
\`\`\`

## 📊 性能对比

| 指标 | 优化前 | 优化后 | 提升 |
|------|--------|--------|------|
|      |        |        |      |

## 🎓 总结

在这里写总结...

## 📚 参考资料

- [标题](链接)
- [标题](链接)

---

> 本文首发于 [个人博客](https://smlyfm.github.io)
> 
> 作者: ${AUTHOR}  
> 日期: ${CURRENT_DATE}
EOF
}

# 数学/学术文章模板
template_math() {
    local title="$1"
    local category="${2:-math}"
    local tags="$3"
    
    cat << EOF
---
title: ${title}
date: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
categories: ${category}
tags:
EOF
    
    if [ -n "$tags" ]; then
        IFS=' ' read -ra TAG_ARRAY <<< "$tags"
        for tag in "${TAG_ARRAY[@]}"; do
            echo "  - $tag"
        done
    fi
    
    cat << EOF
mathjax: true
author: ${AUTHOR}
---

## 摘要

在这里写摘要...

<!-- more -->

## 1. 引言

### 1.1 研究背景

在这里描述研究背景...

### 1.2 主要贡献

- 贡献1
- 贡献2

## 2. 预备知识

### 2.1 定义

**定义 2.1.1** (核心概念)

在这里给出定义...

### 2.2 定理

**定理 2.2.1** (主要定理)

在这里给出定理...

**证明:**

\$\$
\\begin{align}
f(x) &= \\int_0^\\infty g(t) dt \\\\\\
     &= \\cdots
\\end{align}
\$\$

## 3. 主要结果

### 3.1 问题陈述

考虑以下问题:

\$\$
\\begin{cases}
u_t - \\Delta u = f(x,t) & \\text{in } \\Omega \\times (0,T) \\\\\\
u = 0 & \\text{on } \\partial\\Omega \\times (0,T) \\\\\\
u(x,0) = u_0(x) & \\text{in } \\Omega
\\end{cases}
\$\$

其中 \$\\Omega \\subset \\mathbb{R}^n\$ 是有界区域。

### 3.2 理论分析

**引理 3.2.1**

在这里给出引理...

## 4. 数值实验

### 4.1 实验设置

参数配置:
- 参数1: 值
- 参数2: 值

### 4.2 实验结果

| 方法 | 误差 | 时间(s) |
|------|------|---------|
|      |      |         |

## 5. 总结与展望

### 5.1 总结

在这里写总结...

### 5.2 未来工作

- 方向1
- 方向2

## 参考文献

1. Author A, Author B. *Title*. Journal, Year.
2. Author C. *Title*. Conference, Year.

---

**Keywords**: keyword1, keyword2, keyword3  
**MSC (2020)**: 35K05, 65M60
EOF
}

# 教程模板
template_tutorial() {
    local title="$1"
    local category="${2:-tutorial}"
    local tags="$3"
    
    cat << EOF
---
title: ${title}
date: ${CURRENT_DATE}
updated: ${CURRENT_DATE}
categories: ${category}
tags:
EOF
    
    if [ -n "$tags" ]; then
        IFS=' ' read -ra TAG_ARRAY <<< "$tags"
        for tag in "${TAG_ARRAY[@]}"; do
            echo "  - $tag"
        done
    fi
    
    cat << EOF
author: ${AUTHOR}
toc: true
---

## 🎯 教程目标

完成本教程后,你将学会:

- [ ] 目标1
- [ ] 目标2
- [ ] 目标3

## 📋 前置要求

开始之前,请确保你已经:

- [ ] 要求1
- [ ] 要求2

<!-- more -->

## 🚀 快速开始

### 第一步: 环境准备

\`\`\`bash
# 安装依赖
npm install
\`\`\`

### 第二步: 配置

创建配置文件:

\`\`\`yaml
# config.yml
key: value
\`\`\`

### 第三步: 运行

\`\`\`bash
npm start
\`\`\`

## 📖 详细说明

### 概念解释

在这里解释核心概念...

### 工作原理

在这里解释工作原理...

## 🔧 高级用法

### 自定义配置

\`\`\`javascript
// 配置示例
const config = {
  // ...
};
\`\`\`

### 常见场景

#### 场景1: 

解决方案:

\`\`\`bash
# 命令
\`\`\`

## ⚠️ 常见问题

### 问题1: 

**原因**: 

**解决方案**:

\`\`\`bash
# 解决命令
\`\`\`

### 问题2:

**原因**:

**解决方案**:

## 🎓 最佳实践

1. 实践1
2. 实践2
3. 实践3

## 📝 总结

在这里写总结...

## 🔗 相关资源

- [文档](链接)
- [示例](链接)
- [视频教程](链接)

## 💬 反馈

如有问题或建议,欢迎:
- 在下方评论
- 提交 [Issue](链接)
- 发送邮件至: sudocjx@gmail.com

---

> 更新日期: ${CURRENT_DATE}  
> 难度: ⭐⭐⭐  
> 预计时间: 30分钟
EOF
}

# ============================================
# 主函数
# ============================================

show_menu() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}    Markdown 文章模板生成器${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${YELLOW}选择模板类型:${NC}"
    echo "  1. 基础文章"
    echo "  2. 技术文章"
    echo "  3. 数学/学术文章"
    echo "  4. 教程"
    echo "  5. 自定义"
    echo ""
}

main() {
    # 显示菜单
    show_menu
    
    # 读取选择
    read -p "$(echo -e ${CYAN}请选择模板 [1-5]:${NC} )" template_choice
    echo ""
    
    # 读取文章信息
    read -p "$(echo -e ${CYAN}文章标题:${NC} )" title
    
    if [ -z "$title" ]; then
        echo -e "${RED}错误: 标题不能为空${NC}"
        exit 1
    fi
    
    read -p "$(echo -e ${CYAN}分类 [blog]:${NC} )" category
    category=${category:-blog}
    
    read -p "$(echo -e ${CYAN}标签 \(空格分隔\):${NC} )" tags
    
    read -p "$(echo -e ${CYAN}保存为草稿? [y/N]:${NC} )" is_draft
    
    # 确定保存目录
    if [[ $is_draft =~ ^[Yy]$ ]]; then
        target_dir="$DRAFT_DIR"
        mkdir -p "$target_dir"
    else
        target_dir="$POST_DIR"
    fi
    
    # 生成文件名
    filename="${target_dir}/${title}.md"
    
    # 检查文件是否已存在
    if [ -f "$filename" ]; then
        echo -e "${YELLOW}⚠️  文件已存在: $filename${NC}"
        read -p "是否覆盖? [y/N] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${RED}已取消${NC}"
            exit 0
        fi
    fi
    
    # 生成模板内容
    echo -e "${BLUE}正在生成模板...${NC}"
    
    case $template_choice in
        1)
            template_basic "$title" "$category" "$tags" > "$filename"
            ;;
        2)
            template_tech "$title" "$category" "$tags" > "$filename"
            ;;
        3)
            template_math "$title" "$category" "$tags" > "$filename"
            ;;
        4)
            template_tutorial "$title" "$category" "$tags" > "$filename"
            ;;
        5)
            template_basic "$title" "$category" "$tags" > "$filename"
            ;;
        *)
            echo -e "${RED}无效的选择${NC}"
            exit 1
            ;;
    esac
    
    # 显示结果
    echo ""
    echo -e "${GREEN}✓ 文章已创建!${NC}"
    echo -e "${CYAN}文件路径:${NC} $filename"
    echo -e "${CYAN}标题:${NC}     $title"
    echo -e "${CYAN}分类:${NC}     $category"
    echo -e "${CYAN}标签:${NC}     ${tags:-无}"
    echo -e "${CYAN}类型:${NC}     $([ "$is_draft" = "y" ] && echo "草稿" || echo "正式文章")"
    echo ""
    
    # 询问是否打开编辑器
    read -p "$(echo -e ${CYAN}是否立即打开编辑器? [Y/n]:${NC} )" open_editor
    if [[ ! $open_editor =~ ^[Nn]$ ]]; then
        ${EDITOR:-nvim} "$filename"
    fi
}

# 运行主函数
main
