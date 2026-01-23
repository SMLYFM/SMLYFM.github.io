/**
 * 实时时钟组件
 * 💡 显示当前时间和日期
 */

class Clock {
    /**
     * 构造函数
     * @param {HTMLElement} container - 容器元素
     */
    constructor(container) {
        if (!container) {
            console.error('Clock: Container element not found')
            return
        }

        this.container = container
        this.timeElement = null
        this.dateElement = null
        this.intervalId = null

        this.init()
    }

    /**
     * 初始化
     */
    init() {
        this.render()
        this.startClock()
    }

    /**
     * 渲染时钟HTML结构
     */
    render() {
        this.container.innerHTML = `
      <div class="clock-time" id="clock-time"></div>
      <div class="clock-date" id="clock-date"></div>
    `

        this.timeElement = document.getElementById('clock-time')
        this.dateElement = document.getElementById('clock-date')
    }

    /**
     * 更新时间显示
     */
    updateTime() {
        const now = new Date()

        // 💡 格式化时间（HH:MM:SS）
        const hours = String(now.getHours()).padStart(2, '0')
        const minutes = String(now.getMinutes()).padStart(2, '0')
        const seconds = String(now.getSeconds()).padStart(2, '0')
        const timeString = `${hours}:${minutes}:${seconds}`

        // 💡 格式化日期（2026年1月23日 星期四）
        const year = now.getFullYear()
        const month = now.getMonth() + 1
        const date = now.getDate()
        const weekdays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
        const weekday = weekdays[now.getDay()]
        const dateString = `${year}年${month}月${date}日 ${weekday}`

        // 💡 更新DOM
        if (this.timeElement) {
            this.timeElement.textContent = timeString
        }
        if (this.dateElement) {
            this.dateElement.textContent = dateString
        }
    }

    /**
     * 启动时钟
     */
    startClock() {
        // 💡 立即更新一次
        this.updateTime()

        // 💡 每秒更新
        this.intervalId = setInterval(() => {
            this.updateTime()
        }, 1000)
    }

    /**
     * 停止时钟
     */
    stopClock() {
        if (this.intervalId) {
            clearInterval(this.intervalId)
            this.intervalId = null
        }
    }

    /**
     * 销毁时钟
     */
    destroy() {
        this.stopClock()
        if (this.container) {
            this.container.innerHTML = ''
        }
    }
}

// 💡 导出供外部使用
window.Clock = Clock

// 💡 自动初始化（如果页面有对应容器）
document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('clock-container')
    if (container) {
        const clock = new Clock(container)

        // 💡 保存实例以便后续控制
        window.clockInstance = clock
    }
})
