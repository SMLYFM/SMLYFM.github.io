/**
 * 动态问候语组件
 * 💡 根据时间段显示不同问候语
 */

class Greeting {
    /**
     * 获取问候语
     * @returns {string} 问候语文本
     */
    static getGreeting() {
        const hour = new Date().getHours()

        if (hour >= 6 && hour < 12) {
            return '早上好'
        } else if (hour >= 12 && hour < 14) {
            return '中午好'
        } else if (hour >= 14 && hour < 18) {
            return '下午好'
        } else if (hour >= 18 && hour < 22) {
            return '晚上好'
        } else {
            return '夜深了'
        }
    }

    /**
     * 获取英文问候语
     * @returns {string} 英文问候语
     */
    static getGreetingEN() {
        const hour = new Date().getHours()

        if (hour >= 6 && hour < 12) {
            return 'Good Morning'
        } else if (hour >= 12 && hour < 18) {
            return 'Good Afternoon'
        } else if (hour >= 18 && hour < 22) {
            return 'Good Evening'
        } else {
            return 'Good Night'
        }
    }

    /**
     * 初始化问候语元素
     * @param {HTMLElement} element - 目标元素
     * @param {string} lang - 语言（'zh' | 'en'）
     */
    static init(element, lang = 'zh') {
        if (!element) return

        const greeting = lang === 'en' ? this.getGreetingEN() : this.getGreeting()
        element.textContent = greeting

        // 💡 每小时更新一次
        setInterval(() => {
            const newGreeting = lang === 'en' ? this.getGreetingEN() : this.getGreeting()
            element.textContent = newGreeting
        }, 60 * 60 * 1000) // 1小时
    }
}

// 💡 导出供外部使用
window.Greeting = Greeting

// 💡 自动初始化
document.addEventListener('DOMContentLoaded', () => {
    const greetingElement = document.getElementById('greeting-text')
    if (greetingElement) {
        Greeting.init(greetingElement, 'zh')
    }
})
