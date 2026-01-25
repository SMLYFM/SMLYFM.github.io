/**
 * 交互式数学工具 - Interactive Math Tools
 * 💡 Desmos 图形嵌入
 * 💡 GeoGebra 几何演示
 * 💡 LaTeX 预览
 */

(function () {
  'use strict';

  /**
   * 创建 Desmos 图形计算器
   * 使用方法: 在 Markdown 中添加 <div class="desmos-graph" data-expression="y=sin(x)"></div>
   */
  function initDesmosGraphs() {
    const containers = document.querySelectorAll(
      '.desmos-graph:not(.initialized)'
    );

    if (containers.length === 0) return;

    // 💡 动态加载 Desmos API
    if (!window.Desmos) {
      const script = document.createElement('script');
      script.src =
        'https://www.desmos.com/api/v1.8/calculator.js?apiKey=dcb31709b452b1cf9dc26972add0fda6';
      script.onload = () => {
        containers.forEach(setupDesmosGraph);
      };
      document.head.appendChild(script);
    } else {
      containers.forEach(setupDesmosGraph);
    }
  }

  function setupDesmosGraph(container) {
    container.classList.add('initialized');

    // 💡 设置容器样式
    container.style.width = container.dataset.width || '100%';
    container.style.height = container.dataset.height || '400px';
    container.style.marginBottom = '1rem';

    const calculator = Desmos.GraphingCalculator(container, {
      expressions: true,
      settingsMenu: false,
      zoomButtons: true,
      expressionsTopbar: false,
    });

    // 💡 解析表达式
    const expressions = (container.dataset.expression || 'y=x').split(';');
    expressions.forEach((expr, index) => {
      calculator.setExpression({
        id: 'expr' + index,
        latex: expr.trim(),
        color: getColor(index),
      });
    });

    // 💡 存储引用
    container._calculator = calculator;
  }

  /**
   * 创建 GeoGebra 几何绘图
   * 使用方法: 在 Markdown 中添加 <div class="geogebra-applet" data-material-id="abc123"></div>
   */
  function initGeoGebraApplets() {
    const containers = document.querySelectorAll(
      '.geogebra-applet:not(.initialized)'
    );

    if (containers.length === 0) return;

    // 💡 动态加载 GeoGebra API
    if (!window.GGBApplet) {
      const script = document.createElement('script');
      script.src = 'https://www.geogebra.org/apps/deployggb.js';
      script.onload = () => {
        containers.forEach(setupGeoGebraApplet);
      };
      document.head.appendChild(script);
    } else {
      containers.forEach(setupGeoGebraApplet);
    }
  }

  function setupGeoGebraApplet(container) {
    container.classList.add('initialized');

    const materialId = container.dataset.materialId;
    const width = parseInt(container.dataset.width) || 800;
    const height = parseInt(container.dataset.height) || 450;

    const params = {
      material_id: materialId,
      width: width,
      height: height,
      showToolBar: false,
      showAlgebraInput: false,
      showMenuBar: false,
      enableRightClick: false,
      enableShiftDragZoom: true,
      showResetIcon: true,
    };

    const applet = new GGBApplet(params, true);
    applet.inject(container);
  }

  /**
   * 创建 LaTeX 实时预览
   * 使用方法: <div class="latex-playground"></div>
   */
  function initLatexPlayground() {
    const containers = document.querySelectorAll(
      '.latex-playground:not(.initialized)'
    );

    containers.forEach(container => {
      container.classList.add('initialized');
      container.innerHTML = createPlaygroundHTML();
      setupPlayground(container);
    });
  }

  function createPlaygroundHTML() {
    return `
      <div class="latex-playground-wrapper">
        <div class="latex-input-section">
          <label>LaTeX 输入:</label>
          <textarea class="latex-input" placeholder="输入 LaTeX 公式，例如: \\frac{1}{2}"></textarea>
        </div>
        <div class="latex-output-section">
          <label>预览:</label>
          <div class="latex-output"></div>
        </div>
        <div class="latex-copy-section">
          <button class="latex-copy-btn">复制 LaTeX</button>
        </div>
      </div>
    `;
  }

  function setupPlayground(container) {
    const input = container.querySelector('.latex-input');
    const output = container.querySelector('.latex-output');
    const copyBtn = container.querySelector('.latex-copy-btn');

    let debounceTimer;

    input.addEventListener('input', () => {
      clearTimeout(debounceTimer);
      debounceTimer = setTimeout(() => {
        const latex = input.value;
        output.innerHTML = `\\[${latex}\\]`;

        // 💡 触发 MathJax 渲染
        if (window.MathJax) {
          if (window.MathJax.typesetPromise) {
            window.MathJax.typesetPromise([output]);
          } else if (window.MathJax.Hub) {
            window.MathJax.Hub.Queue(['Typeset', window.MathJax.Hub, output]);
          }
        }
      }, 300);
    });

    copyBtn.addEventListener('click', () => {
      const latex = input.value;
      navigator.clipboard.writeText(latex).then(() => {
        copyBtn.textContent = '已复制!';
        setTimeout(() => {
          copyBtn.textContent = '复制 LaTeX';
        }, 2000);
      });
    });
  }

  /**
   * 获取颜色
   */
  function getColor(index) {
    const colors = [
      '#667eea',
      '#f093fb',
      '#43e97b',
      '#4facfe',
      '#f5576c',
      '#fbc2eb',
      '#a18cd1',
      '#38f9d7',
    ];
    return colors[index % colors.length];
  }

  /**
   * 初始化所有工具
   */
  function init() {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => {
        initDesmosGraphs();
        initGeoGebraApplets();
        initLatexPlayground();
      });
    } else {
      initDesmosGraphs();
      initGeoGebraApplets();
      initLatexPlayground();
    }

    // 💡 处理 Pjax
    document.addEventListener('pjax:complete', () => {
      initDesmosGraphs();
      initGeoGebraApplets();
      initLatexPlayground();
    });
  }

  // 💡 导出 API
  window.MathTools = {
    initDesmos: initDesmosGraphs,
    initGeoGebra: initGeoGebraApplets,
    initLatexPlayground: initLatexPlayground,
    refresh: init,
  };

  // 💡 启动
  init();
})();
