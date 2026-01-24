---
title: LaTeX数学公式排版指南
date: 2026-01-25 01:27:00
updated: 2026-01-25 01:27:00
categories:
  - 工具与写作
  - LaTeX
tags:
  - LaTeX
  - 数学排版
  - 学术写作
mathjax: true
---

## 简介

LaTeX 是学术界最常用的排版系统，尤其擅长数学公式的排版。本文介绍 LaTeX 数学公式的基本用法。

<!-- more -->

## 行内公式

使用 `$...$` 包裹行内公式：

爱因斯坦质能方程 $E = mc^2$ 是物理学中最著名的公式之一。

## 行间公式

使用 `$$...$$` 或 `\[...\]` 包裹行间公式：

$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$

## 常用符号

### 希腊字母

| 符号 | 代码 | 符号 | 代码 |
|------|------|------|------|
| $\alpha$ | `\alpha` | $\beta$ | `\beta` |
| $\gamma$ | `\gamma` | $\delta$ | `\delta` |
| $\epsilon$ | `\epsilon` | $\theta$ | `\theta` |

### 运算符

$$\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$$

$$\prod_{i=1}^{n} i = n!$$

## 矩阵

```latex
\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}
```

$$\begin{pmatrix} a & b \\ c & d \end{pmatrix}$$

## 分段函数

$$f(x) = \begin{cases}
x^2 & \text{if } x \geq 0 \\
-x^2 & \text{if } x < 0
\end{cases}$$

## 总结

LaTeX 数学排版功能强大，是撰写学术论文的必备技能。

## 参考资料

- [LaTeX Mathematics Wiki](https://en.wikibooks.org/wiki/LaTeX/Mathematics)
