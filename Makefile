# ============================================
# Hexo 博客项目 Makefile
# ============================================
# 💡 提供完整的博客管理功能
# 💡 作者: CJX
# 💡 项目: SMLYFM.github.io
# 💡 更新: 2026-01-25

.PHONY: help install clean build deploy server dev new draft publish status push pull sync list check upgrade backup restore

# 默认目标
.DEFAULT_GOAL := help

# 项目信息
PROJECT_NAME := SMLYFM.github.io
HEXO_VERSION := $(shell npx hexo version 2>/dev/null | grep hexo | cut -d':' -f2 | xargs)
NODE_VERSION := $(shell node --version 2>/dev/null)
NPM_VERSION := $(shell npm --version 2>/dev/null)

# 目录定义
SOURCE_DIR := source
POST_DIR := $(SOURCE_DIR)/_posts
DRAFT_DIR := $(SOURCE_DIR)/_drafts
PUBLIC_DIR := public
DEPLOY_DIR := .deploy_git
BACKUP_DIR := ../backup

# Git配置
GIT_BRANCH_SOURCE := master
GIT_BRANCH_DEPLOY := main
GIT_REMOTE := origin

# 时间戳
TIMESTAMP := $(shell date '+%Y-%m-%d %H:%M:%S')
DATE := $(shell date '+%Y-%m-%d')
TIME := $(shell date '+%H:%M:%S')

# 编辑器
EDITOR := $${EDITOR:-code}

# ============================================
# 帮助信息
# ============================================
help: ## 显示帮助信息
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    $(PROJECT_NAME) - Hexo 博客管理系统"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "🚀 快速开始:  make quick-start"
	@echo ""
	@echo "📝 文章管理:"
	@echo "  make new              交互式创建新文章"
	@echo "  make new-math         创建数学文章模板 (SUB=分析学/实分析/泛函分析/拓扑学)"
	@echo "  make new-code         创建编程文章模板 (LANG=python/rust/pytorch)"
	@echo "  make new-sci          创建科学计算文章模板"
	@echo "  make new-tool         创建工具类文章模板"
	@echo "  make list             列出所有文章"
	@echo "  make edit             编辑最新文章"
	@echo "  make delete           删除指定文章"
	@echo "  make rename           重命名文章"
	@echo "  make add-tag          给文章添加标签"
	@echo "  make update-time      更新文章修改时间"
	@echo "  make search           搜索文章内容"
	@echo ""
	@echo "🏗️  构建部署:"
	@echo "  make dev / d          开发模式(含草稿)"
	@echo "  make server / s       启动本地服务器"
	@echo "  make build / b        构建静态网站"
	@echo "  make deploy / dp      部署到 main 分支"
	@echo "  make push / p         提交源码到 master"
	@echo "  make sync             一键同步(提交+部署)"
	@echo ""
	@echo "🔧 维护工具:"
	@echo "  make check            检查项目状态"
	@echo "  make count            统计文章字数"
	@echo "  make backup           备份博客内容"
	@echo "  make clean / c        清理缓存"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ============================================
# 🚀 快速开始（新手引导）
# ============================================

quick-start: ## 🚀 首次使用完整引导
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🎉 欢迎使用 Hexo 博客管理系统！"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "📖 新手完整工作流程:"
	@echo ""
	@echo "1️⃣  创建新文章:"
	@echo "    make new                    # 交互式"
	@echo "    make new-math TITLE=\"标题\"  # 数学模板"
	@echo "    make new-code TITLE=\"标题\"  # 编程模板"
	@echo ""
	@echo "2️⃣  本地预览:"
	@echo "    make dev"
	@echo "    访问: http://localhost:4000"
	@echo ""
	@echo "3️⃣  管理文章:"
	@echo "    make list         # 查看文章列表"
	@echo "    make edit         # 编辑最新文章"
	@echo "    make delete       # 删除文章"
	@echo "    make add-tag      # 添加标签"
	@echo "    make update-time  # 更新修改时间"
	@echo ""
	@echo "4️⃣  发布:"
	@echo "    make sync         # 一键同步(提交源码+部署网站)"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ============================================
## 项目管理
# ============================================

install: ## 安装项目依赖
	@echo "📦 安装项目依赖..."
	@npm install
	@echo "✓ 依赖安装完成"

upgrade: ## 升级依赖包
	@echo "⬆️  升级依赖包..."
	@npm update
	@npm outdated
	@echo "✓ 依赖升级完成"

check: ## 检查项目状态
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🔍 项目状态检查"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "📊 文章统计:"
	@echo "  正式文章: $$(find $(POST_DIR) -name '*.md' | wc -l) 篇"
	@echo "  草稿:     $$(find $(DRAFT_DIR) -name '*.md' 2>/dev/null | wc -l) 篇"
	@echo ""
	@echo "📁 Git 状态:"
	@git status --short
	@echo ""
	@echo "🌿 当前分支: $$(git branch --show-current)"
	@echo ""

status: ## 查看Git状态
	@git status

# ============================================
## 构建部署
# ============================================

clean: ## 清理生成文件
	@echo "🧹 清理缓存和生成文件..."
	@npx hexo clean
	@rm -rf $(PUBLIC_DIR) $(DEPLOY_DIR)
	@echo "✓ 清理完成"

build: clean ## 构建静态网站
	@echo "🏗️  构建静态网站..."
	@npx hexo generate
	@echo "✓ 构建完成"

server: ## 启动本地服务器
	@echo "🌐 启动本地服务器..."
	@echo "访问: http://localhost:4000"
	@npx hexo server

dev: ## 开发模式(含草稿)
	@echo "🔧 启动开发服务器(包含草稿)..."
	@echo "访问: http://localhost:4000"
	@npx hexo server --draft

deploy: build ## 部署到GitHub Pages (main分支)
	@echo "🚀 部署到 GitHub Pages ($(GIT_BRANCH_DEPLOY) 分支)..."
	@npx hexo deploy
	@echo "✓ 部署完成"
	@echo "🌐 网站: https://smlyfm.github.io"

# ============================================
## 📝 文章管理 - 创建
# ============================================

new: ## 交互式创建新文章
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    ✍️  创建新文章"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@read -p "📝 文章标题: " TITLE; \
	if [ -z "$$TITLE" ]; then \
		echo "❌ 错误: 标题不能为空"; \
		exit 1; \
	fi; \
	read -p "📂 分类 (默认: blog): " CAT; \
	CAT=$${CAT:-blog}; \
	read -p "🏷️  标签 (空格分隔): " TAGS; \
	read -p "📄 描述 (可选): " DESC; \
	echo ""; \
	FILENAME="$(POST_DIR)/$$TITLE.md"; \
	echo "---" > "$$FILENAME"; \
	echo "title: $$TITLE" >> "$$FILENAME"; \
	echo "date: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "updated: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "categories:" >> "$$FILENAME"; \
	echo "  - $$CAT" >> "$$FILENAME"; \
	echo "tags:" >> "$$FILENAME"; \
	if [ -n "$$TAGS" ]; then \
		for tag in $$TAGS; do \
			echo "  - $$tag" >> "$$FILENAME"; \
		done; \
	fi; \
	if [ -n "$$DESC" ]; then \
		echo "description: $$DESC" >> "$$FILENAME"; \
	fi; \
	echo "---" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 简介" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "<!-- more -->" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 正文" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 总结" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 参考资料" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "✅ 文章已创建: $$FILENAME"; \
	echo ""; \
	read -p "📝 是否立即编辑? [Y/n] " -n 1 -r EDIT; \
	echo ""; \
	if [[ ! $$EDIT =~ ^[Nn]$$ ]]; then \
		$(EDITOR) "$$FILENAME"; \
	fi

new-math: ## 创建数学文章 (make new-math TITLE="标题" SUB="分析学")
	@if [ -z "$(TITLE)" ]; then \
		echo "❌ 用法: make new-math TITLE=\"文章标题\" SUB=\"分析学\""; \
		echo ""; \
		echo "可用子分类: 分析学, 实分析, 泛函分析, 拓扑学"; \
		exit 1; \
	fi
	@SUB="$${SUB:-分析学}"; \
	FILENAME="$(POST_DIR)/$(TITLE).md"; \
	echo "---" > "$$FILENAME"; \
	echo "title: $(TITLE)" >> "$$FILENAME"; \
	echo "date: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "updated: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "categories:" >> "$$FILENAME"; \
	echo "  - 数学" >> "$$FILENAME"; \
	echo "  - $$SUB" >> "$$FILENAME"; \
	echo "tags:" >> "$$FILENAME"; \
	echo "  - 数学基础" >> "$$FILENAME"; \
	echo "mathjax: true" >> "$$FILENAME"; \
	echo "---" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 引言" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "<!-- more -->" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 定义与记号" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 主要定理" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "**定理 1.** " >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "**证明.**" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "$$\\square$$" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 应用" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 参考文献" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "✅ 数学文章已创建: $$FILENAME"; \
	echo "   分类: 数学 > $$SUB"

new-code: ## 创建编程文章 (make new-code TITLE="标题" LANG="python")
	@if [ -z "$(TITLE)" ]; then \
		echo "❌ 用法: make new-code TITLE=\"文章标题\" LANG=\"python\""; \
		echo ""; \
		echo "LANG 选项: python, rust, pytorch"; \
		exit 1; \
	fi
	@LANG="$${LANG:-python}"; \
	FILENAME="$(POST_DIR)/$(TITLE).md"; \
	echo "---" > "$$FILENAME"; \
	echo "title: $(TITLE)" >> "$$FILENAME"; \
	echo "date: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "updated: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "categories:" >> "$$FILENAME"; \
	echo "  - 编程语言" >> "$$FILENAME"; \
	echo "  - $$LANG" >> "$$FILENAME"; \
	echo "tags:" >> "$$FILENAME"; \
	echo "  - $$LANG" >> "$$FILENAME"; \
	echo "highlight_shrink: false" >> "$$FILENAME"; \
	echo "---" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 简介" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "<!-- more -->" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 环境准备" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "\`\`\`bash" >> "$$FILENAME"; \
	echo "# 安装依赖" >> "$$FILENAME"; \
	echo "\`\`\`" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 代码实现" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "\`\`\`$$LANG" >> "$$FILENAME"; \
	echo "# 代码示例" >> "$$FILENAME"; \
	echo "\`\`\`" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 运行结果" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 总结" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 参考链接" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "✅ 编程文章已创建: $$FILENAME"; \
	echo "   分类: 编程语言 > $$LANG"

new-sci: ## 创建科学计算文章 (make new-sci TITLE="标题")
	@if [ -z "$(TITLE)" ]; then \
		echo "❌ 用法: make new-sci TITLE=\"文章标题\""; \
		exit 1; \
	fi
	@FILENAME="$(POST_DIR)/$(TITLE).md"; \
	echo "---" > "$$FILENAME"; \
	echo "title: $(TITLE)" >> "$$FILENAME"; \
	echo "date: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "updated: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "categories:" >> "$$FILENAME"; \
	echo "  - 科学计算" >> "$$FILENAME"; \
	echo "  - 偏微分方程" >> "$$FILENAME"; \
	echo "tags:" >> "$$FILENAME"; \
	echo "  - PDE" >> "$$FILENAME"; \
	echo "  - 数值方法" >> "$$FILENAME"; \
	echo "mathjax: true" >> "$$FILENAME"; \
	echo "---" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 问题描述" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "<!-- more -->" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 数学模型" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 数值方法" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 代码实现" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "\`\`\`python" >> "$$FILENAME"; \
	echo "# 数值求解代码" >> "$$FILENAME"; \
	echo "\`\`\`" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 结果分析" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 参考文献" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "✅ 科学计算文章已创建: $$FILENAME"; \
	echo "   分类: 科学计算 > 偏微分方程"

new-tool: ## 创建工具类文章 (make new-tool TITLE="标题")
	@if [ -z "$(TITLE)" ]; then \
		echo "❌ 用法: make new-tool TITLE=\"文章标题\""; \
		exit 1; \
	fi
	@FILENAME="$(POST_DIR)/$(TITLE).md"; \
	echo "---" > "$$FILENAME"; \
	echo "title: $(TITLE)" >> "$$FILENAME"; \
	echo "date: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "updated: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "categories:" >> "$$FILENAME"; \
	echo "  - 工具与写作" >> "$$FILENAME"; \
	echo "  - LaTeX" >> "$$FILENAME"; \
	echo "tags:" >> "$$FILENAME"; \
	echo "  - 工具" >> "$$FILENAME"; \
	echo "  - 效率" >> "$$FILENAME"; \
	echo "---" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 简介" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "<!-- more -->" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 安装与配置" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 基本使用" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 进阶技巧" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 常见问题" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 参考资料" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "✅ 工具类文章已创建: $$FILENAME"; \
	echo "   分类: 工具与写作 > LaTeX"

draft: ## 创建草稿 (make draft TITLE="草稿标题")
	@if [ -z "$(TITLE)" ]; then \
		echo "❌ 用法: make draft TITLE=\"草稿标题\""; \
		exit 1; \
	fi
	@mkdir -p $(DRAFT_DIR)
	@npx hexo new draft "$(TITLE)"
	@echo "✓ 草稿已创建"

publish: ## 发布草稿 (make publish DRAFT="草稿名")
	@if [ -z "$(DRAFT)" ]; then \
		echo "📋 现有草稿:"; \
		find $(DRAFT_DIR) -name '*.md' -type f -exec basename {} .md \; 2>/dev/null | sort || echo "  (无草稿)"; \
		echo ""; \
		echo "用法: make publish DRAFT=\"草稿名\""; \
		exit 1; \
	fi
	@npx hexo publish draft "$(DRAFT)"
	@echo "✓ 草稿已发布"

# ============================================
## 📝 文章管理 - 查看
# ============================================

list: ## 列出所有文章
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📄 文章列表 ($$(find $(POST_DIR) -name '*.md' | wc -l) 篇)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "序号  日期        分类        标题"
	@echo "────  ──────────  ──────────  ────────────────────────────────"
	@NUM=1; \
	for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null); do \
		TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
		FDATE=$$(grep "^date:" "$$file" | head -1 | cut -d' ' -f2); \
		CAT=$$(grep -A1 "^categories:" "$$file" | tail -1 | sed 's/.*- //' | xargs); \
		printf "[%2d]  %s  %-10s  %s\n" "$$NUM" "$$FDATE" "$$CAT" "$$TITLE"; \
		NUM=$$((NUM + 1)); \
	done
	@echo ""

list-detail: ## 详细列出文章（含标签）
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📄 文章详情"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null); do \
		echo ""; \
		TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
		FDATE=$$(grep "^date:" "$$file" | head -1 | cut -d' ' -f2); \
		UDATE=$$(grep "^updated:" "$$file" | head -1 | cut -d' ' -f2); \
		CAT=$$(grep -A1 "^categories:" "$$file" | tail -1 | sed 's/.*- //' | xargs); \
		TAGS=$$(awk '/^tags:/,/^[a-z]/' "$$file" | grep "  - " | sed 's/  - //' | tr '\n' ' '); \
		echo "📝 $$TITLE"; \
		echo "   📅 创建: $$FDATE  |  🔄 更新: $$UDATE"; \
		echo "   📂 分类: $$CAT"; \
		echo "   🏷️  标签: $$TAGS"; \
		echo "   📁 文件: $$(basename $$file)"; \
	done
	@echo ""

# ============================================
## 📝 文章管理 - 编辑
# ============================================

edit: ## 编辑最新文章
	@LATEST=$$(ls -t $(POST_DIR)/*.md 2>/dev/null | head -1); \
	if [ -n "$$LATEST" ]; then \
		echo "📝 打开最新文章: $$LATEST"; \
		$(EDITOR) "$$LATEST"; \
	else \
		echo "❌ 未找到文章"; \
	fi

edit-file: ## 编辑指定文章 (make edit-file FILE="文件名")
	@if [ -z "$(FILE)" ]; then \
		echo "❌ 用法: make edit-file FILE=\"文件名.md\""; \
		echo ""; \
		echo "可用文章:"; \
		ls $(POST_DIR)/*.md 2>/dev/null | xargs -n1 basename | head -10; \
		exit 1; \
	fi
	@if [ -f "$(POST_DIR)/$(FILE)" ]; then \
		$(EDITOR) "$(POST_DIR)/$(FILE)"; \
	else \
		echo "❌ 文件不存在: $(POST_DIR)/$(FILE)"; \
	fi

# ============================================
## 📝 文章管理 - 修改
# ============================================

update-time: ## 更新文章的修改时间
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    ⏰ 更新文章修改时间"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@if [ -n "$(FILE)" ]; then \
		if [ -f "$(FILE)" ]; then \
			sed -i "s/^updated:.*/updated: $(TIMESTAMP)/" "$(FILE)"; \
			echo "✅ 已更新: $(FILE)"; \
			echo "   updated: $(TIMESTAMP)"; \
		else \
			echo "❌ 文件不存在: $(FILE)"; \
		fi; \
	else \
		echo "选择要更新的文章:"; \
		echo ""; \
		NUM=1; \
		for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null | head -10); do \
			TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
			printf "[%d] %s\n" "$$NUM" "$$TITLE"; \
			NUM=$$((NUM + 1)); \
		done; \
		echo ""; \
		read -p "输入序号 (1-$$((NUM-1))): " SEL; \
		FILE=$$(ls -t $(POST_DIR)/*.md 2>/dev/null | sed -n "$${SEL}p"); \
		if [ -n "$$FILE" ]; then \
			sed -i "s/^updated:.*/updated: $(TIMESTAMP)/" "$$FILE"; \
			TITLE=$$(grep "^title:" "$$FILE" | head -1 | cut -d':' -f2- | xargs); \
			echo ""; \
			echo "✅ 已更新: $$TITLE"; \
			echo "   updated: $(TIMESTAMP)"; \
		else \
			echo "❌ 无效选择"; \
		fi; \
	fi

add-tag: ## 给文章添加标签
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🏷️  添加标签"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "选择文章:"; \
	NUM=1; \
	for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null | head -10); do \
		TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
		printf "[%d] %s\n" "$$NUM" "$$TITLE"; \
		NUM=$$((NUM + 1)); \
	done; \
	echo ""; \
	read -p "输入序号: " SEL; \
	FILE=$$(ls -t $(POST_DIR)/*.md 2>/dev/null | sed -n "$${SEL}p"); \
	if [ -n "$$FILE" ]; then \
		echo ""; \
		echo "当前标签:"; \
		awk '/^tags:/,/^[a-z]/' "$$FILE" | grep "  - " | sed 's/  - /  • /'; \
		echo ""; \
		read -p "输入新标签 (空格分隔): " NEWTAGS; \
		if [ -n "$$NEWTAGS" ]; then \
			for tag in $$NEWTAGS; do \
				sed -i "/^tags:/a\\  - $$tag" "$$FILE"; \
			done; \
			sed -i "s/^updated:.*/updated: $(TIMESTAMP)/" "$$FILE"; \
			echo "✅ 标签已添加"; \
		fi; \
	else \
		echo "❌ 无效选择"; \
	fi

set-category: ## 修改文章分类 (make set-category FILE="xxx.md" CAT="新分类")
	@if [ -z "$(FILE)" ] || [ -z "$(CAT)" ]; then \
		echo "❌ 用法: make set-category FILE=\"文件名.md\" CAT=\"新分类\""; \
		exit 1; \
	fi
	@if [ -f "$(POST_DIR)/$(FILE)" ]; then \
		awk -v cat="$(CAT)" ' \
			/^categories:/ { print; getline; print "  - " cat; next } \
			{ print } \
		' "$(POST_DIR)/$(FILE)" > /tmp/post_tmp.md && mv /tmp/post_tmp.md "$(POST_DIR)/$(FILE)"; \
		sed -i "s/^updated:.*/updated: $(TIMESTAMP)/" "$(POST_DIR)/$(FILE)"; \
		echo "✅ 分类已修改为: $(CAT)"; \
	else \
		echo "❌ 文件不存在: $(POST_DIR)/$(FILE)"; \
	fi

# ============================================
## 📝 文章管理 - 删除/重命名
# ============================================

delete: ## 删除文章
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🗑️  删除文章"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "选择要删除的文章:"; \
	NUM=1; \
	for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null); do \
		TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
		printf "[%d] %s\n" "$$NUM" "$$TITLE"; \
		NUM=$$((NUM + 1)); \
	done; \
	echo ""; \
	read -p "输入序号 (0 取消): " SEL; \
	if [ "$$SEL" = "0" ]; then \
		echo "已取消"; \
		exit 0; \
	fi; \
	FILE=$$(ls -t $(POST_DIR)/*.md 2>/dev/null | sed -n "$${SEL}p"); \
	if [ -n "$$FILE" ]; then \
		TITLE=$$(grep "^title:" "$$FILE" | head -1 | cut -d':' -f2- | xargs); \
		echo ""; \
		echo "⚠️  将删除: $$TITLE"; \
		echo "   文件: $$FILE"; \
		read -p "确认删除? [y/N] " -n 1 -r CONFIRM; \
		echo ""; \
		if [[ $$CONFIRM =~ ^[Yy]$$ ]]; then \
			rm "$$FILE"; \
			echo "✅ 文章已删除"; \
		else \
			echo "已取消"; \
		fi; \
	else \
		echo "❌ 无效选择"; \
	fi

rename: ## 重命名文章
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    ✏️  重命名文章"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "选择要重命名的文章:"; \
	NUM=1; \
	for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null | head -10); do \
		TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
		printf "[%d] %s\n" "$$NUM" "$$TITLE"; \
		NUM=$$((NUM + 1)); \
	done; \
	echo ""; \
	read -p "输入序号: " SEL; \
	FILE=$$(ls -t $(POST_DIR)/*.md 2>/dev/null | sed -n "$${SEL}p"); \
	if [ -n "$$FILE" ]; then \
		OLD_TITLE=$$(grep "^title:" "$$FILE" | head -1 | cut -d':' -f2- | xargs); \
		echo "当前标题: $$OLD_TITLE"; \
		read -p "新标题: " NEW_TITLE; \
		if [ -n "$$NEW_TITLE" ]; then \
			sed -i "s/^title:.*/title: $$NEW_TITLE/" "$$FILE"; \
			sed -i "s/^updated:.*/updated: $(TIMESTAMP)/" "$$FILE"; \
			NEW_FILE="$(POST_DIR)/$$NEW_TITLE.md"; \
			mv "$$FILE" "$$NEW_FILE"; \
			echo "✅ 已重命名为: $$NEW_TITLE"; \
		fi; \
	else \
		echo "❌ 无效选择"; \
	fi

# ============================================
## 📝 文章管理 - 搜索
# ============================================

search: ## 搜索文章 (make search KEYWORD="关键词")
	@if [ -z "$(KEYWORD)" ]; then \
		read -p "🔍 搜索关键词: " KEYWORD; \
	fi; \
	if [ -n "$$KEYWORD" ] || [ -n "$(KEYWORD)" ]; then \
		KW=$${KEYWORD:-$(KEYWORD)}; \
		echo ""; \
		echo "搜索结果: $$KW"; \
		echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
		grep -rln "$$KW" $(POST_DIR)/*.md 2>/dev/null | while read file; do \
			TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
			echo "📝 $$TITLE"; \
			echo "   $$(basename $$file)"; \
		done || echo "未找到匹配结果"; \
	else \
		echo "❌ 请输入搜索关键词"; \
	fi

# ============================================
## 维护工具
# ============================================

push: ## 提交并推送源码到 master 分支
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📤 提交源码到 $(GIT_BRANCH_SOURCE) 分支"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "变更文件:"; \
		git status --short; \
		echo ""; \
		read -p "📝 提交信息 (回车使用默认): " MSG; \
		if [ -z "$$MSG" ]; then \
			MSG="Update: $(TIMESTAMP)"; \
		fi; \
		git add .; \
		git commit -m "$$MSG"; \
		git push $(GIT_REMOTE) $(GIT_BRANCH_SOURCE); \
		echo ""; \
		echo "✅ 源码已推送到 $(GIT_BRANCH_SOURCE) 分支"; \
	else \
		echo "⚠️  工作区干净,无需提交"; \
	fi

pull: ## 从远程拉取更新
	@echo "📥 拉取远程更新..."
	@git pull $(GIT_REMOTE) $(GIT_BRANCH_SOURCE)
	@echo "✓ 拉取完成"

sync: ## 🚀 一键同步: 提交源码(master) + 部署网站(main)
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🚀 一键同步: 提交源码 + 部署网站"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@# Step 1: 提交源码
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "📤 Step 1/2: 提交源码到 $(GIT_BRANCH_SOURCE)..."; \
		git status --short; \
		echo ""; \
		read -p "📝 提交信息 (回车使用默认): " MSG; \
		if [ -z "$$MSG" ]; then \
			MSG="Update: $(TIMESTAMP)"; \
		fi; \
		git add .; \
		git commit -m "$$MSG"; \
		git push $(GIT_REMOTE) $(GIT_BRANCH_SOURCE); \
		echo "✅ 源码已推送"; \
		echo ""; \
	else \
		echo "📤 Step 1/2: 源码无变更，跳过..."; \
		echo ""; \
	fi
	@# Step 2: 部署网站
	@echo "🚀 Step 2/2: 部署网站到 $(GIT_BRANCH_DEPLOY)..."
	@npx hexo clean
	@npx hexo generate
	@npx hexo deploy
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    ✅ 同步完成!"
	@echo ""
	@echo "    📁 源码分支: $(GIT_BRANCH_SOURCE)"
	@echo "    🌐 部署分支: $(GIT_BRANCH_DEPLOY)"
	@echo "    🔗 网站地址: https://smlyfm.github.io"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

backup: ## 备份博客内容
	@echo "💾 备份博客内容..."
	@BACKUP_FILE="$(BACKUP_DIR)/blog-backup-$(DATE).tar.gz"; \
	mkdir -p $(BACKUP_DIR); \
	tar -czf "$$BACKUP_FILE" \
		--exclude='node_modules' \
		--exclude='public' \
		--exclude='.deploy_git' \
		--exclude='.git' \
		$(SOURCE_DIR) _config*.yml package.json themes; \
	echo "✓ 备份完成: $$BACKUP_FILE"; \
	ls -lh "$$BACKUP_FILE"

count: ## 统计文章字数
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📊 文章统计"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@TOTAL_WORDS=0; \
	TOTAL_POSTS=0; \
	for file in $(POST_DIR)/*.md; do \
		if [ -f "$$file" ]; then \
			WORDS=$$(wc -w < "$$file"); \
			TOTAL_WORDS=$$((TOTAL_WORDS + WORDS)); \
			TOTAL_POSTS=$$((TOTAL_POSTS + 1)); \
			TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
			printf "%-40s %6d 字\n" "$$TITLE" "$$WORDS"; \
		fi; \
	done; \
	echo ""; \
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; \
	echo "总计: $$TOTAL_POSTS 篇文章, $$TOTAL_WORDS 字"

# ============================================
# 快捷命令别名
# ============================================

s: server
d: dev
b: build
dp: deploy
n: new
p: push
l: list
c: clean

# ============================================
# 版本信息
# ============================================

version: ## 显示版本信息
	@echo "环境: Node $(NODE_VERSION), npm $(NPM_VERSION), Hexo $(HEXO_VERSION)"
	@echo "分支: $$(git branch --show-current)"
	@echo "提交: $$(git rev-parse --short HEAD)"
