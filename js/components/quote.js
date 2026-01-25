/**
 * 名言切换组件
 * 💡 随机显示励志名言和数学名言
 */

(function () {
  'use strict';

  // 名言列表
  var quotes = [
    // 数学家名言
    { text: '数学是上帝用来书写宇宙的语言。', author: '伽利略' },
    { text: '数学是科学的皇后，而数论是数学的皇后。', author: '高斯' },
    {
      text: '在数学中，提出问题的艺术比解决问题的艺术更为重要。',
      author: '康托尔',
    },
    { text: '纯粹数学是这样的一门学科，它的结论是必然的。', author: '罗素' },
    { text: '数学是打开科学大门的钥匙。', author: '培根' },
    { text: '自然界的书是用数学语言写成的。', author: '伽利略' },
    { text: '数学是思维的音乐。', author: '西尔维斯特' },
    { text: '上帝创造了整数，其余都是人类的工作。', author: '克罗内克' },

    // 科学家名言
    { text: '想象力比知识更重要。', author: '爱因斯坦' },
    { text: '天才是百分之一的灵感加上百分之九十九的汗水。', author: '爱迪生' },
    { text: '真理只有一个，而谬误却有千千万万。', author: '笛卡尔' },
    { text: '我思故我在。', author: '笛卡尔' },
    {
      text: '生活中没有什么可怕的东西，只有需要理解的东西。',
      author: '居里夫人',
    },

    // 程序员/计算机名言
    { text: '简洁是智慧的灵魂，冗长是肤浅的修饰。', author: '莎士比亚' },
    {
      text: '程序必须首先为人类编写，其次才是为机器执行。',
      author: 'Abelson & Sussman',
    },
    { text: '过早优化是万恶之源。', author: 'Donald Knuth' },
    { text: '好的代码是它自己最好的文档。', author: 'Steve McConnell' },
    { text: '先让它工作，再让它正确，最后让它快速。', author: 'Kent Beck' },

    // 励志名言
    { text: '学而不思则罔，思而不学则殆。', author: '孔子' },
    { text: '路漫漫其修远兮，吾将上下而求索。', author: '屈原' },
    { text: '千里之行，始于足下。', author: '老子' },
    { text: '不积跬步，无以至千里。', author: '荀子' },
  ];

  var currentIndex = Math.floor(Math.random() * quotes.length);

  // 💡 刷新名言
  window.refreshQuote = function () {
    var quoteText = document.getElementById('quote-text');
    var quoteAuthor = document.getElementById('quote-author');

    if (!quoteText || !quoteAuthor) return;

    // 淡出动画
    quoteText.style.opacity = '0';
    quoteAuthor.style.opacity = '0';
    quoteText.style.transform = 'translateY(-10px)';
    quoteAuthor.style.transform = 'translateY(-10px)';

    setTimeout(function () {
      // 切换到下一条
      currentIndex = (currentIndex + 1) % quotes.length;
      var quote = quotes[currentIndex];

      quoteText.textContent = quote.text;
      quoteAuthor.textContent = '— ' + quote.author;

      // 淡入动画
      quoteText.style.opacity = '1';
      quoteAuthor.style.opacity = '1';
      quoteText.style.transform = 'translateY(0)';
      quoteAuthor.style.transform = 'translateY(0)';
    }, 300);
  };

  // 💡 初始化样式
  document.addEventListener('DOMContentLoaded', function () {
    var quoteText = document.getElementById('quote-text');
    var quoteAuthor = document.getElementById('quote-author');

    if (quoteText) {
      quoteText.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
    }
    if (quoteAuthor) {
      quoteAuthor.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
    }

    // 随机初始化一条名言
    var randomIndex = Math.floor(Math.random() * quotes.length);
    var quote = quotes[randomIndex];

    if (quoteText && quoteAuthor) {
      quoteText.textContent = quote.text;
      quoteAuthor.textContent = '— ' + quote.author;
    }
  });
})();
