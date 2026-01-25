/**
 * Gallery Carousel Component
 * 图片轮播功能
 */

(function () {
    'use strict';

    // 💡 等待 DOM 加载完成
    document.addEventListener('DOMContentLoaded', function () {
        const container = document.getElementById('gallery-container');
        if (!container) return;

        const slides = container.querySelectorAll('.gallery-slide');
        const prevBtn = container.querySelector('.gallery-prev');
        const nextBtn = container.querySelector('.gallery-next');
        const indicators = container.querySelectorAll('.indicator');

        let currentIndex = 0;
        let autoPlayInterval = null;
        const autoPlayDelay = 5000; // 5秒自动切换

        // 💡 切换到指定幻灯片
        function goToSlide(index) {
            // 移除当前激活状态
            slides[currentIndex].classList.remove('active');
            indicators[currentIndex].classList.remove('active');

            // 设置新索引
            currentIndex = index;
            if (currentIndex < 0) currentIndex = slides.length - 1;
            if (currentIndex >= slides.length) currentIndex = 0;

            // 添加激活状态
            slides[currentIndex].classList.add('active');
            indicators[currentIndex].classList.add('active');
        }

        // 💡 下一张
        function nextSlide() {
            goToSlide(currentIndex + 1);
        }

        // 💡 上一张
        function prevSlide() {
            goToSlide(currentIndex - 1);
        }

        // 💡 启动自动播放
        function startAutoPlay() {
            stopAutoPlay();
            autoPlayInterval = setInterval(nextSlide, autoPlayDelay);
        }

        // 💡 停止自动播放
        function stopAutoPlay() {
            if (autoPlayInterval) {
                clearInterval(autoPlayInterval);
                autoPlayInterval = null;
            }
        }

        // 💡 事件监听
        if (prevBtn) {
            prevBtn.addEventListener('click', function () {
                prevSlide();
                stopAutoPlay();
                startAutoPlay(); // 重新开始自动播放
            });
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', function () {
                nextSlide();
                stopAutoPlay();
                startAutoPlay();
            });
        }

        // 💡 指示器点击
        indicators.forEach(function (indicator, index) {
            indicator.addEventListener('click', function () {
                goToSlide(index);
                stopAutoPlay();
                startAutoPlay();
            });
        });

        // 💡 鼠标悬停暂停自动播放
        container.addEventListener('mouseenter', stopAutoPlay);
        container.addEventListener('mouseleave', startAutoPlay);

        // 💡 触摸滑动支持（移动端）
        let touchStartX = 0;
        let touchEndX = 0;

        container.addEventListener('touchstart', function (e) {
            touchStartX = e.changedTouches[0].screenX;
            stopAutoPlay();
        }, { passive: true });

        container.addEventListener('touchend', function (e) {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe();
            startAutoPlay();
        }, { passive: true });

        function handleSwipe() {
            const swipeThreshold = 50;
            const diff = touchStartX - touchEndX;

            if (Math.abs(diff) > swipeThreshold) {
                if (diff > 0) {
                    nextSlide(); // 向左滑动，显示下一张
                } else {
                    prevSlide(); // 向右滑动，显示上一张
                }
            }
        }

        // 💡 键盘导航
        document.addEventListener('keydown', function (e) {
            if (e.key === 'ArrowLeft') {
                prevSlide();
                stopAutoPlay();
                startAutoPlay();
            } else if (e.key === 'ArrowRight') {
                nextSlide();
                stopAutoPlay();
                startAutoPlay();
            }
        });

        // 💡 启动自动播放
        startAutoPlay();

        // 💡 页面可见性变化时暂停/恢复
        document.addEventListener('visibilitychange', function () {
            if (document.hidden) {
                stopAutoPlay();
            } else {
                startAutoPlay();
            }
        });
    });
})();
