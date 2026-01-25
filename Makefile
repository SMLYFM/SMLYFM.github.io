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
HEXO_VERSION := $(shell npx hexo version 2>/dev/null | grep "^hexo:" | head -1 | awk '{print $$2}')
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
	@echo ""
	@echo "╔══════════════════════════════════════════════════════════════════════════════╗"
	@echo "║                                                                              ║"
	@echo "║     🦋  $(PROJECT_NAME) - Hexo Butterfly 博客管理系统                      ║"
	@echo "║                                                                              ║"
	@echo "╚══════════════════════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "  📊 项目信息: Node $(NODE_VERSION) | Hexo $(HEXO_VERSION)"
	@echo "  🌐 博客地址: https://smlyfm.github.io"
	@echo "  📁 源码分支: master  |  📤 部署分支: main"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  🚀 快速开始"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  make quick-start      首次使用完整引导"
	@echo "  make dev              启动本地开发服务器 → http://localhost:4000"
	@echo "  make sync             一键同步 (提交源码 + 部署网站)"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  📝 文章管理"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  创建文章:"
	@echo "    make new                    交互式创建 (推荐新手)"
	@echo "    make new-math TITLE=\"...\"   数学文章 (数学 > 分析学/实分析/泛函分析/拓扑学)"
	@echo "    make new-code TITLE=\"...\"   编程文章 (编程语言 > python/rust/pytorch)"
	@echo "    make new-sci  TITLE=\"...\"   科学计算 (科学计算 > 偏微分方程)"
	@echo "    make new-tool TITLE=\"...\"   工具类   (工具与写作 > LaTeX)"
	@echo ""
	@echo "  管理文章:"
	@echo "    make list                   列出所有文章 (按时间排序)"
	@echo "    make list-detail            详细列出 (含标签、更新时间)"
	@echo "    make edit                   编辑最新文章"
	@echo "    make search KEYWORD=\"...\"   搜索文章内容"
	@echo ""
	@echo "  修改文章:"
	@echo "    make update-time            更新文章修改时间"
	@echo "    make add-tag                给文章添加标签"
	@echo "    make rename                 重命名文章"
	@echo "    make delete                 删除文章 (有确认)"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  🏗️  构建部署"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "    make dev      / d           开发服务器 (含草稿预览)"
	@echo "    make server   / s           生产服务器"
	@echo "    make build    / b           构建静态网站"
	@echo "    make clean    / c           清理缓存和生成文件"
	@echo ""
	@echo "    make push     / p           提交源码到 master 分支"
	@echo "    make deploy   / dp          部署网站到 main 分支"
	@echo "    make sync                   一键同步 (push + deploy)"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  🔧 维护工具"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "    make check                  检查项目状态 (Git + 文章统计)"
	@echo "    make count                  统计文章字数"
	@echo "    make backup                 备份博客内容"
	@echo "    make install                安装依赖"
	@echo "    make upgrade                升级依赖"
	@echo "    make version                显示版本信息"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  📂 分类结构 (5 大类)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "    📐 数学           → 分析学, 实分析, 泛函分析, 拓扑学"
	@echo "    💻 计算机         → 机器学习, 深度学习, 物理信息神经网络"
	@echo "    🦀 编程语言       → Python, Rust, PyTorch"
	@echo "    🔬 科学计算       → 偏微分方程"
	@echo "    📝 工具与写作     → LaTeX"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  🐳 容器化部署"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "  Docker:"
	@echo "    make docker-build             构建 Docker 镜像"
	@echo "    make docker-run               运行 Docker 容器 (端口 80)"
	@echo "    make docker-dev               开发容器 (热重载, 端口 4000)"
	@echo "    make docker-shell             进入容器 shell"
	@echo "    make docker-status            查看容器状态"
	@echo "    make docker-clean             清理悬空镜像"
	@echo "    make docker-compose-up        Docker Compose 启动"
	@echo ""
	@echo "  Podman (Fedora 推荐):"
	@echo "    make podman-build             构建 Podman 镜像"
	@echo "    make podman-run               运行 Podman 容器 (端口 8080)"
	@echo "    make podman-dev               开发容器 (热重载)"
	@echo "    make podman-shell             进入容器 shell"
	@echo "    make podman-status            查看容器状态"
	@echo "    make podman-clean             清理悬空镜像"
	@echo "    make podman-quadlet           安装 Quadlet 配置"
	@echo ""
	@echo "  通用:"
	@echo "    make container-helper         使用统一容器脚本"
	@echo ""
	@echo "  服务器:"
	@echo "    make deploy-server            部署到自有服务器 (需配置)"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  🔧 诊断与工具"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "    make doctor                   环境诊断 (检查必要工具)"
	@echo "    make info                     显示项目详细信息"
	@echo "    make deps-check               检查依赖更新"
	@echo "    make validate                 验证配置文件"
	@echo "    make analyze                  分析构建产物大小"
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  📖 文档链接"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "    docs/CONFIG_GUIDE.md          配置修改指南 (公告、背景、导航等)"
	@echo "    docs/MAKEFILE.md              Makefile 详细说明"
	@echo "    docs/DEVELOPMENT.md           本地开发指南"
	@echo "    docs/DEPLOYMENT.md            GitHub Pages 部署指南"
	@echo "    docs/SERVER_DEPLOYMENT.md     服务器/Docker/Podman 部署指南"
	@echo ""

	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "  💡 示例"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "    # 创建拓扑学文章"
	@echo "    make new-math TITLE=\"点集拓扑入门\" SUB=\"拓扑学\""
	@echo ""
	@echo "    # 创建 Rust 编程文章"
	@echo "    make new-code TITLE=\"Rust异步编程\" LANG=\"rust\""
	@echo ""
	@echo "    # 本地预览后一键部署"
	@echo "    make dev              # 本地预览"
	@echo "    make sync             # 提交并部署"
	@echo ""
	@echo "══════════════════════════════════════════════════════════════════════════════"
	@echo ""

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

list: ## 列出所有文章（含 hash 状态）
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📄 文章列表 ($$(find $(POST_DIR) -name '*.md' | wc -l) 篇)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "序号  状态  更新日期    分类        标题"
	@echo "────  ────  ──────────  ──────────  ────────────────────────────────"
	@NUM=1; \
	for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null); do \
		TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
		UDATE=$$(grep "^updated:" "$$file" | head -1 | cut -d' ' -f2 || grep "^date:" "$$file" | head -1 | cut -d' ' -f2); \
		CAT=$$(grep -A1 "^categories:" "$$file" | tail -1 | sed 's/.*- //' | xargs); \
		BASENAME=$$(basename "$$file"); \
		if [ -f ".article-hashes" ]; then \
			CURRENT_HASH=$$(sed '/^updated:/d' "$$file" | md5sum | cut -d' ' -f1); \
			STORED_HASH=$$(grep "^$$BASENAME:" ".article-hashes" 2>/dev/null | cut -d: -f2 || echo ""); \
			if [ -z "$$STORED_HASH" ]; then \
				STATUS="\033[0;36m NEW\033[0m"; \
			elif [ "$$CURRENT_HASH" != "$$STORED_HASH" ]; then \
				STATUS="\033[1;33m MOD\033[0m"; \
			else \
				STATUS="\033[0;32m  ✓ \033[0m"; \
			fi; \
		else \
			STATUS="  - "; \
		fi; \
		printf "[%2d]  $$STATUS  %s  %-10s  %s\n" "$$NUM" "$$UDATE" "$$CAT" "$$TITLE"; \
		NUM=$$((NUM + 1)); \
	done
	@echo ""
	@echo "💡 状态: ✓=未修改  MOD=已修改  NEW=新文章  -=未初始化"
	@if [ ! -f ".article-hashes" ]; then \
		echo "💡 运行 'make article-init' 初始化 hash 记录"; \
	fi
	@echo ""

list-detail: ## 详细列出文章（含 hash 和标签）
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📄 文章详情（含 Hash 信息）"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@for file in $$(ls -t $(POST_DIR)/*.md 2>/dev/null); do \
		echo ""; \
		TITLE=$$(grep "^title:" "$$file" | head -1 | cut -d':' -f2- | xargs); \
		FDATE=$$(grep "^date:" "$$file" | head -1 | cut -d' ' -f2); \
		UDATE=$$(grep "^updated:" "$$file" | head -1 | sed 's/updated:[[:space:]]*//' || echo "未设置"); \
		CAT=$$(grep -A1 "^categories:" "$$file" | tail -1 | sed 's/.*- //' | xargs); \
		TAGS=$$(awk '/^tags:/,/^[a-z]/' "$$file" | grep "  - " | sed 's/  - //' | tr '\n' ' '); \
		BASENAME=$$(basename "$$file"); \
		CURRENT_HASH=$$(sed '/^updated:/d' "$$file" | md5sum | cut -d' ' -f1); \
		if [ -f ".article-hashes" ]; then \
			STORED_HASH=$$(grep "^$$BASENAME:" ".article-hashes" 2>/dev/null | cut -d: -f2 || echo "无记录"); \
			if [ "$$CURRENT_HASH" = "$$STORED_HASH" ]; then \
				HASH_STATUS="\033[0;32m未修改\033[0m"; \
			elif [ "$$STORED_HASH" = "无记录" ]; then \
				HASH_STATUS="\033[0;36m新文章\033[0m"; \
			else \
				HASH_STATUS="\033[1;33m已修改\033[0m"; \
			fi; \
		else \
			STORED_HASH="未初始化"; \
			HASH_STATUS="未初始化"; \
		fi; \
		echo "📝 $$TITLE"; \
		echo "   📅 创建: $$FDATE  |  🔄 更新: $$UDATE"; \
		echo "   📂 分类: $$CAT"; \
		echo "   🏷️  标签: $$TAGS"; \
		echo "   📁 文件: $$BASENAME"; \
		echo -e "   🔐 Hash: $${CURRENT_HASH:0:12}... [$$HASH_STATUS]"; \
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
## 📝 文章管理 - Hash 追踪
# ============================================

.PHONY: article-init article-check article-update article-show

article-init: ## 📋 初始化文章 hash 记录
	@./tools/article-hash.sh init

article-check: ## 📋 检查哪些文章被修改
	@./tools/article-hash.sh check

article-update: ## 📋 更新所有已修改文章的时间戳
	@./tools/article-hash.sh update

article-update-file: ## 📋 更新指定文章 (make article-update-file FILE="文件名.md")
	@if [ -z "$(FILE)" ]; then \
		echo "❌ 用法: make article-update-file FILE=\"文件名.md\""; \
		exit 1; \
	fi
	@./tools/article-hash.sh update-file $(FILE)

article-show: ## 📋 显示指定文章的 hash 信息 (make article-show FILE="文件名.md")
	@if [ -z "$(FILE)" ]; then \
		echo "❌ 用法: make article-show FILE=\"文件名.md\""; \
		exit 1; \
	fi
	@./tools/article-hash.sh show $(FILE)

# ============================================
## 📝 文章管理 - ID 系统
# ============================================

.PHONY: article-id-init article-id-list article-info article-id-sync

article-id-init: ## 📋 初始化文章 ID 系统
	@./tools/article-id.sh init

article-id-list: ## 📋 列出所有文章 ID
	@./tools/article-id.sh list

article-info: ## 📋 查看文章详情 (make article-info ID=1 或 FILE="xxx.md")
	@if [ -n "$(ID)" ]; then \
		./tools/article-id.sh info $(ID); \
	elif [ -n "$(FILE)" ]; then \
		./tools/article-id.sh info $(FILE); \
	else \
		echo "❌ 用法: make article-info ID=1 或 FILE=\"文件名.md\""; \
		echo ""; \
		echo "示例:"; \
		echo "  make article-info ID=1"; \
		echo "  make article-info FILE=\"zfc-set-theory.md\""; \
		exit 1; \
	fi

article-id-sync: ## 📋 同步文章 ID（分配新文章，释放已删除）
	@./tools/article-id.sh sync

article-id-clean: ## 📋 清理无效的 ID 记录
	@./tools/article-id.sh clean

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

# ============================================
# 🐳 Docker/Podman 容器化部署
# ============================================

# Docker 镜像配置
DOCKER_IMAGE := smlyfm-blog
DOCKER_TAG := latest
CONTAINER_NAME := smlyfm-blog

.PHONY: docker-build docker-run docker-stop docker-logs docker-compose-up docker-compose-down
.PHONY: podman-build podman-run podman-stop podman-logs podman-systemd

docker-build: ## 🐳 构建 Docker 镜像
	@echo "🐳 构建 Docker 镜像: $(DOCKER_IMAGE):$(DOCKER_TAG)"
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "✅ 镜像构建完成"

docker-run: docker-build ## 🐳 运行 Docker 容器
	@echo "🐳 启动 Docker 容器..."
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	docker run -d --name $(CONTAINER_NAME) -p 80:80 $(DOCKER_IMAGE):$(DOCKER_TAG)
	@echo "✅ 容器已启动: http://localhost"

docker-stop: ## 🐳 停止 Docker 容器
	@echo "🐳 停止 Docker 容器..."
	docker stop $(CONTAINER_NAME) && docker rm $(CONTAINER_NAME)
	@echo "✅ 容器已停止"

docker-logs: ## 🐳 查看 Docker 日志
	docker logs -f $(CONTAINER_NAME)

docker-compose-up: ## 🐳 使用 Docker Compose 启动
	@echo "🐳 使用 Docker Compose 启动..."
	docker compose up -d --build
	@echo "✅ 服务已启动: http://localhost"

docker-compose-down: ## 🐳 使用 Docker Compose 停止
	docker compose down
	@echo "✅ 服务已停止"

# ============================================
# 🦭 Podman 部署 (Fedora 推荐)
# ============================================

podman-build: ## 🦭 构建 Podman 镜像
	@echo "🦭 构建 Podman 镜像: $(DOCKER_IMAGE):$(DOCKER_TAG)"
	podman build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .
	@echo "✅ 镜像构建完成"

podman-run: podman-build ## 🦭 运行 Podman 容器 (端口 8080)
	@echo "🦭 启动 Podman 容器..."
	@podman stop $(CONTAINER_NAME) 2>/dev/null || true
	@podman rm $(CONTAINER_NAME) 2>/dev/null || true
	podman run -d --name $(CONTAINER_NAME) -p 8080:80 $(DOCKER_IMAGE):$(DOCKER_TAG)
	@echo "✅ 容器已启动: http://localhost:8080"

podman-stop: ## 🦭 停止 Podman 容器
	@echo "🦭 停止 Podman 容器..."
	podman stop $(CONTAINER_NAME) && podman rm $(CONTAINER_NAME)
	@echo "✅ 容器已停止"

podman-logs: ## 🦭 查看 Podman 日志
	podman logs -f $(CONTAINER_NAME)

podman-systemd: ## 🦭 生成 Systemd 服务文件
	@echo "🦭 生成 Systemd 服务文件..."
	podman generate systemd --name $(CONTAINER_NAME) --files --new
	@echo ""
	@echo "📋 将服务文件移动到用户目录:"
	@echo "   mkdir -p ~/.config/systemd/user"
	@echo "   mv container-$(CONTAINER_NAME).service ~/.config/systemd/user/"
	@echo ""
	@echo "📋 启用服务:"
	@echo "   systemctl --user daemon-reload"
	@echo "   systemctl --user enable container-$(CONTAINER_NAME).service"
	@echo "   systemctl --user start container-$(CONTAINER_NAME)"

# ============================================
# 🖥️ 服务器部署
# ============================================

# 服务器配置 (根据实际情况修改)
SERVER_USER ?= your-username
SERVER_HOST ?= your-server-ip
SERVER_PATH ?= /var/www/blog

deploy-server: build ## 🖥️ 部署到自有服务器 (需配置 SERVER_*)
	@echo "🖥️ 部署到服务器: $(SERVER_USER)@$(SERVER_HOST)"
	rsync -avz --delete ./public/ $(SERVER_USER)@$(SERVER_HOST):$(SERVER_PATH)/
	@echo "✅ 部署完成"

# ============================================
# 🐳 Docker 扩展命令
# ============================================

.PHONY: docker-dev docker-shell docker-status docker-clean docker-export

docker-dev: ## 🐳 开发容器 (热重载, 端口 4000)
	@echo "🐳 启动 Docker 开发容器..."
	@docker stop $(CONTAINER_NAME)-dev 2>/dev/null || true
	@docker rm $(CONTAINER_NAME)-dev 2>/dev/null || true
	docker compose -f docker-compose.dev.yml up -d --build
	@echo "✅ 开发容器已启动: http://localhost:4000"
	@echo "💡 修改源文件后页面会自动刷新"

docker-shell: ## 🐳 进入 Docker 容器 shell
	@echo "🐳 进入容器 shell..."
	docker exec -it $(CONTAINER_NAME) sh

docker-status: ## 🐳 查看 Docker 容器状态
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🐳 Docker 容器状态"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@docker ps -a --filter "name=$(CONTAINER_NAME)" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "未找到容器"
	@echo ""
	@echo "镜像:"
	@docker images | grep -E "^$(DOCKER_IMAGE)|REPOSITORY" || echo "未找到镜像"
	@echo ""

docker-clean: ## 🐳 清理 Docker 悬空镜像和容器
	@echo "🐳 清理 Docker 资源..."
	@docker container prune -f
	@docker image prune -f
	@echo "✅ 清理完成"

docker-export: ## 🐳 导出 Docker 镜像
	@echo "🐳 导出镜像: $(DOCKER_IMAGE)-$(DOCKER_TAG).tar"
	docker save -o $(DOCKER_IMAGE)-$(DOCKER_TAG).tar $(DOCKER_IMAGE):$(DOCKER_TAG)
	@echo "✅ 镜像已导出"

# ============================================
# 🦭 Podman 扩展命令
# ============================================

.PHONY: podman-dev podman-shell podman-status podman-clean podman-quadlet

podman-dev: ## 🦭 开发容器 (热重载, 端口 4000)
	@echo "🦭 启动 Podman 开发容器..."
	@podman stop $(CONTAINER_NAME)-dev 2>/dev/null || true
	@podman rm $(CONTAINER_NAME)-dev 2>/dev/null || true
	@if command -v podman-compose &>/dev/null; then \
		podman-compose -f docker-compose.dev.yml up -d --build; \
	else \
		echo "💡 podman-compose 未安装，使用替代方案..."; \
		podman build -f Dockerfile.dev -t $(DOCKER_IMAGE)-dev:$(DOCKER_TAG) .; \
		podman run -d --name $(CONTAINER_NAME)-dev \
			-p 4000:4000 \
			-v ./source:/app/source:ro \
			-v ./_config.yml:/app/_config.yml:ro \
			-v ./_config.butterfly.yml:/app/_config.butterfly.yml:ro \
			$(DOCKER_IMAGE)-dev:$(DOCKER_TAG); \
	fi
	@echo "✅ 开发容器已启动: http://localhost:4000"

podman-shell: ## 🦭 进入 Podman 容器 shell
	@echo "🦭 进入容器 shell..."
	podman exec -it $(CONTAINER_NAME) sh

podman-status: ## 🦭 查看 Podman 容器状态
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🦭 Podman 容器状态"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@podman ps -a --filter "name=$(CONTAINER_NAME)" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "未找到容器"
	@echo ""
	@echo "镜像:"
	@podman images | grep -E "^localhost/$(DOCKER_IMAGE)|REPOSITORY" || echo "未找到镜像"
	@echo ""

podman-clean: ## 🦭 清理 Podman 悬空镜像和容器
	@echo "🦭 清理 Podman 资源..."
	@podman container prune -f
	@podman image prune -f
	@echo "✅ 清理完成"

podman-quadlet: ## 🦭 安装 Quadlet 配置 (Fedora 推荐)
	@echo "🦭 安装 Podman Quadlet 配置..."
	@mkdir -p ~/.config/containers/systemd
	@cp podman/quadlet/smlyfm-blog.container ~/.config/containers/systemd/
	@echo ""
	@echo "✅ Quadlet 配置已安装"
	@echo ""
	@echo "📋 启用步骤:"
	@echo "   1. 先构建镜像: make podman-build"
	@echo "   2. 重载服务:   systemctl --user daemon-reload"
	@echo "   3. 启动服务:   systemctl --user start smlyfm-blog"
	@echo "   4. 开机自启:   systemctl --user enable smlyfm-blog"
	@echo ""
	@echo "📋 查看状态:"
	@echo "   systemctl --user status smlyfm-blog"
	@echo "   podman logs smlyfm-blog"

# ============================================
# 🔧 通用容器命令
# ============================================

.PHONY: container-helper

container-helper: ## 🔧 使用统一容器管理脚本
	@./tools/container-helper.sh help

# ============================================
# 🔍 诊断与工具
# ============================================

.PHONY: doctor info deps-check validate analyze

doctor: ## 🔍 环境诊断 (检查必要工具)
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    🔍 环境诊断"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "📦 Node.js 环境:"
	@printf "  %-15s %s\n" "Node.js:" "$$(node --version 2>/dev/null || echo '❌ 未安装')"
	@printf "  %-15s %s\n" "npm:" "$$(npm --version 2>/dev/null || echo '❌ 未安装')"
	@printf "  %-15s %s\n" "Hexo:" "$$(npx hexo version 2>/dev/null | grep '^hexo:' | awk '{print $$2}' || echo '❌ 未安装')"
	@echo ""
	@echo "🔧 版本控制:"
	@printf "  %-15s %s\n" "Git:" "$$(git --version 2>/dev/null | cut -d' ' -f3 || echo '❌ 未安装')"
	@printf "  %-15s %s\n" "当前分支:" "$$(git branch --show-current 2>/dev/null || echo 'N/A')"
	@echo ""
	@echo "🐳 容器运行时:"
	@printf "  %-15s %s\n" "Docker:" "$$(docker --version 2>/dev/null | cut -d' ' -f3 | tr -d ',' || echo '未安装')"
	@printf "  %-15s %s\n" "Podman:" "$$(podman --version 2>/dev/null | cut -d' ' -f3 || echo '未安装')"
	@printf "  %-15s %s\n" "podman-compose:" "$$(podman-compose --version 2>/dev/null | head -1 | awk '{print $$NF}' || echo '未安装')"
	@echo ""
	@echo "📁 项目状态:"
	@printf "  %-15s %s\n" "文章数量:" "$$(find $(POST_DIR) -name '*.md' 2>/dev/null | wc -l) 篇"
	@printf "  %-15s %s\n" "草稿数量:" "$$(find $(DRAFT_DIR) -name '*.md' 2>/dev/null | wc -l) 篇"
	@printf "  %-15s %s\n" "Git 状态:" "$$([ -n \"`git status --porcelain 2>/dev/null`\" ] && echo '有未提交更改' || echo '工作区干净')"
	@echo ""
	@echo "✅ 诊断完成"

info: ## 📊 显示项目详细信息
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📊 项目信息: $(PROJECT_NAME)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "📁 目录结构:"
	@printf "  %-20s %s\n" "源码目录:" "$(SOURCE_DIR)"
	@printf "  %-20s %s\n" "文章目录:" "$(POST_DIR)"
	@printf "  %-20s %s\n" "草稿目录:" "$(DRAFT_DIR)"
	@printf "  %-20s %s\n" "输出目录:" "$(PUBLIC_DIR)"
	@echo ""
	@echo "🌿 Git 配置:"
	@printf "  %-20s %s\n" "源码分支:" "$(GIT_BRANCH_SOURCE)"
	@printf "  %-20s %s\n" "部署分支:" "$(GIT_BRANCH_DEPLOY)"
	@printf "  %-20s %s\n" "远程仓库:" "$(GIT_REMOTE)"
	@printf "  %-20s %s\n" "当前提交:" "$$(git rev-parse --short HEAD 2>/dev/null || echo 'N/A')"
	@echo ""
	@echo "🐳 容器配置:"
	@printf "  %-20s %s\n" "镜像名称:" "$(DOCKER_IMAGE):$(DOCKER_TAG)"
	@printf "  %-20s %s\n" "容器名称:" "$(CONTAINER_NAME)"
	@echo ""
	@echo "📝 内容统计:"
	@printf "  %-20s %d 篇\n" "正式文章:" "$$(find $(POST_DIR) -name '*.md' 2>/dev/null | wc -l)"
	@printf "  %-20s %d 篇\n" "草稿:" "$$(find $(DRAFT_DIR) -name '*.md' 2>/dev/null | wc -l)"
	@if [ -d "$(PUBLIC_DIR)" ]; then \
		printf "  %-20s %s\n" "构建产物大小:" "$$(du -sh $(PUBLIC_DIR) 2>/dev/null | cut -f1)"; \
	fi
	@echo ""

deps-check: ## 📦 检查依赖更新
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📦 检查依赖更新"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "🔍 检查过时的 npm 包..."
	@npm outdated || echo "✅ 所有依赖都是最新版本"
	@echo ""
	@echo "💡 更新依赖: npm update"
	@echo "💡 更新全部: npm update --save"

validate: ## ✅ 验证配置文件
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    ✅ 验证配置文件"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "🔍 检查 _config.yml..."
	@if npx js-yaml _config.yml > /dev/null 2>&1; then \
		echo "  ✅ _config.yml 语法正确"; \
	else \
		echo "  ❌ _config.yml 语法错误"; \
	fi
	@echo ""
	@echo "🔍 检查 _config.butterfly.yml..."
	@if npx js-yaml _config.butterfly.yml > /dev/null 2>&1; then \
		echo "  ✅ _config.butterfly.yml 语法正确"; \
	else \
		echo "  ❌ _config.butterfly.yml 语法错误"; \
	fi
	@echo ""
	@echo "🔍 检查 package.json..."
	@if node -e "JSON.parse(require('fs').readFileSync('package.json'))" 2>/dev/null; then \
		echo "  ✅ package.json 语法正确"; \
	else \
		echo "  ❌ package.json 语法错误"; \
	fi
	@echo ""
	@echo "🔍 尝试 Hexo 生成测试..."
	@if npx hexo generate --silent 2>/dev/null; then \
		echo "  ✅ Hexo 构建成功"; \
	else \
		echo "  ⚠️  Hexo 构建有警告或错误，请运行 make build 查看详情"; \
	fi
	@echo ""

analyze: build ## 📊 分析构建产物大小
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    📊 构建产物分析"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "📁 总大小: $$(du -sh $(PUBLIC_DIR) | cut -f1)"
	@echo ""
	@echo "📂 按目录:"
	@du -sh $(PUBLIC_DIR)/* 2>/dev/null | sort -hr | head -10
	@echo ""
	@echo "📄 最大文件 (前10):"
	@find $(PUBLIC_DIR) -type f -exec du -h {} + 2>/dev/null | sort -hr | head -10
	@echo ""
	@echo "📊 文件类型分布:"
	@echo "  HTML: $$(find $(PUBLIC_DIR) -name '*.html' | wc -l) 个"
	@echo "  CSS:  $$(find $(PUBLIC_DIR) -name '*.css' | wc -l) 个"
	@echo "  JS:   $$(find $(PUBLIC_DIR) -name '*.js' | wc -l) 个"
	@echo "  图片: $$(find $(PUBLIC_DIR) \( -name '*.png' -o -name '*.jpg' -o -name '*.gif' -o -name '*.webp' \) | wc -l) 个"
	@echo ""

