# ============================================
# Hexo 博客项目 Makefile
# ============================================
# 💡 提供完整的博客管理功能
# 💡 作者: CJX
# 💡 项目: SMLYFM.github.io

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

# ============================================
# 帮助信息
# ============================================
help: ## 显示帮助信息
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    $(PROJECT_NAME) - Hexo 博客管理系统"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "环境信息:"
	@echo "  Node.js: $(NODE_VERSION)"
	@echo "  npm:     $(NPM_VERSION)"
	@echo "  Hexo:    $(HEXO_VERSION)"
	@echo ""
	@echo "使用方法: make [target]"
	@echo ""
	@echo "📦 项目管理:"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "项目管理") \
				printf "  %-15s %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""
	@echo "🏗️  构建部署:"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "构建部署") \
				printf "  %-15s %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""
	@echo "✍️  内容管理:"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "内容管理") \
				printf "  %-15s %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""
	@echo "🔧 维护工具:"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "维护工具") \
				printf "  %-15s %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
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
	@echo "🔍 检查项目状态..."
	@echo ""
	@echo "Node.js 环境:"
	@echo "  Node.js: $(NODE_VERSION)"
	@echo "  npm:     $(NPM_VERSION)"
	@echo "  Hexo:    $(HEXO_VERSION)"
	@echo ""
	@echo "Git 状态:"
	@git status --short
	@echo ""
	@echo "分支信息:"
	@git branch -vv
	@echo ""
	@echo "文章统计:"
	@echo "  正式文章: $$(find $(POST_DIR) -name '*.md' | wc -l) 篇"
	@echo "  草稿:     $$(find $(DRAFT_DIR) -name '*.md' 2>/dev/null | wc -l) 篇"
	@echo ""

status: ## 查看Git状态
	@echo "📊 Git 状态"
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
	@echo "生成文件: $(PUBLIC_DIR)/"

server: ## 启动本地服务器
	@echo "🌐 启动本地服务器..."
	@echo "访问: http://localhost:4000"
	@npx hexo server

dev: ## 开发模式(含草稿)
	@echo "🔧 启动开发服务器(包含草稿)..."
	@echo "访问: http://localhost:4000"
	@npx hexo server --draft

deploy: build ## 部署到GitHub Pages
	@echo "🚀 部署到 GitHub Pages..."
	@npx hexo deploy
	@echo "✓ 部署完成"
	@echo "网站: https://smlyfm.github.io"

# ============================================
## 内容管理
# ============================================

new: ## 创建新文章 (make new TITLE="文章标题")
	@if [ -z "$(TITLE)" ]; then \
		bash tools/new-post.sh; \
	else \
		echo "✍️  创建文章: $(TITLE)"; \
		npx hexo new post "$(TITLE)"; \
		echo "✓ 文章已创建"; \
	fi

draft: ## 创建草稿 (make draft TITLE="草稿标题")
	@if [ -z "$(TITLE)" ]; then \
		echo "错误: 请指定标题"; \
		echo "用法: make draft TITLE=\"草稿标题\""; \
		exit 1; \
	else \
		echo "✍️  创建草稿: $(TITLE)"; \
		npx hexo new draft "$(TITLE)"; \
		echo "✓ 草稿已创建"; \
	fi

publish: ## 发布草稿 (make publish DRAFT="草稿名")
	@if [ -z "$(DRAFT)" ]; then \
		echo "错误: 请指定草稿名"; \
		echo "用法: make publish DRAFT=\"草稿名\""; \
		exit 1; \
	else \
		echo "📤 发布草稿: $(DRAFT)"; \
		npx hexo publish draft "$(DRAFT)"; \
		echo "✓ 草稿已发布"; \
	fi

list: ## 列出所有文章
	@echo "📄 文章列表"
	@echo ""
	@echo "正式文章 ($(POST_DIR)):"
	@find $(POST_DIR) -name '*.md' -type f -exec basename {} \; | sort
	@echo ""
	@echo "草稿 ($(DRAFT_DIR)):"
	@find $(DRAFT_DIR) -name '*.md' -type f -exec basename {} \; 2>/dev/null | sort || echo "  (无草稿)"

# Markdown模板创建
template-post: ## 创建文章模板 (make template-post TITLE="标题" CAT="分类" TAGS="tag1 tag2")
	@if [ -z "$(TITLE)" ]; then \
		echo "错误: 请指定标题"; \
		exit 1; \
	fi
	@FILENAME="$(POST_DIR)/$(TITLE).md"; \
	CATEGORY="$${CAT:-blog}"; \
	TAGS_LIST="$${TAGS:-}"; \
	echo "✍️  创建文章模板: $$FILENAME"; \
	mkdir -p $(POST_DIR); \
	echo "---" > "$$FILENAME"; \
	echo "title: $(TITLE)" >> "$$FILENAME"; \
	echo "date: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "updated: $(TIMESTAMP)" >> "$$FILENAME"; \
	echo "categories: $$CATEGORY" >> "$$FILENAME"; \
	echo "tags:" >> "$$FILENAME"; \
	if [ -n "$$TAGS_LIST" ]; then \
		for tag in $$TAGS_LIST; do \
			echo "  - $$tag" >> "$$FILENAME"; \
		done; \
	fi; \
	echo "---" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 简介" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "<!-- more -->" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 内容" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "## 总结" >> "$$FILENAME"; \
	echo "" >> "$$FILENAME"; \
	echo "✓ 模板已创建: $$FILENAME"

# ============================================
## 维护工具
# ============================================

push: ## 提交并推送源码到master
	@echo "📤 提交源码到 $(GIT_BRANCH_SOURCE) 分支..."
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo ""; \
		git status --short; \
		echo ""; \
		read -p "提交信息: " MSG; \
		if [ -z "$$MSG" ]; then \
			MSG="Update: $(TIMESTAMP)"; \
		fi; \
		git add .; \
		git commit -m "$$MSG"; \
		git push $(GIT_REMOTE) $(GIT_BRANCH_SOURCE); \
		echo "✓ 推送完成"; \
	else \
		echo "⚠️  工作区干净,无需提交"; \
	fi

pull: ## 从远程拉取更新
	@echo "📥 拉取远程更新..."
	@git pull $(GIT_REMOTE) $(GIT_BRANCH_SOURCE)
	@echo "✓ 拉取完成"

sync: push deploy ## 同步:提交源码+部署网站
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    ✓ 同步完成!"
	@echo "    源码已推送到: $(GIT_BRANCH_SOURCE)"
	@echo "    网站已部署到: $(GIT_BRANCH_DEPLOY)"
	@echo "    访问: https://smlyfm.github.io"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

backup: ## 备份博客内容
	@echo "💾 备份博客内容..."
	@BACKUP_FILE="$(BACKUP_DIR)/blog-backup-$(DATE).tar.gz"; \
	mkdir -p $(BACKUP_DIR); \
	tar -czf "$$BACKUP_FILE" \
		--exclude='node_modules' \
		--exclude='public' \
		--exclude='.deploy_git' \
		--exclude='.git' \
		$(SOURCE_DIR) _config*.yml package.json; \
	echo "✓ 备份完成: $$BACKUP_FILE"; \
	ls -lh "$$BACKUP_FILE"

restore: ## 恢复最新备份
	@echo "♻️  恢复备份..."
	@LATEST_BACKUP=$$(ls -t $(BACKUP_DIR)/blog-backup-*.tar.gz 2>/dev/null | head -1); \
	if [ -z "$$LATEST_BACKUP" ]; then \
		echo "错误: 未找到备份文件"; \
		exit 1; \
	fi; \
	echo "将恢复: $$LATEST_BACKUP"; \
	read -p "是否继续? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		tar -xzf "$$LATEST_BACKUP"; \
		echo "✓ 恢复完成"; \
	else \
		echo "已取消"; \
	fi

# ============================================
# 快捷命令别名
# ============================================

s: server ## 别名: server
d: dev ## 别名: dev
b: build ## 别名: build
dp: deploy ## 别名: deploy
n: new ## 别名: new
p: push ## 别名: push
l: list ## 别名: list
c: clean ## 别名: clean

# ============================================
# 高级功能
# ============================================

watch: ## 监听文件变化并自动构建
	@echo "👀 监听文件变化..."
	@while true; do \
		inotifywait -r -e modify,create,delete $(SOURCE_DIR) 2>/dev/null && \
		echo "🔄 检测到变化,重新构建..." && \
		make build; \
	done

count: ## 统计文章字数
	@echo "📊 文章统计"
	@echo ""
	@TOTAL_WORDS=0; \
	TOTAL_POSTS=0; \
	for file in $(POST_DIR)/*.md; do \
		if [ -f "$$file" ]; then \
			WORDS=$$(wc -w < "$$file"); \
			TOTAL_WORDS=$$((TOTAL_WORDS + WORDS)); \
			TOTAL_POSTS=$$((TOTAL_POSTS + 1)); \
			printf "%-50s %6d 字\n" "$$(basename $$file)" "$$WORDS"; \
		fi; \
	done; \
	echo ""; \
	echo "总计: $$TOTAL_POSTS 篇文章, $$TOTAL_WORDS 字"

grep-posts: ## 搜索文章内容 (make grep-posts KEYWORD="关键词")
	@if [ -z "$(KEYWORD)" ]; then \
		echo "错误: 请指定搜索关键词"; \
		echo "用法: make grep-posts KEYWORD=\"关键词\""; \
		exit 1; \
	fi
	@echo "🔍 搜索关键词: $(KEYWORD)"
	@echo ""
	@grep -rn --color=always "$(KEYWORD)" $(POST_DIR)/ || echo "未找到匹配结果"

# ============================================
# CI/CD 相关
# ============================================

ci-test: ## CI测试:安装依赖+构建
	@echo "🧪 运行 CI 测试..."
	@npm ci
	@npx hexo clean
	@npx hexo generate
	@echo "✓ CI 测试通过"

ci-deploy: ci-test ## CI部署:测试+部署
	@echo "🚀 CI 部署..."
	@npx hexo deploy
	@echo "✓ CI 部署完成"

# ============================================
# 版本信息
# ============================================

version: ## 显示版本信息
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "    版本信息"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo ""
	@echo "环境:"
	@echo "  Node.js:  $(NODE_VERSION)"
	@echo "  npm:      $(NPM_VERSION)"
	@echo "  Hexo:     $(HEXO_VERSION)"
	@echo ""
	@echo "Git:"
	@echo "  Branch:   $$(git branch --show-current)"
	@echo "  Commit:   $$(git rev-parse --short HEAD)"
	@echo "  Remote:   $$(git remote get-url origin)"
	@echo ""
	@echo "项目:"
	@echo "  名称:     $(PROJECT_NAME)"
	@echo "  路径:     $$(pwd)"
	@echo ""

# ============================================
# 开发辅助
# ============================================

init: ## 初始化新项目
	@echo "🎉 初始化 Hexo 项目..."
	@npm install
	@git init
	@echo "✓ 项目初始化完成"
	@echo ""
	@echo "下一步:"
	@echo "  1. 配置 _config.yml"
	@echo "  2. make new TITLE=\"第一篇文章\""
	@echo "  3. make dev"

deps-tree: ## 显示依赖树
	@echo "📦 依赖树"
	@npm list --depth=0

audit: ## 安全审计
	@echo "🔒 安全审计"
	@npm audit
	@echo ""
	@echo "运行 'npm audit fix' 修复问题"
