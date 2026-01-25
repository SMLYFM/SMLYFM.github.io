/**
 * 主题切换器 - Theme Toggle Component
 * 💡 支持三种模式：Light / Dark / System (跟随系统)
 * 💡 优先读取用户保存的偏好，否则跟随系统主题
 * 💡 平滑过渡动画，视觉效果友好
 */

(function () {
  'use strict';

  // 💡 存储键名，与 Butterfly 主题保持一致
  const STORAGE_KEY = 'theme';
  const SYSTEM_PREFERENCE_KEY = 'theme-follows-system';

  // 💡 图标 SVG（太阳、月亮、系统）
  const ICONS = {
    light: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <circle cx="12" cy="12" r="5"/>
      <line x1="12" y1="1" x2="12" y2="3"/>
      <line x1="12" y1="21" x2="12" y2="23"/>
      <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/>
      <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
      <line x1="1" y1="12" x2="3" y2="12"/>
      <line x1="21" y1="12" x2="23" y2="12"/>
      <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/>
      <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
    </svg>`,
    dark: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
    </svg>`,
    system: `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
      <rect x="2" y="3" width="20" height="14" rx="2" ry="2"/>
      <line x1="8" y1="21" x2="16" y2="21"/>
      <line x1="12" y1="17" x2="12" y2="21"/>
    </svg>`,
  };

  // 💡 多语言支持：简体中文 / 繁体中文 / 英文
  const LABELS = {
    light: {
      'zh-CN': '浅色模式',
      'zh-TW': '淺色模式',
      en: 'Light Mode',
    },
    dark: {
      'zh-CN': '深色模式',
      'zh-TW': '深色模式',
      en: 'Dark Mode',
    },
    system: {
      'zh-CN': '跟随系统',
      'zh-TW': '跟隨系統',
      en: 'System',
    },
  };

  /**
   * 获取当前页面语言
   * 💡 检测 html lang 属性，支持 Butterfly 繁简转换
   * @returns {'zh-CN' | 'zh-TW' | 'en'}
   */
  function getCurrentLanguage() {
    const htmlLang = document.documentElement.lang?.toLowerCase() || '';

    // 💡 检测繁体中文：zh-TW, zh-Hant, zh-HK, zh-MO
    if (
      htmlLang.includes('zh-tw') ||
      htmlLang.includes('zh-hant') ||
      htmlLang.includes('zh-hk') ||
      htmlLang.includes('zh-mo')
    ) {
      return 'zh-TW';
    }

    // 💡 检测简体中文：zh-CN, zh-Hans, zh（默认简体）
    if (htmlLang.startsWith('zh')) {
      return 'zh-CN';
    }

    // 💡 其他语言默认英文
    return 'en';
  }

  /**
   * 获取系统主题偏好
   * @returns {'light' | 'dark'}
   */
  function getSystemPreference() {
    if (
      window.matchMedia &&
      window.matchMedia('(prefers-color-scheme: dark)').matches
    ) {
      return 'dark';
    }
    return 'light';
  }

  /**
   * 获取当前有效主题
   * @returns {'light' | 'dark'}
   */
  function getEffectiveTheme() {
    const followsSystem =
      localStorage.getItem(SYSTEM_PREFERENCE_KEY) === 'true';
    if (followsSystem) {
      return getSystemPreference();
    }
    return localStorage.getItem(STORAGE_KEY) || getSystemPreference();
  }

  /**
   * 获取用户选择的模式
   * @returns {'light' | 'dark' | 'system'}
   */
  function getUserMode() {
    const followsSystem =
      localStorage.getItem(SYSTEM_PREFERENCE_KEY) === 'true';
    if (followsSystem) {
      return 'system';
    }
    return localStorage.getItem(STORAGE_KEY) || 'system';
  }

  /**
   * 应用主题到页面
   * @param {'light' | 'dark'} theme
   */
  function applyTheme(theme) {
    const html = document.documentElement;

    // 💡 添加过渡类，实现平滑切换
    html.classList.add('theme-transitioning');

    // 💡 设置 Butterfly 主题使用的 data-theme 属性
    html.setAttribute('data-theme', theme);

    // 💡 更新 meta 标签（影响移动端浏览器地址栏颜色）
    updateThemeColor(theme);

    // 💡 过渡完成后移除过渡类
    setTimeout(() => {
      html.classList.remove('theme-transitioning');
    }, 300);
  }

  /**
   * 更新浏览器主题色（移动端地址栏颜色）
   * @param {'light' | 'dark'} theme
   */
  function updateThemeColor(theme) {
    const themeColors = {
      light: '#ffffff',
      dark: '#0d1117',
    };

    let metaThemeColor = document.querySelector('meta[name="theme-color"]');
    if (!metaThemeColor) {
      metaThemeColor = document.createElement('meta');
      metaThemeColor.name = 'theme-color';
      document.head.appendChild(metaThemeColor);
    }
    metaThemeColor.content = themeColors[theme];

    // 💡 iOS Safari 的特殊支持
    let metaApple = document.querySelector(
      'meta[name="apple-mobile-web-app-status-bar-style"]'
    );
    if (!metaApple) {
      metaApple = document.createElement('meta');
      metaApple.name = 'apple-mobile-web-app-status-bar-style';
      document.head.appendChild(metaApple);
    }
    metaApple.content = theme === 'dark' ? 'black-translucent' : 'default';
  }

  /**
   * 设置主题模式
   * @param {'light' | 'dark' | 'system'} mode
   */
  function setMode(mode) {
    if (mode === 'system') {
      localStorage.setItem(SYSTEM_PREFERENCE_KEY, 'true');
      localStorage.removeItem(STORAGE_KEY);
      applyTheme(getSystemPreference());
    } else {
      localStorage.setItem(SYSTEM_PREFERENCE_KEY, 'false');
      localStorage.setItem(STORAGE_KEY, mode);
      applyTheme(mode);
    }
    updateToggleButton(mode);
  }

  /**
   * 循环切换模式：light -> dark -> system -> light
   */
  function cycleMode() {
    const currentMode = getUserMode();
    const modes = ['light', 'dark', 'system'];
    const currentIndex = modes.indexOf(currentMode);
    const nextMode = modes[(currentIndex + 1) % modes.length];
    setMode(nextMode);

    // 💡 显示切换提示（可选）
    showToast(nextMode);
  }

  /**
   * 更新切换按钮的图标和状态
   * @param {'light' | 'dark' | 'system'} mode
   */
  function updateToggleButton(mode) {
    const button = document.getElementById('theme-toggle-btn');
    if (!button) return;

    const iconContainer = button.querySelector('.theme-toggle-icon');
    const labelContainer = button.querySelector('.theme-toggle-label');

    if (iconContainer) {
      iconContainer.innerHTML = ICONS[mode];
    }

    if (labelContainer) {
      const lang = getCurrentLanguage();
      labelContainer.textContent = LABELS[mode][lang];
    }

    button.setAttribute('data-mode', mode);
    button.setAttribute('aria-label', LABELS[mode].en);
  }

  /**
   * 显示切换提示
   * @param {'light' | 'dark' | 'system'} mode
   */
  function showToast(mode) {
    // 💡 移除已存在的 toast
    const existingToast = document.querySelector('.theme-toast');
    if (existingToast) {
      existingToast.remove();
    }

    const lang = getCurrentLanguage();
    const toast = document.createElement('div');
    toast.className = 'theme-toast';
    toast.innerHTML = `
      <span class="theme-toast-icon">${ICONS[mode]}</span>
      <span class="theme-toast-text">${LABELS[mode][lang]}</span>
    `;

    document.body.appendChild(toast);

    // 💡 触发动画
    requestAnimationFrame(() => {
      toast.classList.add('theme-toast-show');
    });

    // 💡 自动消失
    setTimeout(() => {
      toast.classList.remove('theme-toast-show');
      setTimeout(() => toast.remove(), 300);
    }, 1500);
  }

  /**
   * 创建浮动切换按钮
   */
  function createFloatingButton() {
    // 💡 检查是否已存在
    if (document.getElementById('theme-toggle-btn')) return;

    const button = document.createElement('button');
    button.id = 'theme-toggle-btn';
    button.className = 'theme-toggle-btn';
    button.type = 'button';
    button.innerHTML = `
      <span class="theme-toggle-icon"></span>
      <span class="theme-toggle-label"></span>
    `;

    button.addEventListener('click', cycleMode);

    // 💡 长按显示完整菜单（可选功能）
    let pressTimer;
    button.addEventListener('mousedown', () => {
      pressTimer = setTimeout(() => showModeMenu(button), 500);
    });
    button.addEventListener('mouseup', () => clearTimeout(pressTimer));
    button.addEventListener('mouseleave', () => clearTimeout(pressTimer));

    document.body.appendChild(button);

    // 💡 初始化按钮状态
    updateToggleButton(getUserMode());
  }

  /**
   * 显示模式选择菜单
   * @param {HTMLElement} button
   */
  function showModeMenu(button) {
    // 💡 移除已存在的菜单
    const existingMenu = document.querySelector('.theme-mode-menu');
    if (existingMenu) {
      existingMenu.remove();
      return;
    }

    const menu = document.createElement('div');
    menu.className = 'theme-mode-menu';

    const modes = ['light', 'dark', 'system'];
    const currentMode = getUserMode();
    const lang = getCurrentLanguage();

    modes.forEach(mode => {
      const item = document.createElement('button');
      item.className = `theme-mode-item ${mode === currentMode ? 'active' : ''}`;
      item.innerHTML = `
        <span class="mode-icon">${ICONS[mode]}</span>
        <span class="mode-label">${LABELS[mode][lang]}</span>
      `;
      item.addEventListener('click', e => {
        e.stopPropagation();
        setMode(mode);
        menu.remove();
      });
      menu.appendChild(item);
    });

    // 💡 定位菜单
    const rect = button.getBoundingClientRect();
    menu.style.bottom = `${window.innerHeight - rect.top + 10}px`;
    menu.style.right = `${window.innerWidth - rect.right}px`;

    document.body.appendChild(menu);

    // 💡 点击其他地方关闭菜单
    setTimeout(() => {
      document.addEventListener('click', function closeMenu() {
        menu.remove();
        document.removeEventListener('click', closeMenu);
      });
    }, 0);
  }

  /**
   * 初始化
   */
  function init() {
    // 💡 立即应用已保存的主题，避免闪烁
    const effectiveTheme = getEffectiveTheme();
    document.documentElement.setAttribute('data-theme', effectiveTheme);
    updateThemeColor(effectiveTheme);

    // 💡 监听系统主题变化
    if (window.matchMedia) {
      window
        .matchMedia('(prefers-color-scheme: dark)')
        .addEventListener('change', e => {
          const followsSystem =
            localStorage.getItem(SYSTEM_PREFERENCE_KEY) === 'true';
          if (followsSystem) {
            const newTheme = e.matches ? 'dark' : 'light';
            applyTheme(newTheme);
          }
        });
    }

    // 💡 DOM 加载完成后创建按钮
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', createFloatingButton);
    } else {
      createFloatingButton();
    }
  }

  // 💡 导出 API 供其他脚本使用
  window.ThemeToggle = {
    getMode: getUserMode,
    setMode: setMode,
    getEffectiveTheme: getEffectiveTheme,
    cycle: cycleMode,
  };

  // 💡 启动
  init();
})();
