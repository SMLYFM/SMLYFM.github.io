---
title: 复分析入门：复变函数的解析性
date: 2026-01-17 11:00:00
updated: 2026-01-24 00:15:00
categories:
  - 数学
  - 分析学
tags:
  - 复分析
  - 全纯函数
  - 柯西定理
  - 留数定理
description: 介绍复变函数的基本理论，包括柯西-黎曼方程和留数定理
---

# 复分析入门：复变函数的解析性

复分析研究复平面上的函数，是数学中最优美的分支之一。

## 解析函数

函数 $f: \mathbb{C} \to \mathbb{C}$ 在点 $z_0$ 解析，若其在该点可微。

### 柯西-黎曼方程

设 $f(z) = u(x,y) + iv(x,y)$，则 $f$ 解析当且仅当：

$$\frac{\partial u}{\partial x} = \frac{\partial v}{\partial y}, \quad \frac{\partial u}{\partial y} = -\frac{\partial v}{\partial x}$$

## 柯西积分定理

设 $f$ 在单连通域 $D$ 内解析，$\gamma$ 为 $D$ 内闭曲线，则：

$$\oint_\gamma f(z) dz = 0$$

## 留数定理

用于计算复积分和实积分，在物理学中应用广泛。

### 示例

计算 $\int_{-\infty}^{\infty} \frac{1}{1+x^2} dx$...

复分析为量子力学、流体力学等提供了强大工具。
