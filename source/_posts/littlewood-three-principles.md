---
title: Littlewood 三性原理与实分析中的逼近定理
date: 2026-01-25 18:55:00
updated: 2026-01-25 19:12:00
categories:
  - 数学
  - 实分析
tags:
  - 实分析
  - 测度论
  - Littlewood
  - Egoroff定理
  - Lusin定理
description: 深入探讨 Littlewood 三性原理,并给出 Egoroff 定理和 Lusin 定理的完整证明
mathjax: true
katex: true
---

# Littlewood 三性原理与实分析中的逼近定理

在实分析和测度论中,**Littlewood 三性原理**(Littlewood's Three Principles)是理解可测集和可测函数行为的重要指导思想。本文将详细阐述这三条原理,并给出 **Egoroff 定理**和 **Lusin 定理**的完整证明。

## 1. Littlewood 三性原理

英国数学家 **John Edensor Littlewood**(1885-1977)曾精辟地总结了实分析中可测集和可测函数的三条基本性质:

{% note info flat %}
**Littlewood 三性原理**

**第一性原理(可测集的正则性)**: 每一个可测集"几乎"是有限个开区间的并集。

**第二性原理(可测函数的连续性)**: 每一个可测函数"几乎"是连续函数。

**第三性原理(收敛的一致性)**: 每一个几乎处处收敛的函数列"几乎"是一致收敛的。
{% endnote %}

这里的"几乎"需要精确化,它通过以下三个著名定理来实现:

| 性原理 | 精确表述 |
| ------- | --------- |
| 第一性原理 | 可测集的正则性定理 |
| 第二性原理 | **Lusin 定理** |
| 第三性原理 | **Egoroff 定理** |

---

## 2. 预备知识

### 2.1 基本记号

设 $(X, \mathcal{M}, \mu)$ 是一个测度空间。特别地,当 $X = \mathbb{R}^n$,$\mu$ 为 Lebesgue 测度时,记为 $m$。

- $E \subset \mathbb{R}^n$ 可测: $E \in \mathcal{M}$
- $m(E)$: 集合 $E$ 的 Lebesgue 测度
- $f: E \to \mathbb{R}$ 可测: $f^{-1}(O)$ 对任意开集 $O$ 可测

### 2.2 几乎处处收敛

{% note primary flat %}
**定义 (几乎处处收敛)**

设 $\{f_n\}$ 是 $E$ 上的可测函数列,$f$ 是 $E$ 上的可测函数。称 $f_n$ **几乎处处收敛**到 $f$,记作 $f_n \to f$ a.e.,若存在零测集 $N \subset E$,使得对所有 $x \in E \setminus N$,有 $\lim_{n \to \infty} f_n(x) = f(x)$。
{% endnote %}

---

## 3. Egoroff 定理

### 3.1 定理陈述

{% note success flat %}
**定理 3.1 (Egoroff, 1911)**

设 $E \subset \mathbb{R}^n$ 是测度有限的可测集($m(E) < \infty$),$\{f_n\}$ 是 $E$ 上的可测函数列,且 $f_n \to f$ a.e. 于 $E$。则对任意 $\varepsilon > 0$,存在闭集 $F \subset E$,使得:

1. $m(E \setminus F) < \varepsilon$
2. $f_n \rightrightarrows f$ 在 $F$ 上一致收敛
{% endnote %}

{% note warning flat %}
**注记**: 条件 $m(E) < \infty$ 是必要的。反例:在 $\mathbb{R}$ 上取 $f_n(x) = \chi_{[n, \infty)}(x)$,则 $f_n \to 0$ 处处成立,但在任何正测度集上都不一致收敛。
{% endnote %}

### 3.2 证明

**Step 1: 构造递减集列**

不妨设 $f_n \to f$ 处处成立于 $E$(否则去掉一个零测集)。

对每个正整数 $k$ 和 $n$,定义:

$$
E_n^{(k)} = \bigcup_{j=n}^{\infty} \left\{ x \in E : |f_j(x) - f(x)| \geq \frac{1}{k} \right\}
$$

由于 $f_n, f$ 可测,集合 $\{x : |f_j(x) - f(x)| \geq 1/k\}$ 可测,从而 $E_n^{(k)}$ 可测。

**Step 2: 分析集列的性质**

对固定的 $k$:

- $E_1^{(k)} \supset E_2^{(k)} \supset E_3^{(k)} \supset \cdots$ (递减)
- 由于 $f_n \to f$ 处处,对任意 $x \in E$,存在 $N$ 使得当 $n \geq N$ 时 $|f_n(x) - f(x)| < 1/k$

因此:

$$
\bigcap_{n=1}^{\infty} E_n^{(k)} = \emptyset
$$

**Step 3: 应用测度的连续性**

由于 $m(E) < \infty$ 且 $E_n^{(k)} \searrow \emptyset$,由测度的上连续性:

$$
\lim_{n \to \infty} m(E_n^{(k)}) = m\left(\bigcap_{n=1}^{\infty} E_n^{(k)}\right) = 0
$$

因此,对给定的 $\varepsilon > 0$ 和每个 $k$,存在 $n_k$ 使得:

$$
m(E_{n_k}^{(k)}) < \frac{\varepsilon}{2^k}
$$

**Step 4: 构造一致收敛的集合**

令:

$$
A = \bigcup_{k=1}^{\infty} E_{n_k}^{(k)}
$$

则:

$$
m(A) \leq \sum_{k=1}^{\infty} m(E_{n_k}^{(k)}) < \sum_{k=1}^{\infty} \frac{\varepsilon}{2^k} = \varepsilon
$$

**Step 5: 验证一致收敛**

令 $F_0 = E \setminus A$。对任意 $\delta > 0$,取 $k$ 使得 $1/k < \delta$。

若 $x \in F_0$,则 $x \notin E_{n_k}^{(k)}$,即对所有 $j \geq n_k$:

$$
|f_j(x) - f(x)| < \frac{1}{k} < \delta
$$

这说明 $f_n \rightrightarrows f$ 在 $F_0$ 上一致收敛。

**Step 6: 闭集的逼近**

由可测集的正则性,存在闭集 $F \subset F_0$ 使得 $m(F_0 \setminus F) < \varepsilon$。则:

$$
m(E \setminus F) = m(A) + m(F_0 \setminus F) < 2\varepsilon
$$

将 $\varepsilon$ 替换为 $\varepsilon/2$ 即得结论。$\square$

---

## 4. Lusin 定理

### 4.1 定理陈述

{% note success flat %}
**定理 4.1 (Lusin, 1912)**

设 $E \subset \mathbb{R}^n$ 是可测集,$m(E) < \infty$,$f: E \to \mathbb{R}$ 是可测函数且几乎处处有限。则对任意 $\varepsilon > 0$,存在闭集 $F \subset E$ 使得:

1. $m(E \setminus F) < \varepsilon$
2. $f|_F$ 是连续函数(即 $f$ 在 $F$ 上的限制连续)
{% endnote %}

{% note warning flat %}
**注记**: Lusin 定理可以加强为:存在 $\mathbb{R}^n$ 上的连续函数 $g$ 使得 $g|_F = f|_F$,且 $\sup|g| \leq \sup|f|$(Tietze 延拓定理)。
{% endnote %}

### 4.2 证明

**Step 1: 简单函数的逼近**

由可测函数的简单函数逼近定理,存在简单函数列 $\{\varphi_n\}$ 使得:

$$
\varphi_n \to f \quad \text{a.e. 于 } E
$$

**Step 2: 应用 Egoroff 定理**

由 Egoroff 定理,存在闭集 $F_1 \subset E$ 使得:

- $m(E \setminus F_1) < \varepsilon/2$
- $\varphi_n \rightrightarrows f$ 在 $F_1$ 上一致收敛

**Step 3: 简单函数在闭子集上的连续性**

设简单函数 $\varphi_n = \sum_{i=1}^{k_n} a_i^{(n)} \chi_{A_i^{(n)}}$,其中 $\{A_i^{(n)}\}$ 是 $E$ 的可测分割。

对每个 $n$ 和 $i$,由可测集的正则性,存在闭集 $B_i^{(n)} \subset A_i^{(n)} \cap F_1$ 使得:

$$
m\left((A_i^{(n)} \cap F_1) \setminus B_i^{(n)}\right) < \frac{\varepsilon}{2^{n+1} k_n}
$$

令:

$$
F_n = \bigcup_{i=1}^{k_n} B_i^{(n)}
$$

则 $F_n$ 是 $F_1$ 中的闭集,且:

$$
m(F_1 \setminus F_n) < \frac{\varepsilon}{2^{n+1}}
$$

**关键观察**: $\varphi_n|_{F_n}$ 在 $F_n$ 上连续!

因为 $F_n$ 是互不相交闭集的有限并,$\varphi_n$ 在每个 $B_i^{(n)}$ 上取常数值。

**Step 4: 取交集**

令:

$$
F = \bigcap_{n=1}^{\infty} F_n
$$

则 $F$ 是闭集,且:

$$
m(F_1 \setminus F) \leq \sum_{n=1}^{\infty} m(F_1 \setminus F_n) < \sum_{n=1}^{\infty} \frac{\varepsilon}{2^{n+1}} = \frac{\varepsilon}{2}
$$

因此:

$$
m(E \setminus F) = m(E \setminus F_1) + m(F_1 \setminus F) < \frac{\varepsilon}{2} + \frac{\varepsilon}{2} = \varepsilon
$$

**Step 5: 验证 $f|_F$ 的连续性**

在 $F$ 上:

- 每个 $\varphi_n|_F$ 连续(因为 $F \subset F_n$)
- $\varphi_n \rightrightarrows f$ 一致收敛(因为 $F \subset F_1$)

由一致收敛保持连续性,$f|_F$ 在 $F$ 上连续。$\square$

---

## 5. 三性原理的统一视角

Littlewood 三性原理揭示了测度论中"可测"对象与"良好"对象之间的深刻联系:

| 对象 | "坏"的性质 | "近似良好"的性质 |
| ----- | ----------- | ---------------- |
| 可测集 | 可能非常复杂 | 可用开集/闭集逼近 |
| 可测函数 | 可能处处不连续 | 在大部分地方连续 (Lusin) |
| a.e. 收敛 | 不保证一致性 | 在大部分地方一致 (Egoroff) |

### 5.1 应用示例

**应用 1**: Riemann-Lebesgue 引理的证明

**应用 2**: $L^p$ 空间中连续函数的稠密性

**应用 3**: Fourier 级数收敛性的研究

---

## 6. 小结

| 定理 | 条件 | 结论 |
| ----- | ------ | ------ |
| **Egoroff** | $m(E) < \infty$, $f_n \to f$ a.e. | 存在闭集 $F$ 使 $m(E \setminus F) < \varepsilon$, $f_n \rightrightarrows f$ 在 $F$ 上一致 |
| **Lusin** | $m(E) < \infty$, $f$ 可测有限 | 存在闭集 $F$ 使 $m(E \setminus F) < \varepsilon$, $f$ 在 $F$ 上连续 |

{% note info flat %}
**历史注记**

- **Dmitri Egoroff** (1869-1931): 俄国数学家,1911年发表了关于收敛函数列的著名定理。
- **Nikolai Lusin** (1883-1950): 俄国数学家,Egoroff 的学生,Moscow 学派的创始人之一。
- **John Littlewood** (1885-1977): 英国数学家,与 Hardy 长期合作,对分析学有深远影响。
{% endnote %}

---

## 参考文献

1. Royden, H. L., & Fitzpatrick, P. M. (2010). _Real Analysis_. Pearson.
2. Folland, G. B. (1999). _Real Analysis: Modern Techniques and Their Applications_. Wiley.
3. Rudin, W. (1987). _Real and Complex Analysis_. McGraw-Hill.
