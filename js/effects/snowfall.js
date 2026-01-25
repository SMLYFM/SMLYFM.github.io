/**
 * 雪花背景动画效果
 * 💡 使用Canvas API实现高性能雪花动画
 * 💡 支持响应式和性能优化
 */

class SnowfallEffect {
    /**
     * 构造函数
     * @param {HTMLCanvasElement} canvas - Canvas元素
     * @param {Object} options - 配置选项
     */
    constructor(canvas, options = {}) {
        this.canvas = canvas
        this.ctx = canvas.getContext('2d')

        // 💡 配置参数
        this.config = {
            count: options.count || (window.innerWidth < 768 ? 30 : 100), // 雪花数量（移动端减少）
            speed: options.speed || 1, // 下落速度
            wind: options.wind || 0.5, // 风力
            color: options.color || 'rgba(255, 255, 255, 0.8)', // 雪花颜色
            radius: { min: 1, max: 3 }, // 雪花大小范围
        }

        this.snowflakes = []
        this.animationId = null

        this.init()
    }

    /**
     * 初始化
     */
    init() {
        this.resize()
        this.createSnowflakes()
        this.animate()

        // 💡 窗口大小变化时重新初始化
        window.addEventListener('resize', () => this.resize())
    }

    /**
     * 调整Canvas尺寸
     */
    resize() {
        this.canvas.width = window.innerWidth
        this.canvas.height = window.innerHeight
    }

    /**
     * 创建雪花粒子
     */
    createSnowflakes() {
        this.snowflakes = []
        for (let i = 0; i < this.config.count; i++) {
            this.snowflakes.push(this.createSnowflake())
        }
    }

    /**
     * 创建单个雪花
     */
    createSnowflake() {
        return {
            x: Math.random() * this.canvas.width,
            y: Math.random() * this.canvas.height,
            radius: Math.random() * (this.config.radius.max - this.config.radius.min) + this.config.radius.min,
            speed: Math.random() * this.config.speed + 0.5,
            wind: Math.random() * this.config.wind - this.config.wind / 2,
            opacity: Math.random() * 0.5 + 0.3,
        }
    }

    /**
     * 更新雪花位置
     */
    updateSnowflakes() {
        this.snowflakes.forEach(flake => {
            // 💡 更新位置
            flake.y += flake.speed
            flake.x += flake.wind

            // 💡 雪花落到底部时重置到顶部
            if (flake.y > this.canvas.height) {
                flake.y = -10
                flake.x = Math.random() * this.canvas.width
            }

            // 💡 雪花飘出边界时重置
            if (flake.x > this.canvas.width) {
                flake.x = 0
            } else if (flake.x < 0) {
                flake.x = this.canvas.width
            }
        })
    }

    /**
     * 绘制雪花
     */
    drawSnowflakes() {
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height)

        this.snowflakes.forEach(flake => {
            this.ctx.beginPath()
            this.ctx.arc(flake.x, flake.y, flake.radius, 0, Math.PI * 2)
            this.ctx.fillStyle = `rgba(255, 255, 255, ${flake.opacity})`
            this.ctx.fill()
        })
    }

    /**
     * 动画循环
     */
    animate() {
        this.updateSnowflakes()
        this.drawSnowflakes()
        this.animationId = requestAnimationFrame(() => this.animate())
    }

    /**
     * 销毁动画
     */
    destroy() {
        if (this.animationId) {
            cancelAnimationFrame(this.animationId)
        }
        window.removeEventListener('resize', this.resize)
    }
}

// 💡 导出供外部使用
window.SnowfallEffect = SnowfallEffect

// 💡 自动初始化（如果页面有对应canvas）
document.addEventListener('DOMContentLoaded', () => {
    const canvas = document.getElementById('snowfall-canvas')
    if (canvas) {
        const snowfall = new SnowfallEffect(canvas, {
            count: window.innerWidth < 768 ? 30 : 100,
        })

        // 💡 保存实例以便后续控制
        window.snowfallInstance = snowfall
    }
})
