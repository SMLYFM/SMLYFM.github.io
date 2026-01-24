---
title: 几何代数入门：Clifford 代数
date: 2026-01-25 03:04:00
updated: 2026-01-25 03:04:00
categories:
  - 数学
  - 分析学
tags:
  - 几何代数
  - Clifford代数
  - 外积
  - 旋转
  - 物理数学
mathjax: true
description: 介绍几何代数（Clifford 代数）的基本概念，包括几何积、多重向量、旋转子以及在物理中的应用
cover: https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800
---

## 引言

几何代数（Geometric Algebra，GA）是一种统一的数学语言，能够优雅地处理向量、旋转、投影等几何对象。它由 William Clifford 在 19 世纪提出，结合了格拉斯曼的外代数和哈密顿的四元数思想。

<!-- more -->

## 1. 从向量到几何代数

### 1.1 传统向量代数的局限

传统向量代数有两种乘法：

- **点积**：$\mathbf{a} \cdot \mathbf{b} = |\mathbf{a}||\mathbf{b}|\cos\theta$（标量）
- **叉积**：$\mathbf{a} \times \mathbf{b}$（仅在 3D 有定义，是伪向量）

问题：

1. 叉积不能推广到任意维度
2. 无法统一处理不同类型的几何对象
3. 旋转表示不够自然

### 1.2 几何积的引入

**几何积**（Geometric Product）定义为：
$$\mathbf{a}\mathbf{b} = \mathbf{a} \cdot \mathbf{b} + \mathbf{a} \wedge \mathbf{b}$$

其中：

- $\mathbf{a} \cdot \mathbf{b}$：内积（对称）
- $\mathbf{a} \wedge \mathbf{b}$：外积（反对称）

几何积的关键性质：
$$\mathbf{a}\mathbf{b} + \mathbf{b}\mathbf{a} = 2(\mathbf{a} \cdot \mathbf{b})$$
$$\mathbf{a}\mathbf{b} - \mathbf{b}\mathbf{a} = 2(\mathbf{a} \wedge \mathbf{b})$$

## 2. Clifford 代数的构造

### 2.1 定义

给定向量空间 $V$ 和二次型 $Q$，**Clifford 代数** $\text{Cl}(V, Q)$ 是满足以下条件的结合代数：

$$\mathbf{v}^2 = Q(\mathbf{v}) \cdot 1$$

对于正定内积空间，$\mathbf{e}_i^2 = 1$（单位向量的平方为 1）。

### 2.2 基本示例

**$\text{Cl}(\mathbb{R}^2)$ 的基**：$\{1, \mathbf{e}_1, \mathbf{e}_2, \mathbf{e}_1\mathbf{e}_2\}$

其中 $\mathbf{e}_1\mathbf{e}_2$ 是**双向量**（bivector），代表平面的有向面积。

**$\text{Cl}(\mathbb{R}^3)$ 的基**：
$$\{1, \mathbf{e}_1, \mathbf{e}_2, \mathbf{e}_3, \mathbf{e}_1\mathbf{e}_2, \mathbf{e}_2\mathbf{e}_3, \mathbf{e}_3\mathbf{e}_1, \mathbf{e}_1\mathbf{e}_2\mathbf{e}_3\}$$

共 $2^3 = 8$ 个基元素。

### 2.3 多重向量

**多重向量**（Multivector）是几何代数中的一般元素：

$$M = \langle M \rangle_0 + \langle M \rangle_1 + \langle M \rangle_2 + \cdots$$

其中 $\langle M \rangle_k$ 是 $k$-向量分量（$k$-vector）：

- 0-向量：标量
- 1-向量：向量
- 2-向量：双向量（有向面积）
- 3-向量：三向量（有向体积）

## 3. 基本运算

### 3.1 外积

外积产生更高阶的多重向量：

$$\mathbf{a} \wedge \mathbf{b} = \mathbf{a}\mathbf{b} - \mathbf{a} \cdot \mathbf{b}$$

性质：

- 反交换：$\mathbf{a} \wedge \mathbf{b} = -\mathbf{b} \wedge \mathbf{a}$
- $\mathbf{a} \wedge \mathbf{a} = 0$
- 结合律：$(\mathbf{a} \wedge \mathbf{b}) \wedge \mathbf{c} = \mathbf{a} \wedge (\mathbf{b} \wedge \mathbf{c})$

### 3.2 内积

内积降低阶数：

对于向量 $\mathbf{a}$ 和双向量 $B$：
$$\mathbf{a} \cdot B = \frac{1}{2}(\mathbf{a}B - B\mathbf{a})$$

结果是一个向量。

### 3.3 对偶

在 $n$ 维空间中，**伪标量** $I = \mathbf{e}_1\mathbf{e}_2\cdots\mathbf{e}_n$。

**对偶**：$A^* = AI^{-1}$

在 3D 中，向量的对偶是双向量，反之亦然。这解释了为什么叉积"看起来像"向量。

## 4. 反射与旋转

### 4.1 反射

向量 $\mathbf{v}$ 关于单位向量 $\mathbf{n}$ 的反射：

$$\mathbf{v}' = -\mathbf{n}\mathbf{v}\mathbf{n}$$

这个公式直接利用了几何积！

**推导**：
$$-\mathbf{n}\mathbf{v}\mathbf{n} = -\mathbf{n}(\mathbf{v}_\parallel + \mathbf{v}_\perp)\mathbf{n} = \mathbf{v}_\perp - \mathbf{v}_\parallel$$

### 4.2 旋转

两次反射等于一次旋转。设 $\mathbf{m}, \mathbf{n}$ 是两个单位向量，夹角为 $\theta/2$：

$$\mathbf{v}' = \mathbf{m}\mathbf{n}\mathbf{v}\mathbf{n}\mathbf{m} = R\mathbf{v}\tilde{R}$$

其中 $R = \mathbf{m}\mathbf{n}$ 是**旋转子**（rotor），$\tilde{R} = \mathbf{n}\mathbf{m}$ 是其逆。

### 4.3 旋转子

2D 旋转子：
$$R = \cos\frac{\theta}{2} + \mathbf{e}_1\mathbf{e}_2\sin\frac{\theta}{2}$$

3D 绕轴 $\mathbf{u}$（单位向量）旋转角度 $\theta$：
$$R = \cos\frac{\theta}{2} + I_{\mathbf{u}}\sin\frac{\theta}{2}$$

其中 $I_\mathbf{u} = \mathbf{u}I$ 是旋转平面的双向量。

**优点**：

- 避免了万向锁（gimbal lock）
- 计算效率高
- 自然推广到任意维度

## 5. 与其他代数的关系

### 5.1 复数

$\text{Cl}(\mathbb{R}^2)$ 的偶子代数（even subalgebra）同构于复数：

$$z = a + b\mathbf{e}_1\mathbf{e}_2 \leftrightarrow a + bi$$

其中 $(\mathbf{e}_1\mathbf{e}_2)^2 = -1$。

### 5.2 四元数

$\text{Cl}(\mathbb{R}^3)$ 的偶子代数同构于四元数：

$$\mathbf{i} = \mathbf{e}_2\mathbf{e}_3, \quad \mathbf{j} = \mathbf{e}_3\mathbf{e}_1, \quad \mathbf{k} = \mathbf{e}_1\mathbf{e}_2$$

满足 $\mathbf{i}^2 = \mathbf{j}^2 = \mathbf{k}^2 = \mathbf{ijk} = -1$。

### 5.3 泡利矩阵

$\text{Cl}(\mathbb{R}^3)$ 与泡利矩阵构成的代数同构：

$$\mathbf{e}_1 \leftrightarrow \sigma_1, \quad \mathbf{e}_2 \leftrightarrow \sigma_2, \quad \mathbf{e}_3 \leftrightarrow \sigma_3$$

## 6. 物理应用

### 6.1 电磁场

Maxwell 方程可以用几何代数简洁表示。定义电磁场二形式：

$$F = \mathbf{E} + Ic\mathbf{B}$$

Maxwell 方程变为：
$$\nabla F = \frac{\rho}{\epsilon_0} - \mu_0 \mathbf{J}$$

仅需**一个方程**！

### 6.2 狭义相对论

时空代数 $\text{Cl}(1,3)$ 自然包含 Lorentz 变换。

度规：$\gamma_0^2 = 1, \quad \gamma_i^2 = -1 \, (i=1,2,3)$

时空间隔：$s^2 = (ct)^2 - x^2 - y^2 - z^2$

Lorentz boost：$x' = RxR^\dagger$

### 6.3 量子力学

Dirac 方程可以用时空代数写成：

$$\nabla \psi I \sigma_3 - eA\psi = m\psi \gamma_0$$

旋量 $\psi$ 是时空代数中的偶元素。

## 7. 计算示例

### 7.1 投影与拒斥

向量 $\mathbf{v}$ 在 $\mathbf{u}$ 上的投影：
$$\mathbf{v}_\parallel = (\mathbf{v} \cdot \mathbf{u})\mathbf{u}^{-1} = \frac{\mathbf{v} \cdot \mathbf{u}}{\mathbf{u}^2}\mathbf{u}$$

拒斥（垂直分量）：
$$\mathbf{v}_\perp = (\mathbf{v} \wedge \mathbf{u})\mathbf{u}^{-1}$$

### 7.2 面积与体积

平行四边形面积：$|A| = |\mathbf{a} \wedge \mathbf{b}|$

平行六面体体积：$|V| = |\mathbf{a} \wedge \mathbf{b} \wedge \mathbf{c}|$

### 7.3 复合旋转

旋转的复合就是旋转子的乘积：

$$R_{\text{total}} = R_2 R_1$$

先 $R_1$ 后 $R_2$。这比旋转矩阵更高效！

## 代码实现

Python 中可以使用 `clifford` 库：

```python
from clifford import Cl

# 创建 3D 几何代数
layout, blades = Cl(3)
e1, e2, e3 = blades['e1'], blades['e2'], blades['e3']

# 几何积
a = 2*e1 + 3*e2
b = e1 - e3
print(a*b)  # 几何积

# 外积
print(a ^ b)

# 旋转子：绕 e3 轴旋转 90 度
import numpy as np
theta = np.pi / 2
R = np.cos(theta/2) + (e1^e2) * np.sin(theta/2)
v = e1
v_rotated = R * v * ~R  # ~R 是 R 的逆
print(v_rotated)  # 应该接近 e2
```

## 总结

几何代数提供了统一优雅的几何语言：

1. **几何积**：统一了点积和外积
2. **多重向量**：自然表示各阶几何对象
3. **旋转子**：比矩阵和四元数更直观高效
4. **维度无关**：公式自然推广到任意维度
5. **物理统一**：电磁学、相对论、量子力学的自然语言

## 参考资料

- Hestenes, D. & Sobczyk, G. *Clifford Algebra to Geometric Calculus*, 1984
- Doran, C. & Lasenby, A. *Geometric Algebra for Physicists*, 2003
- Dorst, L. et al. *Geometric Algebra for Computer Science*, 2007
- [Bivector.net](https://bivector.net/) - 几何代数资源
