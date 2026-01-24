/**
 * Stats Counter Animation
 * 统计数字滚动动画
 */

(function () {
    'use strict';

    function animateValue(element, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
            if (!startTimestamp) startTimestamp = timestamp;
            const progress = Math.min((timestamp - startTimestamp) / duration, 1);
            const value = Math.floor(progress * (end - start) + start);
            element.textContent = value;
            if (progress < 1) {
                window.requestAnimationFrame(step);
            }
        };
        window.requestAnimationFrame(step);
    }

    // 使用 Intersection Observer 检测元素进入视口
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const statValues = entry.target.querySelectorAll('.stat-value');
                statValues.forEach(value => {
                    const count = parseInt(value.getAttribute('data-count'));
                    if (!isNaN(count)) {
                        animateValue(value, 0, count, 1500);
                    }
                });
                observer.unobserve(entry.target);
            }
        });
    }, { threshold: 0.5 });

    document.addEventListener('DOMContentLoaded', function () {
        const statsCard = document.querySelector('.stats-card');
        if (statsCard) {
            observer.observe(statsCard);
        }
    });
})();
