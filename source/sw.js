// ==================================================
// Service Worker - PWA 离线支持
// 项目: SMLYFM.github.io
// ==================================================

const CACHE_NAME = 'hexo-blog-v1';
const OFFLINE_URL = '/offline.html';

// 💡 预缓存的核心资源
const PRECACHE_ASSETS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/css/index.css',
  '/img/butterfly-icon.png',
  '/img/favicon.png',
];

// 💡 需要缓存的资源类型
const CACHEABLE_TYPES = [
  'text/html',
  'text/css',
  'application/javascript',
  'image/png',
  'image/jpeg',
  'image/webp',
  'image/svg+xml',
  'font/woff2',
  'application/font-woff2',
];

// ==================================================
// 安装事件 - 预缓存核心资源
// ==================================================
self.addEventListener('install', event => {
  console.log('[SW] Installing Service Worker...');
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      console.log('[SW] Pre-caching core assets');
      return cache.addAll(PRECACHE_ASSETS).catch(err => {
        console.warn('[SW] Pre-cache failed for some assets:', err);
      });
    })
  );
  // 💡 跳过等待，立即激活
  self.skipWaiting();
});

// ==================================================
// 激活事件 - 清理旧缓存
// ==================================================
self.addEventListener('activate', event => {
  console.log('[SW] Activating Service Worker...');
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(name => name !== CACHE_NAME)
          .map(name => {
            console.log('[SW] Deleting old cache:', name);
            return caches.delete(name);
          })
      );
    })
  );
  // 💡 立即控制所有页面
  self.clients.claim();
});

// ==================================================
// 请求拦截 - 网络优先策略
// ==================================================
self.addEventListener('fetch', event => {
  // 💡 只处理 GET 请求
  if (event.request.method !== 'GET') return;

  // 💡 跳过非 HTTP(S) 请求
  if (!event.request.url.startsWith('http')) return;

  // 💡 跳过第三方请求（CDN 等）
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin) return;

  event.respondWith(
    // 策略：网络优先，失败时使用缓存
    fetch(event.request)
      .then(response => {
        // 💡 只缓存成功的响应
        if (response.ok) {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, responseClone);
          });
        }
        return response;
      })
      .catch(() => {
        // 💡 网络失败，尝试从缓存获取
        return caches.match(event.request).then(cachedResponse => {
          if (cachedResponse) {
            return cachedResponse;
          }
          // 💡 HTML 请求返回离线页面
          if (event.request.headers.get('accept')?.includes('text/html')) {
            return caches.match('/');
          }
          return new Response('Offline', { status: 503 });
        });
      })
  );
});

// ==================================================
// 消息处理 - 手动更新缓存
// ==================================================
self.addEventListener('message', event => {
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
  }
});
