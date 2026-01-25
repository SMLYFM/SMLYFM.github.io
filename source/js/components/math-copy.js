/**
 * 公式复制按钮组件 - Math Formula Copy
 * 💡 点击公式复制 LaTeX 源码
 * 💡 支持 MathJax 和 KaTeX
 */

(function () {
  'use strict';

  // 💡 多语言支持
  const LABELS = {
    copy: {
      'zh-CN': '复制 LaTeX',
      'zh-TW': '複製 LaTeX',
      en: 'Copy LaTeX',
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
   * 获取公式的 LaTeX 源码
   */
  function getLatexSource(element) {
    // 💡 MathJax 3.x
    if (element.querySelector('mjx-container')) {
      const container = element.querySelector('mjx-container');
      // 从 MathJax 的内部数据获取源码
      if (
        container &&
        container.getAttribute &&
        container.getAttribute('data-latex')
      ) {
        return container.getAttribute('data-latex');
      }
    }

    // 💡 从 script 标签获取（MathJax 2.x 或配置了源码保存）
    const script = element.querySelector('script[type*="math"]');
    if (script) {
      return script.textContent.trim();
    }

    // 💡 KaTeX
    const katex = element.querySelector('.katex');
    if (katex) {
      const annotation = katex.querySelector('annotation[encoding*="tex"]');
      if (annotation) {
        return annotation.textContent.trim();
      }
    }

    // 💡 从 alt 属性获取
    const mjxMath = element.querySelector('[data-mjx-texclass]');
    if (mjxMath && mjxMath.getAttribute('aria-label')) {
      return mjxMath.getAttribute('aria-label');
    }

    // 💡 尝试从 title 或其他属性获取
    if (element.title) {
      return element.title;
    }

    return null;
  }

  /**
   * 创建复制按钮
   */
  function createCopyButton() {
    const lang = getCurrentLanguage();

    const button = document.createElement('button');
    button.className = 'math-copy-btn';
    button.type = 'button';
    button.setAttribute('aria-label', LABELS.copy[lang]);
    button.innerHTML = `
      <svg class="copy-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"/>
        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>
      </svg>
      <svg class="check-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <polyline points="20 6 9 17 4 12"/>
      </svg>
    `;

    return button;
  }

  /**
   * 处理公式元素
   */
  function enhanceMathElements() {
    // 💡 选择所有独立公式（display math）
    const mathElements = document.querySelectorAll(
      '.MathJax_Display, .MathJax_Preview + script + .MathJax_Display, ' +
        'mjx-container[display="true"], mjx-container[jax="CHTML"][display="true"], ' +
        '.katex-display, ' +
        '.math-display, [data-math-display]'
    );

    mathElements.forEach(element => {
      // 💡 检查是否已处理
      if (element.classList.contains('math-copy-enhanced')) return;
      if (element.parentElement?.classList.contains('math-copy-wrapper'))
        return;

      // 💡 创建包装容器
      const wrapper = document.createElement('div');
      wrapper.className = 'math-copy-wrapper';

      // 💡 包装原始元素
      element.parentNode.insertBefore(wrapper, element);
      wrapper.appendChild(element);

      // 💡 添加复制按钮
      const button = createCopyButton();
      wrapper.appendChild(button);

      // 💡 标记已处理
      element.classList.add('math-copy-enhanced');

      // 💡 绑定点击事件
      button.addEventListener('click', async e => {
        e.preventDefault();
        e.stopPropagation();

        const latex = getLatexSource(wrapper);
        const lang = getCurrentLanguage();

        if (!latex) {
          button.classList.add('error');
          setTimeout(() => button.classList.remove('error'), 2000);
          return;
        }

        const success = await copyToClipboard(latex);

        if (success) {
          button.classList.add('copied');
          setTimeout(() => button.classList.remove('copied'), 2000);
        } else {
          button.classList.add('error');
          setTimeout(() => button.classList.remove('error'), 2000);
        }
      });
    });
  }

  /**
   * 等待 MathJax 完成渲染
   */
  function waitForMathJax() {
    // 💡 MathJax 3.x
    if (window.MathJax && window.MathJax.startup) {
      window.MathJax.startup.promise.then(enhanceMathElements);
    }
    // 💡 MathJax 2.x
    else if (window.MathJax && window.MathJax.Hub) {
      window.MathJax.Hub.Queue(enhanceMathElements);
    }
    // 💡 KaTeX 或立即执行
    else {
      enhanceMathElements();
    }
  }

  /**
   * 初始化
   */
  function init() {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => {
        // 💡 延迟执行，等待 MathJax/KaTeX 渲染
        setTimeout(waitForMathJax, 500);
      });
    } else {
      setTimeout(waitForMathJax, 500);
    }

    // 💡 处理动态加载的内容
    document.addEventListener('pjax:complete', () => {
      setTimeout(waitForMathJax, 500);
    });
  }

  // 💡 导出 API
  window.MathCopy = {
    refresh: enhanceMathElements,
  };

  // 💡 启动
  init();
})();
