---
title: 集合论基础：ZFC 公理系统
date: 2026-01-25 03:03:00
updated: 2026-01-25 03:03:00
categories:
  - 数学
  - 分析学
tags:
  - 集合论
  - ZFC公理
  - 数学基础
  - 无穷
  - 选择公理
mathjax: true
description: 系统介绍 ZFC 集合论公理系统，包括所有公理的含义、序数基数理论以及选择公理的等价形式
cover: https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800
---

## 引言

集合论是现代数学的基础。几乎所有的数学对象都可以用集合来定义：数、函数、空间、结构等。ZFC（Zermelo-Fraenkel with Choice）公理系统是目前最广泛接受的集合论公理化体系。

<!-- more -->

## 1. ZFC 公理系统

ZFC 包含以下公理：

### 1.1 外延公理 (Axiom of Extensionality)

$$\forall A \, \forall B \, [\forall x (x \in A \leftrightarrow x \in B) \rightarrow A = B]$$

两个集合相等当且仅当它们有相同的元素。这个公理确定了集合的"身份"完全由其元素决定。

### 1.2 空集公理 (Axiom of Empty Set)

$$\exists \emptyset \, \forall x \, (x \notin \emptyset)$$

存在一个不包含任何元素的集合，称为空集 $\emptyset$。

### 1.3 配对公理 (Axiom of Pairing)

$$\forall a \, \forall b \, \exists C \, \forall x \, (x \in C \leftrightarrow x = a \lor x = b)$$

对于任意两个集合 $a$ 和 $b$，存在一个集合 $\{a, b\}$ 恰好包含它们。

### 1.4 并集公理 (Axiom of Union)

$$\forall A \, \exists B \, \forall x \, (x \in B \leftrightarrow \exists C (C \in A \land x \in C))$$

对于任意集合 $A$，存在其并集 $\bigcup A = \{x : \exists C \in A, x \in C\}$。

### 1.5 幂集公理 (Axiom of Power Set)

$$\forall A \, \exists P \, \forall B \, (B \in P \leftrightarrow B \subseteq A)$$

对于任意集合 $A$，存在其幂集 $\mathcal{P}(A) = \{B : B \subseteq A\}$。

### 1.6 无穷公理 (Axiom of Infinity)

$$\exists I \, [\emptyset \in I \land \forall x (x \in I \rightarrow x \cup \{x\} \in I)]$$

存在一个归纳集，即包含 $\emptyset$ 且对后继运算封闭的集合。这保证了自然数集的存在。

### 1.7 分离公理模式 (Axiom Schema of Separation)

$$\forall A \, \exists B \, \forall x \, (x \in B \leftrightarrow x \in A \land \varphi(x))$$

对于任意集合 $A$ 和性质 $\varphi$，存在子集 $\{x \in A : \varphi(x)\}$。

### 1.8 替换公理模式 (Axiom Schema of Replacement)

$$\forall A \, [\forall x \in A \, \exists ! y \, \varphi(x, y) \rightarrow \exists B \, \forall y \, (y \in B \leftrightarrow \exists x \in A \, \varphi(x, y))]$$

函数的像是集合。

### 1.9 正则公理 (Axiom of Regularity/Foundation)

$$\forall A \, [A \neq \emptyset \rightarrow \exists x \in A \, (x \cap A = \emptyset)]$$

每个非空集合都有一个 $\in$-极小元素。这排除了无穷下降链和 $A \in A$ 的情况。

### 1.10 选择公理 (Axiom of Choice, AC)

$$\forall A \, [\emptyset \notin A \rightarrow \exists f : A \to \bigcup A \, \forall B \in A \, (f(B) \in B)]$$

对于任意非空集合族，存在选择函数。

## 2. 序数理论

### 2.1 序数的定义

**定义**：一个集合 $\alpha$ 是**序数**（ordinal），如果：

1. $\alpha$ 是传递的：$x \in \alpha \Rightarrow x \subseteq \alpha$
2. $\alpha$ 被 $\in$ 良序

### 2.2 冯·诺依曼序数

冯·诺依曼构造：

- $0 = \emptyset$
- $1 = \{0\} = \{\emptyset\}$
- $2 = \{0, 1\} = \{\emptyset, \{\emptyset\}\}$
- $n + 1 = n \cup \{n\}$
- $\omega = \{0, 1, 2, 3, \ldots\}$（第一个无穷序数）

### 2.3 序数运算

**后继**：$\alpha + 1 = \alpha \cup \{\alpha\}$

**极限序数**：不是后继序数的序数，如 $\omega, \omega \cdot 2, \omega^2, \ldots$

**序数加法**：
$$\alpha + \beta = \text{type}(\alpha \sqcup \beta, <^*)$$
其中 $<^*$ 先按 $\alpha$ 再按 $\beta$ 排列。

注意：序数加法**不可交换**，如 $1 + \omega = \omega \neq \omega + 1$。

**序数乘法**：
$$\alpha \cdot \beta = \text{type}(\beta \times \alpha, <_{\text{lex}})$$

**序数指数**：
$$\alpha^0 = 1, \quad \alpha^{\beta+1} = \alpha^\beta \cdot \alpha, \quad \alpha^\lambda = \sup_{\beta < \lambda} \alpha^\beta$$

## 3. 基数理论

### 3.1 基数的定义

两个集合**等势**（equinumerous）如果存在双射：$|A| = |B| \Leftrightarrow A \approx B$。

**基数**是等势类的代表。在 ZFC 中，基数定义为：

$$|A| = \min\{\alpha : \alpha \text{ 是序数} \land \alpha \approx A\}$$

### 3.2 阿列夫数

无穷基数用 $\aleph$（aleph）表示：

- $\aleph_0 = |\mathbb{N}|$（最小无穷基数）
- $\aleph_1$ = 最小不可数基数
- $\aleph_{\alpha+1}$ = $\aleph_\alpha$ 的后继基数
- $\aleph_\lambda = \sup_{\alpha < \lambda} \aleph_\alpha$（极限情形）

### 3.3 基数运算

**加法**：$\kappa + \lambda = |\{0\} \times \kappa \cup \{1\} \times \lambda|$

**乘法**：$\kappa \cdot \lambda = |\kappa \times \lambda|$

**指数**：$\kappa^\lambda = |{}^\lambda\kappa|$（从 $\lambda$ 到 $\kappa$ 的函数集）

重要结果：

- 康托尔定理：$|A| < |\mathcal{P}(A)|$
- $2^{\aleph_0} = |\mathbb{R}|$（连续统的基数）

### 3.4 连续统假设

**连续统假设（CH）**：$2^{\aleph_0} = \aleph_1$

即不存在基数严格介于 $\aleph_0$ 和 $2^{\aleph_0}$ 之间。

**广义连续统假设（GCH）**：对所有序数 $\alpha$，$2^{\aleph_\alpha} = \aleph_{\alpha+1}$

**哥德尔-科恩定理**：CH 独立于 ZFC。

- 哥德尔（1940）：CH 与 ZFC 相容
- 科恩（1963）：$\neg$CH 与 ZFC 相容

## 4. 选择公理及其等价形式

### 4.1 等价命题

以下命题在 ZF 中相互等价：

| 命题 | 陈述 |
| ------ | ------ |
| 选择公理 (AC) | 非空集合族有选择函数 |
| 佐恩引理 | 每个归纳偏序集有极大元 |
| 良序定理 | 每个集合可以良序化 |
| 图凯引理 | 有限特征的集合系统有极大元 |
| 豪斯多夫极大原理 | 每个偏序集有极大链 |

### 4.2 依赖于 AC 的定理

许多重要定理依赖于选择公理：

1. **代数**：每个向量空间有基
2. **分析**：非零测集存在不可测子集
3. **拓扑**：Tychonoff 定理（紧空间的任意乘积是紧的）
4. **代数**：每个环有极大理想

### 4.3 不依赖 AC 的选择

某些特殊情况不需要 AC：

- 有限集族（归纳法）
- 可数良序集族
- 有显式选择规则的集合

## 5. 大基数公理

### 5.1 不可达基数

基数 $\kappa$ 是**不可达的**（inaccessible），如果：

1. $\kappa$ 是不可数的
2. $\kappa$ 是正则的（共尾数等于自身）
3. 对所有 $\lambda < \kappa$，有 $2^\lambda < \kappa$

**定理**：如果存在不可达基数，则 ZFC + "不存在不可达基数" 是相容的。因此，不可达基数的存在性在 ZFC 中不可证。

### 5.2 大基数层次

从弱到强：

1. 不可达基数
2. Mahlo 基数
3. 可测基数
4. 强基数
5. 超紧基数
6. huge 基数

大基数提供了一致性证明的工具，并揭示了集合论宇宙的丰富结构。

## 6. 集合论模型

### 6.1 哥德尔的构造宇宙

**构造宇宙 $L$**：

- $L_0 = \emptyset$
- $L_{\alpha+1} = \text{Def}(L_\alpha)$（$L_\alpha$ 中可定义的子集）
- $L_\lambda = \bigcup_{\alpha < \lambda} L_\alpha$
- $L = \bigcup_\alpha L_\alpha$

**性质**：在 $L$ 中，GCH 和 AC 都成立。

### 6.2 力迫法

科恩的力迫法（forcing）是构造 ZFC 模型的强大工具：

1. 从一个基础模型 $M$ 开始
2. 选择偏序集 $\mathbb{P} \in M$
3. 选择"通用"filter $G \subseteq \mathbb{P}$
4. 构造扩展模型 $M[G]$

这个技术可以证明 CH、AC 等命题的独立性。

## 总结

ZFC 集合论为现代数学提供了坚实的基础：

1. **公理系统**：九条公理加选择公理，足以建立几乎所有数学
2. **序数**：良序集的规范表示，超穷归纳的基础
3. **基数**：集合大小的精确刻画
4. **选择公理**：许多重要定理的必要前提
5. **独立性结果**：CH、AC 等命题独立于 ZFC

集合论不仅是数学的语言，也是数学哲学的核心研究对象。

## 参考资料

- Kunen, K. _Set Theory: An Introduction to Independence Proofs_, 1980
- Jech, T. _Set Theory_, 3rd ed., 2003
- Enderton, H. _Elements of Set Theory_, 1977
- [Stanford Encyclopedia - Set Theory](https://plato.stanford.edu/entries/set-theory/)
