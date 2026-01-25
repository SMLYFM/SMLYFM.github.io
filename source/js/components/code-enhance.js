/**
 * 代码块增强组件 - Code Block Enhancement
 * 💡 一键复制代码
 * 💡 语言标签美化
 * 💡 行号显示优化
 */

(function () {
  'use strict';

  // 💡 多语言支持
  const LABELS = {
    copy: {
      'zh-CN': '复制',
      'zh-TW': '複製',
      en: 'Copy',
    },
    copied: {
      'zh-CN': '已复制!',
      'zh-TW': '已複製!',
      en: 'Copied!',
    },
    error: {
      'zh-CN': '复制失败',
      'zh-TW': '複製失敗',
      en: 'Failed',
    },
  };

  /**
   * 获取当前语言
   */
  function getCurrentLanguage() {
    const htmlLang = document.documentElement.lang?.toLowerCase() || '';
    if (htmlLang.includes('zh-tw') || htmlLang.includes('zh-hant')) {
      return 'zh-TW';
    }
    if (htmlLang.startsWith('zh')) {
      return 'zh-CN';
    }
    return 'en';
  }

  /**
   * 复制文本到剪贴板
   */
  async function copyToClipboard(text) {
    try {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        await navigator.clipboard.writeText(text);
        return true;
      }
      // 💡 降级方案
      const textArea = document.createElement('textarea');
      textArea.value = text;
      textArea.style.cssText = 'position:fixed;left:-9999px;top:-9999px';
      document.body.appendChild(textArea);
      textArea.select();
      const result = document.execCommand('copy');
      document.body.removeChild(textArea);
      return result;
    } catch (err) {
      console.error('Copy failed:', err);
      return false;
    }
  }

  /**
   * 创建复制按钮
   */
  function createCopyButton(codeBlock) {
    const lang = getCurrentLanguage();

    const button = document.createElement('button');
    button.className = 'code-copy-btn';
    button.type = 'button';
    button.innerHTML = `
      <svg class="copy-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
      </svg>
      <svg class="check-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <polyline points="20 6 9 17 4 12"/>
      </svg>
      <span class="copy-text">${LABELS.copy[lang]}</span>
    `;

    button.addEventListener('click', async e => {
      e.preventDefault();
      e.stopPropagation();

      // 💡 获取代码文本
      const code = codeBlock.querySelector('code');
      if (!code) return;

      const text = code.textContent || code.innerText;
      const success = await copyToClipboard(text);
      const currentLang = getCurrentLanguage();

      const textSpan = button.querySelector('.copy-text');

      if (success) {
        button.classList.add('copied');
        textSpan.textContent = LABELS.copied[currentLang];

        setTimeout(() => {
          button.classList.remove('copied');
          textSpan.textContent = LABELS.copy[currentLang];
        }, 2000);
      } else {
        textSpan.textContent = LABELS.error[currentLang];
        setTimeout(() => {
          textSpan.textContent = LABELS.copy[currentLang];
        }, 2000);
      }
    });

    return button;
  }

  /**
   * 处理所有代码块
   */
  function enhanceCodeBlocks() {
    // 💡 选择所有代码块（兼容不同主题结构）
    const codeBlocks = document.querySelectorAll(
      'figure.highlight, pre:not(.mermaid), .code-container'
    );

    codeBlocks.forEach(block => {
      // 💡 检查是否已处理
      if (block.querySelector('.code-copy-btn')) return;

      // 💡 确保有代码内容
      const code = block.querySelector('code');
      if (!code) return;

      // 💡 添加容器类
      block.classList.add('code-enhanced');

      // 💡 创建工具栏
      let toolbar = block.querySelector('.code-toolbar');
      if (!toolbar) {
        toolbar = document.createElement('div');
        toolbar.className = 'code-toolbar';

        // 💡 语言标签
        const langLabel =
          block.getAttribute('data-lang') ||
          block.className.match(/language-(\w+)/)?.[1] ||
          code.className.match(/language-(\w+)/)?.[1] ||
          '';

        if (langLabel) {
          const langBadge = document.createElement('span');
          langBadge.className = 'code-lang-badge';
          langBadge.textContent = langLabel.toUpperCase();
          toolbar.appendChild(langBadge);
        }

        // 💡 复制按钮
        toolbar.appendChild(createCopyButton(block));

        // 💡 插入工具栏
        block.insertBefore(toolbar, block.firstChild);
      } else {
        // 💡 工具栏已存在，只添加复制按钮
        if (!toolbar.querySelector('.code-copy-btn')) {
          toolbar.appendChild(createCopyButton(block));
        }
      }
    });
  }

  /**
   * 初始化
   */
  function init() {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', enhanceCodeBlocks);
    } else {
      enhanceCodeBlocks();
    }

    // 💡 处理动态加载的内容（如 Pjax）
    document.addEventListener('pjax:complete', enhanceCodeBlocks);
  }

  // 💡 导出 API
  window.CodeEnhance = {
    refresh: enhanceCodeBlocks,
  };

  // 💡 启动
  init();
})();
