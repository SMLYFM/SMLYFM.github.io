/**
 * 公式编号系统
 * 💡 支持自动编号和交叉引用
 */

(function () {
  'use strict';

  // 💡 公式计数器
  let equationCounter = 0;
  const equationRefs = new Map();

  // 💡 重置计数器
  function resetCounter() {
    equationCounter = 0;
    equationRefs.clear();
  }

  // 💡 为显示公式添加编号
  function numberEquations() {
    resetCounter();

    document.querySelectorAll('.katex-display').forEach((display, index) => {
      // 检查是否已经有编号
      if (display.querySelector('.eq-number')) return;

      // 检查是否需要编号 (通过 data-eq-label 或特定类名)
      const label = display.dataset.eqLabel || display.dataset.label;
      const shouldNumber =
        display.classList.contains('numbered') ||
        label ||
        display.closest('.numbered-equations');

      if (!shouldNumber && !display.closest('article')) {
        // 默认为文章内的所有行间公式编号
        if (
          !display.closest(
            '.post-content, .article-content, #article-container'
          )
        ) {
          return;
        }
      }

      equationCounter++;
      const eqNum = equationCounter;

      // 存储引用
      if (label) {
        equationRefs.set(label, eqNum);
      }

      // 创建编号元素
      const numSpan = document.createElement('span');
      numSpan.className = 'eq-number';
      numSpan.textContent = `(${eqNum})`;
      numSpan.style.cssText = `
                position: absolute;
                right: 1em;
                top: 50%;
                transform: translateY(-50%);
                font-size: 0.9em;
                color: #64748b;
                font-family: 'Consolas', 'Monaco', monospace;
            `;

      // 设置父元素为相对定位
      display.style.position = 'relative';
      display.appendChild(numSpan);

      // 添加 ID 用于引用
      if (label) {
        display.id = `eq-${label}`;
      } else {
        display.id = `eq-${eqNum}`;
      }
    });

    console.log(`💡 公式编号完成: ${equationCounter} 个公式`);
  }

  // 💡 处理公式引用
  function processReferences() {
    // 查找所有 \eqref{} 引用 (渲染后可能是特定格式)
    document.querySelectorAll('[data-eq-ref], .eq-ref').forEach(ref => {
      const label =
        ref.dataset.eqRef || ref.textContent.replace(/[()]/g, '').trim();
      const eqNum = equationRefs.get(label);

      if (eqNum) {
        ref.textContent = `(${eqNum})`;
        ref.href = `#eq-${label}`;
        ref.classList.add('eq-ref-link');
        ref.style.cssText = `
                    color: #3b82f6;
                    text-decoration: none;
                    cursor: pointer;
                `;

        ref.addEventListener('click', e => {
          e.preventDefault();
          const target = document.getElementById(`eq-${label}`);
          if (target) {
            target.scrollIntoView({ behavior: 'smooth', block: 'center' });
            // 高亮效果
            target.style.backgroundColor = 'rgba(59, 130, 246, 0.2)';
            setTimeout(() => {
              target.style.backgroundColor = '';
            }, 2000);
          }
        });
      }
    });
  }

  // 💡 初始化
  function init() {
    numberEquations();
    processReferences();
  }

  // 页面加载后初始化
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => setTimeout(init, 300));
  } else {
    setTimeout(init, 300);
  }

  // 💡 为 PJAX 页面切换提供支持
  if (typeof btf !== 'undefined' && btf.addGlobalFn) {
    btf.addGlobalFn('encrypt', () => setTimeout(init, 300), 'eq-numbering');
  }

  // 导出到全局
  window.equationRefs = equationRefs;
  window.refreshEquationNumbers = init;
})();
