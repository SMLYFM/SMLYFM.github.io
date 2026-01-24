/**
 * Butterfly主题辅助函数
 * 💡 提供页面类型判断、URL处理等工具函数
 */

hexo.extend.helper.register('getPageType', function (page, is_home) {
    // 💡 判断当前页面类型
    if (is_home) return 'index';
    if (page.archive) return 'archive';
    if (page.category) return 'category';
    if (page.tag) return 'tag';
    if (page.layout === 'post') return 'post';
    return 'page';
});

hexo.extend.helper.register('getBgPath', function (path) {
    // 💡 生成背景图片路径样式
    if (!path) return '';
    return `background-image: url(${path})`;
});

hexo.extend.helper.register('urlNoIndex', function (url, trailing_index, trailing_html) {
    // 💡 生成规范化的URL，移除index.html
    const { config } = this;
    url = url || this.url;

    if (trailing_index === false && url.endsWith('index.html')) {
        url = url.slice(0, -10);
    }

    if (trailing_html === false && url.endsWith('.html') && !url.endsWith('index.html')) {
        url = url.slice(0, -5);
    }

    return config.url + (url.startsWith('/') ? url : '/' + url);
});

hexo.extend.helper.register('favicon_tag', function (path) {
    // 💡 生成favicon标签
    if (!path) return '';
    return `<link rel="icon" href="${this.url_for(path)}">`;
});
