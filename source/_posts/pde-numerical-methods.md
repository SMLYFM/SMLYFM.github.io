---
title: 偏微分方程数值解法入门
date: 2026-01-20 10:00:00
updated: 2026-01-25 02:15:00
categories:
  - 科学计算
  - 偏微分方程
tags:
  - PDE
  - 数值方法
  - 有限元
  - 数学建模
  - 有限差分
description: 介绍偏微分方程的基本数值求解方法，包括有限差分法和有限元法的基本原理
mathjax: true
---

# 偏微分方程数值解法入门

偏微分方程（Partial Differential Equations, PDEs）是描述自然现象的重要数学工具。本文将介绍几种常见的数值求解方法。

## 1. 有限差分法 (Finite Difference Method)

有限差分法是最直观的数值方法之一，核心思想是用**差商近似微商**。

### 1.1 基本差分格式

对于一阶导数：

$$
\frac{\partial u}{\partial x} \approx \frac{u_{i+1} - u_i}{\Delta x} \quad \text{(前向差分)}
$$

$$
\frac{\partial u}{\partial x} \approx \frac{u_i - u_{i-1}}{\Delta x} \quad \text{(后向差分)}
$$

$$
\frac{\partial u}{\partial x} \approx \frac{u_{i+1} - u_{i-1}}{2\Delta x} \quad \text{(中心差分)}
$$

对于二阶导数：

$$
\frac{\partial^2 u}{\partial x^2} \approx \frac{u_{i+1} - 2u_i + u_{i-1}}{(\Delta x)^2}
$$

### 1.2 示例：一维热传导方程

考虑方程：

$$
\frac{\partial u}{\partial t} = \alpha \frac{\partial^2 u}{\partial x^2}, \quad x \in (0, L), \, t > 0
$$

**显式格式（FTCS）**：

$$
\frac{u_i^{n+1} - u_i^n}{\Delta t} = \alpha \frac{u_{i+1}^n - 2u_i^n + u_{i-1}^n}{(\Delta x)^2}
$$

整理得：

$$
u_i^{n+1} = u_i^n + r(u_{i+1}^n - 2u_i^n + u_{i-1}^n)
$$

其中 $r = \frac{\alpha \Delta t}{(\Delta x)^2}$。

> **稳定性条件**：要求 $r \leq \frac{1}{2}$，否则数值解不稳定。

### 1.3 Python 实现

```python
import numpy as np
import matplotlib.pyplot as plt

def heat_equation_explicit(L, T, Nx, Nt, alpha, u0, bc_left, bc_right):
    """
    💡 显式有限差分法求解一维热传导方程
    """
    dx = L / (Nx - 1)
    dt = T / Nt
    r = alpha * dt / dx**2
    
    # 💡 稳定性检查
    if r > 0.5:
        print(f"WARNING: r = {r:.4f} > 0.5, 格式不稳定!")
    
    x = np.linspace(0, L, Nx)
    u = u0(x).copy()
    
    for n in range(Nt):
        u_new = u.copy()
        for i in range(1, Nx - 1):
            u_new[i] = u[i] + r * (u[i+1] - 2*u[i] + u[i-1])
        # 边界条件
        u_new[0] = bc_left
        u_new[-1] = bc_right
        u = u_new
    
    return x, u

# 示例：初始条件为 sin(πx)，边界条件为 0
L, T, Nx, Nt, alpha = 1.0, 0.1, 50, 500, 0.01
u0 = lambda x: np.sin(np.pi * x)
x, u = heat_equation_explicit(L, T, Nx, Nt, alpha, u0, 0, 0)
```

---

## 2. 有限元法 (Finite Element Method)

有限元法提供了更灵活的离散化方式，核心思想是将问题转化为**弱形式**，然后在有限维空间中求解。

### 2.1 弱形式推导

考虑 Poisson 方程：

$$
-\Delta u = f, \quad \text{in } \Omega
$$

乘以测试函数 $v \in H_0^1(\Omega)$ 并积分：

$$
-\int_\Omega \Delta u \cdot v \, dx = \int_\Omega f v \, dx
$$

使用分部积分（Green 公式）：

$$
\int_\Omega \nabla u \cdot \nabla v \, dx = \int_\Omega f v \, dx
$$

**弱形式**：找 $u \in H_0^1(\Omega)$，使得对所有 $v \in H_0^1(\Omega)$：

$$
a(u, v) = \ell(v)
$$

其中：

- $a(u, v) = \int_\Omega \nabla u \cdot \nabla v \, dx$ （双线性形式）
- $\ell(v) = \int_\Omega f v \, dx$ （线性泛函）

### 2.2 Galerkin 方法

选取有限维子空间 $V_h \subset H_0^1(\Omega)$，设 $\{\phi_1, \ldots, \phi_N\}$ 为基函数，则

$$
u_h = \sum_{j=1}^N u_j \phi_j
$$

代入弱形式，得到线性方程组：

$$
\mathbf{K} \mathbf{u} = \mathbf{f}
$$

其中：

- $K_{ij} = a(\phi_j, \phi_i) = \int_\Omega \nabla \phi_j \cdot \nabla \phi_i \, dx$ （刚度矩阵）
- $f_i = \ell(\phi_i) = \int_\Omega f \phi_i \, dx$ （载荷向量）

### 2.3 一维线性元示例

对于区间 $[0, 1]$ 上的一维问题，使用分段线性基函数（帽子函数）：

$$
\phi_i(x) = \begin{cases}
\frac{x - x_{i-1}}{h} & x \in [x_{i-1}, x_i] \\
\frac{x_{i+1} - x}{h} & x \in [x_i, x_{i+1}] \\
0 & \text{otherwise}
\end{cases}
$$

刚度矩阵元素：

$$
K_{ij} = \int_0^1 \phi_i'(x) \phi_j'(x) \, dx = \frac{1}{h} \begin{pmatrix} 2 & -1 & & \\ -1 & 2 & -1 & \\ & \ddots & \ddots & \ddots \\ & & -1 & 2 \end{pmatrix}
$$

---

## 3. 方法对比

| 特性 | 有限差分法 | 有限元法 |
|------|-----------|---------|
| 实现复杂度 | 简单 | 较复杂 |
| 网格灵活性 | 规则网格 | 非结构化网格 |
| 边界处理 | 较困难 | 自然处理 |
| 理论分析 | 较困难 | Lax-Milgram 框架 |
| 高阶精度 | 高阶差分 | 高阶单元 |

---

## 4. 参考资料

1. LeVeque, R.J. *Finite Difference Methods for Ordinary and Partial Differential Equations*
2. Brenner, S.C. & Scott, L.R. *The Mathematical Theory of Finite Element Methods*
3. Ern, A. & Guermond, J.L. *Theory and Practice of Finite Elements*
