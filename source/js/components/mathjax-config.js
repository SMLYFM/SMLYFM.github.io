/**
 * MathJax 高级配置增强
 * 💡 与 Butterfly 主题的 MathJax 加载器兼容
 * 💡 在 MathJax 加载后注入额外宏定义
 */

(function () {
  'use strict';

  // 💡 定义要添加的自定义宏
  const customMacros = {
    // ========================================
    // 数集符号
    // ========================================
    R: '\\mathbb{R}', // 实数
    N: '\\mathbb{N}', // 自然数
    Z: '\\mathbb{Z}', // 整数
    Q: '\\mathbb{Q}', // 有理数
    C: '\\mathbb{C}', // 复数

    // ========================================
    // 微分算子
    // ========================================
    dd: '\\mathrm{d}', // 微分符号
    diff: ['\\frac{\\mathrm{d} #1}{\\mathrm{d} #2}', 2], // 常微分
    pdv: ['\\frac{\\partial #1}{\\partial #2}', 2], // 偏微分
    dv: ['\\frac{\\mathrm{d} #1}{\\mathrm{d} #2}', 2], // 简写导数

    // ========================================
    // 向量微分算子
    // ========================================
    grad: '\\nabla', // 梯度
    divop: '\\nabla \\cdot', // 散度 (避免与 HTML div 冲突)
    curl: '\\nabla \\times', // 旋度
    laplacian: '\\nabla^2', // 拉普拉斯算子
    lapl: '\\Delta', // 拉普拉斯算子（另一种写法）

    // ========================================
    // 范数和内积
    // ========================================
    norm: ['\\left\\| #1 \\right\\|', 1], // 范数
    abs: ['\\left| #1 \\right|', 1], // 绝对值
    inner: ['\\left\\langle #1, #2 \\right\\rangle', 2], // 内积
    braket: ['\\left\\langle #1 \\middle| #2 \\right\\rangle', 2], // Dirac 记号

    // ========================================
    // 集合符号
    // ========================================
    set: ['\\left\\{ #1 \\right\\}', 1], // 集合
    setmid: ['\\left\\{ #1 \\,\\middle|\\, #2 \\right\\}', 2], // 条件集合

    // ========================================
    // 常用函数
    // ========================================
    argmax: '\\operatorname*{argmax}',
    argmin: '\\operatorname*{argmin}',
    sign: '\\operatorname{sign}',
    diag: '\\operatorname{diag}',
    trace: '\\operatorname{tr}',
    rank: '\\operatorname{rank}',
    spanop: '\\operatorname{span}', // 避免与 HTML span 冲突
    supp: '\\operatorname{supp}',

    // ========================================
    // 概率与统计
    // ========================================
    E: '\\mathbb{E}', // 期望
    Var: '\\operatorname{Var}', // 方差
    Cov: '\\operatorname{Cov}', // 协方差
    Prob: '\\mathbb{P}', // 概率

    // ========================================
    // 向量和矩阵
    // ========================================
    bm: ['\\boldsymbol{#1}', 1], // 粗体向量
    mat: ['\\mathbf{#1}', 1], // 矩阵
    vect: ['\\mathbf{#1}', 1], // 向量 (避免与 \vec 冲突)
    T: '^{\\mathsf{T}}', // 转置
    inv: '^{-1}', // 逆

    // ========================================
    // 收敛符号
    // ========================================
    pto: '\\xrightarrow{p}', // 依概率收敛
    dto: '\\xrightarrow{d}', // 依分布收敛
    asto: '\\xrightarrow{a.s.}', // 几乎必然收敛

    // ========================================
    // PDE/物理相关（使用唯一前缀避免冲突）
    // ========================================
    Dom: '\\Omega', // 计算域
    Bdy: '\\partial\\Omega', // 边界
    Loss: '\\mathcal{L}', // 损失函数
    DiffOp: '\\mathcal{N}', // 微分算子
    BcOp: '\\mathcal{B}', // 边界条件算子
  };

  /**
   * 💡 在 MathJax 完全加载后注入自定义宏
   * 使用事件监听确保不影响主题的 MathJax 加载流程
   */
  function injectMacros() {
    if (
      typeof MathJax !== 'undefined' &&
      MathJax.startup &&
      MathJax.startup.document
    ) {
      // 💡 MathJax 3.x 已加载，注入宏
      const inputJax = MathJax.startup.document.inputJax;
      if (inputJax && inputJax[0] && inputJax[0].configuration) {
        const macros = inputJax[0].configuration.macros || {};
        Object.assign(macros, customMacros);
        console.log('💡 MathJax 自定义宏已注入');
      }
    }
  }

  // 💡 监听 MathJax 加载完成事件
  document.addEventListener('DOMContentLoaded', function () {
    // 延迟执行以确保 MathJax 完全初始化
    setTimeout(injectMacros, 1000);
  });

  // 💡 为 PJAX 页面切换提供支持
  if (typeof btf !== 'undefined' && btf.addGlobalFn) {
    btf.addGlobalFn(
      'encrypt',
      function () {
        setTimeout(injectMacros, 500);
      },
      'mathjax-macros'
    );
  }

  console.log('💡 MathJax 宏配置模块已加载');
})();
