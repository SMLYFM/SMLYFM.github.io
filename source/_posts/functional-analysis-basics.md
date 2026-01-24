---
title: 泛函分析基础：Banach 空间与 Hilbert 空间
date: 2026-01-18 16:00:00
updated: 2026-01-25 02:15:00
categories:
  - 数学
  - 泛函分析
tags:
  - 泛函分析
  - Banach空间
  - Hilbert空间
  - 算子理论
description: 系统介绍泛函分析中的两大基础空间理论及其性质
mathjax: true
---

# 泛函分析基础：Banach 空间与 Hilbert 空间

泛函分析是现代数学的重要分支，为偏微分方程、量子力学等提供理论基础。本文将系统介绍两大核心空间。

## 1. Banach 空间

### 1.1 定义

设 $X$ 为实（或复）线性空间，若存在函数 $\|\cdot\|: X \to [0, \infty)$ 满足：

1. **正定性**：$\|x\| = 0 \Leftrightarrow x = 0$
2. **齐次性**：$\|\alpha x\| = |\alpha| \|x\|$，$\forall \alpha \in \mathbb{K}, x \in X$
3. **三角不等式**：$\|x + y\| \leq \|x\| + \|y\|$

则称 $(X, \|\cdot\|)$ 为**赋范线性空间**。若 $(X, \|\cdot\|)$ 关于由范数诱导的度量完备，则称其为 **Banach 空间**。

### 1.2 典型例子

#### $L^p$ 空间

设 $(\Omega, \mathcal{F}, \mu)$ 为测度空间，定义

$$
L^p(\Omega) = \left\{ f: \Omega \to \mathbb{R} \,\middle|\, \|f\|_p := \left( \int_\Omega |f|^p \, d\mu \right)^{1/p} < \infty \right\}
$$

其中 $1 \leq p < \infty$。由 **Riesz-Fischer 定理**，$L^p$ 空间是完备的。

#### $\ell^p$ 序列空间

$$
\ell^p = \left\{ (x_n)_{n=1}^\infty \,\middle|\, \sum_{n=1}^\infty |x_n|^p < \infty \right\}
$$

### 1.3 重要定理

#### 开映射定理 (Open Mapping Theorem)

设 $X, Y$ 为 Banach 空间，$T: X \to Y$ 为有界线性算子且为满射，则 $T$ 为开映射。

#### 闭图像定理 (Closed Graph Theorem)

设 $X, Y$ 为 Banach 空间，$T: X \to Y$ 为线性算子。若 $T$ 的图像

$$
\Gamma(T) = \{(x, Tx) : x \in X\} \subseteq X \times Y
$$

在乘积拓扑下是闭集，则 $T$ 有界。

---

## 2. Hilbert 空间

### 2.1 定义

设 $H$ 为复线性空间，若存在内积 $\langle \cdot, \cdot \rangle: H \times H \to \mathbb{C}$ 满足：

1. **共轭对称性**：$\langle x, y \rangle = \overline{\langle y, x \rangle}$
2. **第一变元线性**：$\langle \alpha x + \beta y, z \rangle = \alpha \langle x, z \rangle + \beta \langle y, z \rangle$
3. **正定性**：$\langle x, x \rangle \geq 0$，等号当且仅当 $x = 0$

则称 $(H, \langle \cdot, \cdot \rangle)$ 为**内积空间**。若 $H$ 关于由内积诱导的范数

$$
\|x\| = \sqrt{\langle x, x \rangle}
$$

完备，则称 $H$ 为 **Hilbert 空间**。

### 2.2 重要性质

#### 平行四边形恒等式

$$
\|x + y\|^2 + \|x - y\|^2 = 2(\|x\|^2 + \|y\|^2)
$$

这是 Hilbert 空间的特征性质，Banach 空间不一定满足。

#### 正交分解定理

设 $M$ 为 Hilbert 空间 $H$ 的闭子空间，则

$$
H = M \oplus M^\perp
$$

其中 $M^\perp = \{x \in H : \langle x, m \rangle = 0, \forall m \in M\}$。

### 2.3 典型例子

#### $L^2$ 空间

$$
L^2(\Omega) = \left\{ f: \Omega \to \mathbb{C} \,\middle|\, \int_\Omega |f|^2 \, d\mu < \infty \right\}
$$

内积定义为 $\langle f, g \rangle = \int_\Omega f \overline{g} \, d\mu$。

#### $\ell^2$ 序列空间

$$
\ell^2 = \left\{ (x_n) \,\middle|\, \sum_{n=1}^\infty |x_n|^2 < \infty \right\}
$$

内积定义为 $\langle x, y \rangle = \sum_{n=1}^\infty x_n \overline{y_n}$。

---

## 3. Banach 空间与 Hilbert 空间的关系

> Hilbert 空间是特殊的 Banach 空间

| 性质 | Banach 空间 | Hilbert 空间 |
|------|-------------|--------------|
| 范数结构 | ✅ | ✅ |
| 内积结构 | ❌ | ✅ |
| 平行四边形恒等式 | 不一定 | ✅ |
| 正交分解 | 不一定 | ✅ |

---

## 4. 参考文献

1. Rudin, W. *Functional Analysis*
2. Conway, J.B. *A Course in Functional Analysis*
3. Kreyszig, E. *Introductory Functional Analysis with Applications*
