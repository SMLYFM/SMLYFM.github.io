/**
 * 公式复制功能
 * 💡 点击公式复制 LaTeX 源码到剪贴板
 */

(function () {
  'use strict';

  // 💡 创建复制提示元素
  function createTooltip() {
    const tooltip = document.createElement('div');
    tooltip.id = 'math-copy-tooltip';
    tooltip.className = 'math-copy-tooltip';
    tooltip.textContent = '已复制 LaTeX 源码!';
    tooltip.style.cssText = `
            position: fixed;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            box-shadow: 0 4px 20px rgba(16, 185, 129, 0.4);
            z-index: 10000;
            opacity: 0;
            transition: opacity 0.3s ease, transform 0.3s ease;
            pointer-events: none;
        `;
    document.body.appendChild(tooltip);
    return tooltip;
  }

  // 💡 显示复制成功提示
  function showCopySuccess(tooltip, sourceTex) {
    tooltip.style.opacity = '1';
    tooltip.style.transform = 'translateX(-50%) translateY(0)';

    // 💡 显示部分源码预览
    const preview =
      sourceTex.length > 50 ? sourceTex.substring(0, 50) + '...' : sourceTex;
    tooltip.innerHTML = `<span style="margin-right: 8px;">✓</span> 已复制: <code style="background: rgba(255,255,255,0.2); padding: 2px 6px; border-radius: 4px; font-family: monospace;">${preview}</code>`;

    setTimeout(() => {
      tooltip.style.opacity = '0';
      tooltip.style.transform = 'translateX(-50%) translateY(-10px)';
    }, 2500);
  }

  // 💡 从 KaTeX 渲染元素提取 LaTeX 源码
  function extractLatexSource(element) {
    // 方式1: 查找 annotation 元素 (KaTeX 标准)
    const annotation = element.querySelector(
      'annotation[encoding="application/x-tex"]'
    );
    if (annotation) {
      return annotation.textContent;
    }

    // 方式2: 查找 data-latex 属性
    if (element.dataset.latex) {
      return element.dataset.latex;
    }

    // 方式3: 查找父元素的 title 属性
    const parent = element.closest('[title]');
    if (parent && parent.title.includes('\\')) {
      return parent.title;
    }

    // 方式4: 尝试从 aria-label 获取
    if (element.getAttribute('aria-label')) {
      return element.getAttribute('aria-label');
    }

    return null;
  }

  // 💡 初始化公式复制功能
  function initMathCopy() {
    const tooltip =
      document.getElementById('math-copy-tooltip') || createTooltip();

    // 💡 为所有 KaTeX 公式添加点击事件
    document.querySelectorAll('.katex, .katex-display').forEach(katexEl => {
      // 避免重复绑定
      if (katexEl.dataset.copyBound) return;
      katexEl.dataset.copyBound = 'true';

      // 添加可点击样式
      katexEl.style.cursor = 'pointer';
      katexEl.title = '点击复制 LaTeX 源码';

      katexEl.addEventListener('click', async e => {
        e.preventDefault();
        e.stopPropagation();

        const latex = extractLatexSource(katexEl);

        if (latex) {
          try {
            await navigator.clipboard.writeText(latex);
            showCopySuccess(tooltip, latex);
          } catch (err) {
            // 回退方案
            const textarea = document.createElement('textarea');
            textarea.value = latex;
            textarea.style.position = 'fixed';
            textarea.style.opacity = '0';
            document.body.appendChild(textarea);
            textarea.select();
            document.execCommand('copy');
            document.body.removeChild(textarea);
            showCopySuccess(tooltip, latex);
          }
        } else {
          tooltip.textContent = '⚠️ 无法提取源码';
          tooltip.style.opacity = '1';
          setTimeout(() => {
            tooltip.style.opacity = '0';
          }, 2000);
        }
      });

      // 💡 鼠标悬停效果
      katexEl.addEventListener('mouseenter', () => {
        katexEl.style.backgroundColor = 'rgba(59, 130, 246, 0.08)';
        katexEl.style.borderRadius = '4px';
        katexEl.style.transition = 'background-color 0.2s';
      });

      katexEl.addEventListener('mouseleave', () => {
        katexEl.style.backgroundColor = 'transparent';
      });
    });

    console.log('💡 公式复制功能已启用');
  }

  // 页面加载后初始化
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () =>
      setTimeout(initMathCopy, 500)
    );
  } else {
    setTimeout(initMathCopy, 500);
  }

  // 💡 为 PJAX 页面切换提供支持
  if (typeof btf !== 'undefined' && btf.addGlobalFn) {
    btf.addGlobalFn(
      'encrypt',
      () => setTimeout(initMathCopy, 500),
      'math-copy'
    );
  }

  // 监听 DOM 变化,处理动态加载的公式
  const observer = new MutationObserver(mutations => {
    let hasNewMath = false;
    mutations.forEach(mutation => {
      if (mutation.addedNodes.length) {
        mutation.addedNodes.forEach(node => {
          if (
            node.nodeType === 1 &&
            (node.classList?.contains('katex') ||
              node.querySelector?.('.katex'))
          ) {
            hasNewMath = true;
          }
        });
      }
    });
    if (hasNewMath) {
      setTimeout(initMathCopy, 100);
    }
  });

  observer.observe(document.body, { childList: true, subtree: true });
})();
