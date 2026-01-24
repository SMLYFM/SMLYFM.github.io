/**
 * 实时时钟组件
 * 💡 显示当前时间和日期
 */

/**
 * 更新时间显示
 */
function updateClock() {
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

    // 💡 更新DOM - 直接更新已有元素
    const timeElement = document.getElementById('clock-time')
    const dateElement = document.getElementById('clock-date')

    if (timeElement) {
        timeElement.textContent = timeString
    }
    if (dateElement) {
        dateElement.textContent = dateString
    }
}

// 💡 自动初始化
document.addEventListener('DOMContentLoaded', () => {
    // 检查时钟元素是否存在
    const timeElement = document.getElementById('clock-time')

    if (timeElement) {
        // 💡 立即更新一次
        updateClock()

        // 💡 每秒更新
        setInterval(updateClock, 1000)

        console.log('Clock initialized successfully')
    }
})

// 💡 导出供外部使用
window.updateClock = updateClock
