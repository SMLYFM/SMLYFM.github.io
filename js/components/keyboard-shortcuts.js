/**
 * 键盘快捷键组件 - Keyboard Shortcuts
 * 💡 J/K 上下滚动
 * 💡 D 切换暗色模式
 * 💡 / 快速搜索
 * 💡 G H 回到首页
 * 💡 ? 显示帮助
 */

(function () {
  'use strict';

  // 💡 快捷键配置
  const SHORTCUTS = {
    // 滚动
    j: {
      action: 'scrollDown',
      description: {
        'zh-CN': '向下滚动',
        'zh-TW': '向下捲動',
        en: 'Scroll down',
      },
    },
    k: {
      action: 'scrollUp',
      description: {
        'zh-CN': '向上滚动',
        'zh-TW': '向上捲動',
        en: 'Scroll up',
      },
    },

    // 主题
    d: {
      action: 'toggleDarkMode',
      description: {
        'zh-CN': '切换暗色模式',
        'zh-TW': '切換深色模式',
        en: 'Toggle dark mode',
      },
    },

    // 搜索
    '/': {
      action: 'openSearch',
      description: {
        'zh-CN': '打开搜索',
        'zh-TW': '開啟搜尋',
        en: 'Open search',
      },
    },

    // 导航（需要先按 G）
    'g h': {
      action: 'goHome',
      description: { 'zh-CN': '回到首页', 'zh-TW': '回到首頁', en: 'Go home' },
    },
    'g a': {
      action: 'goArchives',
      description: {
        'zh-CN': '归档页面',
        'zh-TW': '歸檔頁面',
        en: 'Go to archives',
      },
    },
    'g t': {
      action: 'goTags',
      description: {
        'zh-CN': '标签页面',
        'zh-TW': '標籤頁面',
        en: 'Go to tags',
      },
    },
    'g c': {
      action: 'goCategories',
      description: {
        'zh-CN': '分类页面',
        'zh-TW': '分類頁面',
        en: 'Go to categories',
      },
    },

    // 帮助
    '?': {
      action: 'showHelp',
      description: {
        'zh-CN': '显示快捷键帮助',
        'zh-TW': '顯示快捷鍵幫助',
        en: 'Show shortcuts help',
      },
    },

    // 返回顶部
    'g g': {
      action: 'goTop',
      description: {
        'zh-CN': '返回顶部',
        'zh-TW': '返回頂部',
        en: 'Go to top',
      },
    },

    // 到底部
    G: {
      action: 'goBottom',
      description: {
        'zh-CN': '到达底部',
        'zh-TW': '到達底部',
        en: 'Go to bottom',
      },
    },
  };

  // 💡 滚动距离
  const SCROLL_DISTANCE = 150;

  // 💡 状态
  let pendingKey = null;
  let pendingTimeout = null;
  let helpDialogOpen = false;

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
   * 检查是否在输入框中
   */
  function isInputActive() {
    const activeElement = document.activeElement;
    if (!activeElement) return false;

    const tagName = activeElement.tagName.toLowerCase();
    return (
      tagName === 'input' ||
      tagName === 'textarea' ||
      tagName === 'select' ||
      activeElement.isContentEditable
    );
  }

  /**
   * 执行动作
   */
  function executeAction(action) {
    switch (action) {
      case 'scrollDown':
        window.scrollBy({ top: SCROLL_DISTANCE, behavior: 'smooth' });
        break;

      case 'scrollUp':
        window.scrollBy({ top: -SCROLL_DISTANCE, behavior: 'smooth' });
        break;

      case 'toggleDarkMode':
        if (window.ThemeToggle) {
          window.ThemeToggle.cycle();
        } else {
          // 💡 Butterfly 默认切换
          const currentTheme =
            document.documentElement.getAttribute('data-theme');
          document.documentElement.setAttribute(
            'data-theme',
            currentTheme === 'dark' ? 'light' : 'dark'
          );
        }
        break;

      case 'openSearch':
        // 💡 Butterfly 搜索
        const searchBtn = document.querySelector('.search');
        if (searchBtn) searchBtn.click();
        break;

      case 'goHome':
        window.location.href = '/';
        break;

      case 'goArchives':
        window.location.href = '/archives/';
        break;

      case 'goTags':
        window.location.href = '/tags/';
        break;

      case 'goCategories':
        window.location.href = '/categories/';
        break;

      case 'goTop':
        window.scrollTo({ top: 0, behavior: 'smooth' });
        break;

      case 'goBottom':
        window.scrollTo({
          top: document.documentElement.scrollHeight,
          behavior: 'smooth',
        });
        break;

      case 'showHelp':
        toggleHelpDialog();
        break;
    }
  }

  /**
   * 创建帮助对话框
   */
  function createHelpDialog() {
    if (document.getElementById('shortcuts-help-dialog')) return;

    const lang = getCurrentLanguage();

    const dialog = document.createElement('div');
    dialog.id = 'shortcuts-help-dialog';
    dialog.className = 'shortcuts-help-dialog';

    const title = {
      'zh-CN': '⌨️ 键盘快捷键',
      'zh-TW': '⌨️ 鍵盤快捷鍵',
      en: '⌨️ Keyboard Shortcuts',
    };

    let content = `
      <div class="shortcuts-help-content">
        <div class="shortcuts-help-header">
          <h3>${title[lang]}</h3>
          <button class="shortcuts-help-close" aria-label="Close">&times;</button>
        </div>
        <div class="shortcuts-help-body">
    `;

    // 💡 分组显示快捷键
    const groups = {
      'zh-CN': { navigation: '导航', scroll: '滚动', other: '其他' },
      'zh-TW': { navigation: '導航', scroll: '捲動', other: '其他' },
      en: { navigation: 'Navigation', scroll: 'Scrolling', other: 'Other' },
    };

    const groupedShortcuts = {
      scroll: ['j', 'k', 'g g', 'G'],
      navigation: ['g h', 'g a', 'g t', 'g c', '/'],
      other: ['d', '?'],
    };

    for (const [groupKey, keys] of Object.entries(groupedShortcuts)) {
      content += `<div class="shortcuts-group">
        <h4>${groups[lang][groupKey]}</h4>
        <div class="shortcuts-list">`;

      for (const key of keys) {
        const shortcut = SHORTCUTS[key];
        if (shortcut) {
          const keyDisplay = key
            .split(' ')
            .map(k => `<kbd>${k}</kbd>`)
            .join(' + ');
          content += `
            <div class="shortcut-item">
              <span class="shortcut-keys">${keyDisplay}</span>
              <span class="shortcut-desc">${shortcut.description[lang]}</span>
            </div>`;
        }
      }

      content += `</div></div>`;
    }

    content += `</div></div>`;
    dialog.innerHTML = content;

    // 💡 关闭按钮事件
    dialog
      .querySelector('.shortcuts-help-close')
      .addEventListener('click', () => {
        toggleHelpDialog(false);
      });

    // 💡 点击遮罩关闭
    dialog.addEventListener('click', e => {
      if (e.target === dialog) {
        toggleHelpDialog(false);
      }
    });

    document.body.appendChild(dialog);
  }

  /**
   * 切换帮助对话框
   */
  function toggleHelpDialog(show) {
    let dialog = document.getElementById('shortcuts-help-dialog');

    if (!dialog) {
      createHelpDialog();
      dialog = document.getElementById('shortcuts-help-dialog');
    }

    if (show === undefined) {
      show = !helpDialogOpen;
    }

    if (show) {
      dialog.classList.add('show');
      helpDialogOpen = true;
    } else {
      dialog.classList.remove('show');
      helpDialogOpen = false;
    }
  }

  /**
   * 处理按键
   */
  function handleKeyDown(e) {
    // 💡 忽略输入框中的按键
    if (isInputActive()) return;

    // 💡 忽略组合键（除了 Shift）
    if (e.ctrlKey || e.altKey || e.metaKey) return;

    // 💡 ESC 关闭帮助
    if (e.key === 'Escape' && helpDialogOpen) {
      toggleHelpDialog(false);
      return;
    }

    let key = e.key;

    // 💡 处理组合键（G + 其他键）
    if (pendingKey) {
      clearTimeout(pendingTimeout);
      const combo = pendingKey + ' ' + key.toLowerCase();
      pendingKey = null;

      if (SHORTCUTS[combo]) {
        e.preventDefault();
        executeAction(SHORTCUTS[combo].action);
        return;
      }
    }

    // 💡 G 键等待第二个键
    if (key.toLowerCase() === 'g' && !e.shiftKey) {
      pendingKey = 'g';
      pendingTimeout = setTimeout(() => {
        pendingKey = null;
      }, 500);
      return;
    }

    // 💡 大写 G 直接到底部
    if (key === 'G' && e.shiftKey) {
      e.preventDefault();
      executeAction('goBottom');
      return;
    }

    // 💡 单键快捷键
    const lowerKey = key.toLowerCase();
    if (SHORTCUTS[lowerKey] || SHORTCUTS[key]) {
      const shortcut = SHORTCUTS[lowerKey] || SHORTCUTS[key];
      e.preventDefault();
      executeAction(shortcut.action);
    }
  }

  /**
   * 初始化
   */
  function init() {
    document.addEventListener('keydown', handleKeyDown);
  }

  // 💡 导出 API
  window.KeyboardShortcuts = {
    showHelp: () => toggleHelpDialog(true),
    hideHelp: () => toggleHelpDialog(false),
  };

  // 💡 启动
  init();
})();
