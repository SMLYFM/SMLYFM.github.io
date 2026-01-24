// ==================================================
// Lighthouse CI 配置
// 项目: SMLYFM.github.io
// ==================================================

module.exports = {
  ci: {
    collect: {
      // 💡 测试的 URL
      url: ['http://localhost:8080/'],
      // 💡 运行次数（取中位数）
      numberOfRuns: 3,
      // 💡 启动本地服务器
      startServerCommand: 'npm run preview',
      startServerReadyPattern: 'Hexo is running',
      startServerReadyTimeout: 30000,
    },
    assert: {
      // 💡 性能基准（预设）
      preset: 'lighthouse:recommended',
      assertions: {
        // 💡 核心 Web Vitals
        'first-contentful-paint': ['warn', { maxNumericValue: 2000 }],
        'largest-contentful-paint': ['warn', { maxNumericValue: 2500 }],
        'cumulative-layout-shift': ['warn', { maxNumericValue: 0.1 }],
        'total-blocking-time': ['warn', { maxNumericValue: 300 }],

        // 💡 SEO 检查
        'meta-description': 'error',
        'document-title': 'error',
        'robots-txt': 'warn',

        // 💡 可访问性
        'color-contrast': 'warn',
        'image-alt': 'warn',

        // 💡 最佳实践
        'uses-https': 'off', // 本地测试关闭
        'is-crawlable': 'warn',

        // 💡 PWA 检查
        'installable-manifest': 'warn',
        'service-worker': 'warn',

        // 💡 分数阈值
        'categories:performance': ['warn', { minScore: 0.8 }],
        'categories:accessibility': ['warn', { minScore: 0.9 }],
        'categories:best-practices': ['warn', { minScore: 0.9 }],
        'categories:seo': ['warn', { minScore: 0.9 }],
      },
    },
    upload: {
      // 💡 上传到临时公共存储（保留7天）
      target: 'temporary-public-storage',
    },
  },
};
