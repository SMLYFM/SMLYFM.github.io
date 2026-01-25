/**
 * KaTeX 自定义宏配置
 * 💡 为博客 LaTeX 公式提供常用宏定义
 * 💡 配合 hexo-renderer-markdown-it + @neilsustc/markdown-it-katex 使用
 */

(function () {
  'use strict';

  // 💡 检测 KaTeX 并注入自定义宏
  function setupKatexMacros() {
    if (typeof katex === 'undefined') {
      // KaTeX 尚未加载,稍后重试
      setTimeout(setupKatexMacros, 100);
      return;
    }

    // 💡 定义自定义宏
    const customMacros = {
      // ========================================
      // 数集符号
      // ========================================
      '\\R': '\\mathbb{R}', // 实数
      '\\N': '\\mathbb{N}', // 自然数
      '\\Z': '\\mathbb{Z}', // 整数
      '\\Q': '\\mathbb{Q}', // 有理数
      '\\C': '\\mathbb{C}', // 复数
      '\\F': '\\mathbb{F}', // 域

      // ========================================
      // 微分算子
      // ========================================
      '\\dd': '\\mathrm{d}', // 微分符号
      '\\pdv': '\\frac{\\partial #1}{\\partial #2}', // 偏导数
      '\\dv': '\\frac{\\mathrm{d} #1}{\\mathrm{d} #2}', // 常导数
      '\\grad': '\\nabla', // 梯度
      '\\divop': '\\nabla \\cdot', // 散度
      '\\curl': '\\nabla \\times', // 旋度
      '\\lapl': '\\Delta', // 拉普拉斯算子

      // ========================================
      // 范数和内积
      // ========================================
      '\\norm': '\\left\\| #1 \\right\\|', // 范数
      '\\abs': '\\left| #1 \\right|', // 绝对值
      '\\inner': '\\left\\langle #1, #2 \\right\\rangle', // 内积
      '\\bra': '\\left\\langle #1 \\right|', // Dirac bra
      '\\ket': '\\left| #1 \\right\\rangle', // Dirac ket
      '\\braket': '\\left\\langle #1 | #2 \\right\\rangle', // Dirac braket

      // ========================================
      // 集合符号
      // ========================================
      '\\set': '\\left\\{ #1 \\right\\}', // 集合
      '\\setmid': '\\left\\{ #1 \\,\\middle|\\, #2 \\right\\}', // 条件集合

      // ========================================
      // 常用函数
      // ========================================
      '\\argmax': '\\operatorname*{arg\\,max}',
      '\\argmin': '\\operatorname*{arg\\,min}',
      '\\sign': '\\operatorname{sign}',
      '\\diag': '\\operatorname{diag}',
      '\\tr': '\\operatorname{tr}',
      '\\rank': '\\operatorname{rank}',
      '\\spanop': '\\operatorname{span}',
      '\\supp': '\\operatorname{supp}',
      '\\dom': '\\operatorname{dom}',
      '\\range': '\\operatorname{range}',

      // ========================================
      // 概率与统计
      // ========================================
      '\\E': '\\mathbb{E}', // 期望
      '\\Var': '\\operatorname{Var}', // 方差
      '\\Cov': '\\operatorname{Cov}', // 协方差
      '\\Prob': '\\mathbb{P}', // 概率
      '\\iid': '\\stackrel{\\text{iid}}{\\sim}', // 独立同分布

      // ========================================
      // 向量和矩阵
      // ========================================
      '\\bm': '\\boldsymbol{#1}', // 粗体向量
      '\\mat': '\\mathbf{#1}', // 矩阵
      '\\vect': '\\vec{#1}', // 向量箭头
      '\\T': '^{\\mathsf{T}}', // 转置
      '\\inv': '^{-1}', // 逆
      '\\pinv': '^{\\dagger}', // 伪逆

      // ========================================
      // PDE/物理相关
      // ========================================
      '\\Dom': '\\Omega', // 计算域
      '\\Bdy': '\\partial\\Omega', // 边界
      '\\Loss': '\\mathcal{L}', // 损失函数
      '\\DiffOp': '\\mathcal{N}', // 微分算子
      '\\BcOp': '\\mathcal{B}', // 边界条件算子

      // ========================================
      // 收敛符号
      // ========================================
      '\\pto': '\\xrightarrow{p}', // 依概率收敛
      '\\dto': '\\xrightarrow{d}', // 依分布收敛
      '\\asto': '\\xrightarrow{a.s.}', // 几乎必然收敛
    };

    // 💡 将宏存储到全局,供其他脚本使用
    window.katexCustomMacros = customMacros;

    console.log(
      '💡 KaTeX 自定义宏已配置',
      Object.keys(customMacros).length,
      '个'
    );
  }

  // 页面加载后初始化
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', setupKatexMacros);
  } else {
    setupKatexMacros();
  }

  // 💡 为 PJAX 页面切换提供支持
  if (typeof btf !== 'undefined' && btf.addGlobalFn) {
    btf.addGlobalFn('encrypt', setupKatexMacros, 'katex-macros');
  }
})();
