---
title: 实分析中的勒贝格测度理论
date: 2026-01-15 09:00:00
updated: 2026-01-25 02:15:00
categories:
  - 数学
  - 实分析
tags:
  - 测度论
  - 勒贝格积分
  - 实分析
  - 数学基础
description: 深入探讨勒贝格测度的构造方法及其在现代分析中的应用
mathjax: true
---

# 实分析中的勒贝格测度理论

勒贝格测度是现代分析学的基石，为积分理论提供了坚实的基础。本文将系统介绍测度论的核心概念。

## 1. 测度的基本概念

### 1.1 σ-代数

设 $X$ 为非空集合，$\mathcal{F} \subseteq \mathcal{P}(X)$ 称为 **σ-代数**，若满足：

1. $X \in \mathcal{F}$
2. **补封闭**：若 $A \in \mathcal{F}$，则 $A^c \in \mathcal{F}$
3. **可数并封闭**：若 $\{A_n\}_{n=1}^\infty \subseteq \mathcal{F}$，则 $\bigcup_{n=1}^\infty A_n \in \mathcal{F}$

$(X, \mathcal{F})$ 称为**可测空间**。

### 1.2 测度的定义

设 $(X, \mathcal{F})$ 为可测空间，函数 $\mu: \mathcal{F} \to [0, \infty]$ 称为**测度**，若满足：

1. **非负性**：$\mu(A) \geq 0$，$\forall A \in \mathcal{F}$
2. **空集测度为零**：$\mu(\emptyset) = 0$
3. **可数可加性**：若 $\{A_n\}_{n=1}^\infty$ 两两不相交，则

$$
\mu\left(\bigcup_{n=1}^\infty A_n\right) = \sum_{n=1}^\infty \mu(A_n)
$$

三元组 $(X, \mathcal{F}, \mu)$ 称为**测度空间**。

---

## 2. 勒贝格测度的构造

### 2.1 外测度方法

**外测度**定义：对于 $E \subseteq \mathbb{R}$，定义

$$
\mu^*(E) = \inf \left\{ \sum_{n=1}^\infty \ell(I_n) : E \subseteq \bigcup_{n=1}^\infty I_n, \, I_n \text{ 为开区间} \right\}
$$

其中 $\ell((a, b)) = b - a$ 为区间长度。

**外测度性质**：

1. $\mu^*(\emptyset) = 0$
2. 单调性：$A \subseteq B \Rightarrow \mu^*(A) \leq \mu^*(B)$
3. 次可加性：$\mu^*\left(\bigcup_{n=1}^\infty A_n\right) \leq \sum_{n=1}^\infty \mu^*(A_n)$

### 2.2 Carathéodory 可测性

集合 $E$ 称为 **Carathéodory 可测**的（或勒贝格可测的），若对任意 $A \subseteq \mathbb{R}$：

$$
\mu^*(A) = \mu^*(A \cap E) + \mu^*(A \cap E^c)
$$

**定理**：所有勒贝格可测集构成 σ-代数 $\mathcal{L}$，外测度限制在 $\mathcal{L}$ 上是完备测度。

### 2.3 Borel 集与勒贝格集

$$
\text{开集} \subseteq \mathcal{B}(\mathbb{R}) \subseteq \mathcal{L}
$$

其中 $\mathcal{B}(\mathbb{R})$ 是由开集生成的 σ-代数（Borel σ-代数），包含关系严格。

---

## 3. Cantor 集与测度零集

### 3.1 Cantor 集的构造

从 $[0, 1]$ 开始，迭代地删除每个区间的中间 $\frac{1}{3}$：

$$
C_0 = [0, 1]
$$
$$
C_1 = \left[0, \frac{1}{3}\right] \cup \left[\frac{2}{3}, 1\right]
$$
$$
C_2 = \left[0, \frac{1}{9}\right] \cup \left[\frac{2}{9}, \frac{1}{3}\right] \cup \left[\frac{2}{3}, \frac{7}{9}\right] \cup \left[\frac{8}{9}, 1\right]
$$

**Cantor 集**：$C = \bigcap_{n=0}^\infty C_n$

### 3.2 Cantor 集的性质

1. **闭集**：$C$ 是闭集
2. **无处稠密**：$C$ 不包含任何开区间
3. **不可数**：$C$ 与 $[0, 1]$ 等势（可用三进制表示证明）
4. **测度为零**：

$$
\mu(C) = \lim_{n \to \infty} \mu(C_n) = \lim_{n \to \infty} \left(\frac{2}{3}\right)^n = 0
$$

> Cantor 集展示了"不可数但测度为零"的奇特现象。

---

## 4. 勒贝格积分

### 4.1 简单函数

设 $(X, \mathcal{F}, \mu)$ 为测度空间，**简单函数**是形如

$$
s(x) = \sum_{i=1}^n a_i \chi_{A_i}(x)
$$

的函数，其中 $a_i \geq 0$，$A_i \in \mathcal{F}$，$\chi_{A_i}$ 是特征函数。

**简单函数的积分**：

$$
\int_X s \, d\mu = \sum_{i=1}^n a_i \mu(A_i)
$$

### 4.2 一般非负函数的积分

对于可测函数 $f: X \to [0, \infty]$：

$$
\int_X f \, d\mu = \sup \left\{ \int_X s \, d\mu : 0 \leq s \leq f, \, s \text{ 为简单函数} \right\}
$$

### 4.3 重要收敛定理

#### 单调收敛定理 (MCT)

若 $0 \leq f_1 \leq f_2 \leq \cdots$ 且 $f_n \to f$ 点点收敛，则

$$
\lim_{n \to \infty} \int_X f_n \, d\mu = \int_X f \, d\mu
$$

#### 控制收敛定理 (DCT)

若 $f_n \to f$ 点点收敛，且存在可积函数 $g$ 使得 $|f_n| \leq g$，则

$$
\lim_{n \to \infty} \int_X f_n \, d\mu = \int_X f \, d\mu
$$

---

## 5. L^p 空间的完备性

### 5.1 定义

$$
L^p(\Omega) = \left\{ f : \Omega \to \mathbb{R} \,\middle|\, \|f\|_p = \left(\int_\Omega |f|^p \, d\mu\right)^{1/p} < \infty \right\}
$$

### 5.2 Riesz-Fischer 定理

**定理**：对于 $1 \leq p \leq \infty$，$L^p(\Omega)$ 是 Banach 空间。

**证明思路**（$1 \leq p < \infty$）：

1. 取 Cauchy 列 $\{f_n\}$
2. 构造快速收敛子列
3. 证明点点收敛到某 $f$
4. 利用 Fatou 引理证明 $f \in L^p$
5. 证明 $\|f_n - f\|_p \to 0$

---

## 6. 应用

勒贝格测度和积分在多个领域有核心应用：

| 领域 | 应用 |
|------|------|
| 概率论 | Kolmogorov 公理化基础 |
| 偏微分方程 | Sobolev 空间理论 |
| 泛函分析 | $L^p$ 空间、算子理论 |
| 调和分析 | Fourier 变换、Plancherel 定理 |

---

## 参考文献

1. Rudin, W. *Real and Complex Analysis*
2. Folland, G.B. *Real Analysis: Modern Techniques and Applications*
3. Stein, E.M. & Shakarchi, R. *Real Analysis: Measure Theory, Integration, and Hilbert Spaces*
