/**
 * 阅读进度条组件 - Reading Progress Bar
 * 💡 显示当前文章阅读进度
 * 💡 平滑动画，与暗色模式联动
 */

(function () {
  'use strict';

  // 💡 配置
  const CONFIG = {
    // 进度条高度
    height: '3px',
    // 渐变色（与主题色保持一致）
    gradient: 'linear-gradient(90deg, #667eea 0%, #764ba2 50%, #f093fb 100%)',
    // 背景色
    bgLight: 'rgba(0, 0, 0, 0.05)',
    bgDark: 'rgba(255, 255, 255, 0.1)',
    // 只在文章页显示
    postOnly: true,
    // Z-index
    zIndex: 9999,
  };

  let progressBar = null;
  let progressFill = null;
  let ticking = false;

  /**
   * 检查是否是文章页面
   */
  function isPostPage() {
    return (
      document.body.classList.contains('post') ||
      document.getElementById('article-container') !== null ||
      document.getElementById('post') !== null
    );
  }

  /**
   * 创建进度条元素
   */
  function createProgressBar() {
    // 💡 检查是否已存在
    if (document.getElementById('reading-progress-bar')) return;

    // 💡 如果只在文章页显示，检查页面类型
    if (CONFIG.postOnly && !isPostPage()) return;

    // 创建容器
    progressBar = document.createElement('div');
    progressBar.id = 'reading-progress-bar';
    progressBar.className = 'reading-progress-bar';

    // 创建填充条
    progressFill = document.createElement('div');
    progressFill.className = 'reading-progress-fill';

    progressBar.appendChild(progressFill);
    document.body.appendChild(progressBar);

    // 💡 初始化进度
    updateProgress();
  }

  /**
   * 计算并更新进度
   */
  function updateProgress() {
    if (!progressFill) return;

    const scrollTop = window.scrollY || document.documentElement.scrollTop;
    const docHeight =
      document.documentElement.scrollHeight - window.innerHeight;
    const progress =
      docHeight > 0 ? Math.min((scrollTop / docHeight) * 100, 100) : 0;

    progressFill.style.width = `${progress}%`;

    // 💡 添加到达底部的视觉反馈
    if (progress >= 99) {
      progressFill.classList.add('complete');
    } else {
      progressFill.classList.remove('complete');
    }
  }

  /**
   * 滚动事件处理（使用 requestAnimationFrame 优化性能）
   */
  function onScroll() {
    if (!ticking) {
      requestAnimationFrame(() => {
        updateProgress();
        ticking = false;
      });
      ticking = true;
    }
  }

  /**
   * 初始化
   */
  function init() {
    // 💡 DOM 加载完成后创建进度条
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => {
        createProgressBar();
        window.addEventListener('scroll', onScroll, { passive: true });
        window.addEventListener('resize', updateProgress, { passive: true });
      });
    } else {
      createProgressBar();
      window.addEventListener('scroll', onScroll, { passive: true });
      window.addEventListener('resize', updateProgress, { passive: true });
    }
  }

  // 💡 导出 API
  window.ReadingProgress = {
    update: updateProgress,
    show: () => progressBar && (progressBar.style.display = 'block'),
    hide: () => progressBar && (progressBar.style.display = 'none'),
  };

  // 💡 启动
  init();
})();
