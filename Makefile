# ============================================
# Hexo 博客项目 Makefile
# ============================================
# 💡 提供完整的博客管理功能
# 💡 作者: CJX
# 💡 项目: SMLYFM.github.io

.PHONY: help install clean build deploy server dev new draft publish status push pull sync list check upgrade backup restore

# 默认目标
.DEFAULT_GOAL := help

# 颜色定义
BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

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
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)    $(PROJECT_NAME) - Hexo 博客管理系统$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(GREEN)环境信息:$(NC)"
	@echo "  Node.js: $(NODE_VERSION)"
	@echo "  npm:     $(NPM_VERSION)"
	@echo "  Hexo:    $(HEXO_VERSION)"
	@echo ""
	@echo "$(GREEN)使用方法:$(NC) make [target]"
	@echo ""
	@echo "$(YELLOW)📦 项目管理:$(NC)"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "项目管理") \
				printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)🏗️  构建部署:$(NC)"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "构建部署") \
				printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)✍️  内容管理:$(NC)"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "内容管理") \
				printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(YELLOW)🔧 维护工具:$(NC)"
	@awk 'BEGIN {FS = ":.*##"; category=""} \
		/^## / {category=substr($$0, 4); next} \
		/^[a-zA-Z_-]+:.*?##/ { \
			if (category == "维护工具") \
				printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 \
		}' $(MAKEFILE_LIST)
	@echo ""
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"

# ============================================
## 项目管理
# ============================================

install: ## 安装项目依赖
	@echo "$(BLUE)📦 安装项目依赖...$(NC)"
	@npm install
	@echo "$(GREEN)✓ 依赖安装完成$(NC)"

upgrade: ## 升级依赖包
	@echo "$(BLUE)⬆️  升级依赖包...$(NC)"
	@npm update
	@npm outdated
	@echo "$(GREEN)✓ 依赖升级完成$(NC)"

check: ## 检查项目状态
	@echo "$(BLUE)🔍 检查项目状态...$(NC)"
	@echo ""
	@echo "$(YELLOW)Node.js 环境:$(NC)"
	@echo "  Node.js: $(NODE_VERSION)"
	@echo "  npm:     $(NPM_VERSION)"
	@echo "  Hexo:    $(HEXO_VERSION)"
	@echo ""
	@echo "$(YELLOW)Git 状态:$(NC)"
	@git status --short
	@echo ""
	@echo "$(YELLOW)分支信息:$(NC)"
	@git branch -vv
	@echo ""
	@echo "$(YELLOW)文章统计:$(NC)"
	@echo "  正式文章: $$(find $(POST_DIR) -name '*.md' | wc -l) 篇"
	@echo "  草稿:     $$(find $(DRAFT_DIR) -name '*.md' 2>/dev/null | wc -l) 篇"
	@echo ""

status: ## 查看Git状态
	@echo "$(BLUE)📊 Git 状态$(NC)"
	@git status

# ============================================
## 构建部署
# ============================================

clean: ## 清理生成文件
	@echo "$(BLUE)🧹 清理缓存和生成文件...$(NC)"
	@npx hexo clean
	@rm -rf $(PUBLIC_DIR) $(DEPLOY_DIR)
	@echo "$(GREEN)✓ 清理完成$(NC)"

build: clean ## 构建静态网站
	@echo "$(BLUE)🏗️  构建静态网站...$(NC)"
	@npx hexo generate
	@echo "$(GREEN)✓ 构建完成$(NC)"
	@echo "$(YELLOW)生成文件: $(PUBLIC_DIR)/$(NC)"

server: ## 启动本地服务器
	@echo "$(BLUE)🌐 启动本地服务器...$(NC)"
	@echo "$(YELLOW)访问: http://localhost:4000$(NC)"
	@npx hexo server

dev: ## 开发模式(含草稿)
	@echo "$(BLUE)🔧 启动开发服务器(包含草稿)...$(NC)"
	@echo "$(YELLOW)访问: http://localhost:4000$(NC)"
	@npx hexo server --draft

deploy: build ## 部署到GitHub Pages
	@echo "$(BLUE)🚀 部署到 GitHub Pages...$(NC)"
	@npx hexo deploy
	@echo "$(GREEN)✓ 部署完成$(NC)"
	@echo "$(YELLOW)网站: https://smlyfm.github.io$(NC)"

# ============================================
## 内容管理
# ============================================

new: ## 创建新文章 (make new TITLE="文章标题")
	@if [ -z "$(TITLE)" ]; then \
		bash tools/new-post.sh; \
	else \
		echo "$(BLUE)✍️  创建文章: $(TITLE)$(NC)"; \
		npx hexo new post "$(TITLE)"; \
		echo "$(GREEN)✓ 文章已创建$(NC)"; \
	fi

draft: ## 创建草稿 (make draft TITLE="草稿标题")
	@if [ -z "$(TITLE)" ]; then \
		echo "$(RED)错误: 请指定标题$(NC)"; \
		echo "$(YELLOW)用法: make draft TITLE=\"草稿标题\"$(NC)"; \
		exit 1; \
	else \
		echo "$(BLUE)✍️  创建草稿: $(TITLE)$(NC)"; \
		npx hexo new draft "$(TITLE)"; \
		echo "$(GREEN)✓ 草稿已创建$(NC)"; \
	fi

publish: ## 发布草稿 (make publish DRAFT="草稿名")
	@if [ -z "$(DRAFT)" ]; then \
		echo "$(RED)错误: 请指定草稿名$(NC)"; \
		echo "$(YELLOW)用法: make publish DRAFT=\"草稿名\"$(NC)"; \
		exit 1; \
	else \
		echo "$(BLUE)📤 发布草稿: $(DRAFT)$(NC)"; \
		npx hexo publish draft "$(DRAFT)"; \
		echo "$(GREEN)✓ 草稿已发布$(NC)"; \
	fi

list: ## 列出所有文章
	@echo "$(BLUE)📄 文章列表$(NC)"
	@echo ""
	@echo "$(YELLOW)正式文章 ($(POST_DIR)):$(NC)"
	@find $(POST_DIR) -name '*.md' -type f -exec basename {} \; | sort
	@echo ""
	@echo "$(YELLOW)草稿 ($(DRAFT_DIR)):$(NC)"
	@find $(DRAFT_DIR) -name '*.md' -type f -exec basename {} \; 2>/dev/null | sort || echo "  (无草稿)"

# Markdown模板创建
template-post: ## 创建文章模板 (make template-post TITLE="标题" CAT="分类" TAGS="tag1 tag2")
	@if [ -z "$(TITLE)" ]; then \
		echo "$(RED)错误: 请指定标题$(NC)"; \
		exit 1; \
	fi
	@FILENAME="$(POST_DIR)/$(TITLE).md"; \
	CATEGORY="$${CAT:-blog}"; \
	TAGS_LIST="$${TAGS:-}"; \
	echo "$(BLUE)✍️  创建文章模板: $$FILENAME$(NC)"; \
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
	echo "$(GREEN)✓ 模板已创建: $$FILENAME$(NC)"

# ============================================
## 维护工具
# ============================================

push: ## 提交并推送源码到master
	@echo "$(BLUE)📤 提交源码到 $(GIT_BRANCH_SOURCE) 分支...$(NC)"
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
		echo "$(GREEN)✓ 推送完成$(NC)"; \
	else \
		echo "$(YELLOW)⚠️  工作区干净,无需提交$(NC)"; \
	fi

pull: ## 从远程拉取更新
	@echo "$(BLUE)📥 拉取远程更新...$(NC)"
	@git pull $(GIT_REMOTE) $(GIT_BRANCH_SOURCE)
	@echo "$(GREEN)✓ 拉取完成$(NC)"

sync: push deploy ## 同步:提交源码+部署网站
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(GREEN)    ✓ 同步完成!$(NC)"
	@echo "$(GREEN)    源码已推送到: $(GIT_BRANCH_SOURCE)$(NC)"
	@echo "$(GREEN)    网站已部署到: $(GIT_BRANCH_DEPLOY)$(NC)"
	@echo "$(GREEN)    访问: https://smlyfm.github.io$(NC)"
	@echo "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"

backup: ## 备份博客内容
	@echo "$(BLUE)💾 备份博客内容...$(NC)"
	@BACKUP_FILE="$(BACKUP_DIR)/blog-backup-$(DATE).tar.gz"; \
	mkdir -p $(BACKUP_DIR); \
	tar -czf "$$BACKUP_FILE" \
		--exclude='node_modules' \
		--exclude='public' \
		--exclude='.deploy_git' \
		--exclude='.git' \
		$(SOURCE_DIR) _config*.yml package.json; \
	echo "$(GREEN)✓ 备份完成: $$BACKUP_FILE$(NC)"; \
	ls -lh "$$BACKUP_FILE"

restore: ## 恢复最新备份
	@echo "$(BLUE)♻️  恢复备份...$(NC)"
	@LATEST_BACKUP=$$(ls -t $(BACKUP_DIR)/blog-backup-*.tar.gz 2>/dev/null | head -1); \
	if [ -z "$$LATEST_BACKUP" ]; then \
		echo "$(RED)错误: 未找到备份文件$(NC)"; \
		exit 1; \
	fi; \
	echo "$(YELLOW)将恢复: $$LATEST_BACKUP$(NC)"; \
	read -p "是否继续? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		tar -xzf "$$LATEST_BACKUP"; \
		echo "$(GREEN)✓ 恢复完成$(NC)"; \
	else \
		echo "$(YELLOW)已取消$(NC)"; \
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
	@echo "$(BLUE)👀 监听文件变化...$(NC)"
	@while true; do \
		inotifywait -r -e modify,create,delete $(SOURCE_DIR) 2>/dev/null && \
		echo "$(YELLOW)🔄 检测到变化,重新构建...$(NC)" && \
		make build; \
	done

count: ## 统计文章字数
	@echo "$(BLUE)📊 文章统计$(NC)"
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
	echo "$(YELLOW)总计: $$TOTAL_POSTS 篇文章, $$TOTAL_WORDS 字$(NC)"

grep-posts: ## 搜索文章内容 (make grep-posts KEYWORD="关键词")
	@if [ -z "$(KEYWORD)" ]; then \
		echo "$(RED)错误: 请指定搜索关键词$(NC)"; \
		echo "$(YELLOW)用法: make grep-posts KEYWORD=\"关键词\"$(NC)"; \
		exit 1; \
	fi
	@echo "$(BLUE)🔍 搜索关键词: $(KEYWORD)$(NC)"
	@echo ""
	@grep -rn --color=always "$(KEYWORD)" $(POST_DIR)/ || echo "$(YELLOW)未找到匹配结果$(NC)"

# ============================================
# CI/CD 相关
# ============================================

ci-test: ## CI测试:安装依赖+构建
	@echo "$(BLUE)🧪 运行 CI 测试...$(NC)"
	@npm ci
	@npx hexo clean
	@npx hexo generate
	@echo "$(GREEN)✓ CI 测试通过$(NC)"

ci-deploy: ci-test ## CI部署:测试+部署
	@echo "$(BLUE)🚀 CI 部署...$(NC)"
	@npx hexo deploy
	@echo "$(GREEN)✓ CI 部署完成$(NC)"

# ============================================
# 版本信息
# ============================================

version: ## 显示版本信息
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo "$(BLUE)    版本信息$(NC)"
	@echo "$(BLUE)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(NC)"
	@echo ""
	@echo "$(YELLOW)环境:$(NC)"
	@echo "  Node.js:  $(NODE_VERSION)"
	@echo "  npm:      $(NPM_VERSION)"
	@echo "  Hexo:     $(HEXO_VERSION)"
	@echo ""
	@echo "$(YELLOW)Git:$(NC)"
	@echo "  Branch:   $$(git branch --show-current)"
	@echo "  Commit:   $$(git rev-parse --short HEAD)"
	@echo "  Remote:   $$(git remote get-url origin)"
	@echo ""
	@echo "$(YELLOW)项目:$(NC)"
	@echo "  名称:     $(PROJECT_NAME)"
	@echo "  路径:     $$(pwd)"
	@echo ""

# ============================================
# 开发辅助
# ============================================

init: ## 初始化新项目
	@echo "$(BLUE)🎉 初始化 Hexo 项目...$(NC)"
	@npm install
	@git init
	@echo "$(GREEN)✓ 项目初始化完成$(NC)"
	@echo ""
	@echo "$(YELLOW)下一步:$(NC)"
	@echo "  1. 配置 _config.yml"
	@echo "  2. make new TITLE=\"第一篇文章\""
	@echo "  3. make dev"

deps-tree: ## 显示依赖树
	@echo "$(BLUE)📦 依赖树$(NC)"
	@npm list --depth=0

audit: ## 安全审计
	@echo "$(BLUE)🔒 安全审计$(NC)"
	@npm audit
	@echo ""
	@echo "$(YELLOW)运行 'npm audit fix' 修复问题$(NC)"
