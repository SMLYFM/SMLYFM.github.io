---
title: PDE数值方法：有限差分法入门
date: 2026-01-25 01:27:00
updated: 2026-01-25 01:27:00
categories:
  - 科学计算
  - 偏微分方程
tags:
  - 偏微分方程
  - 数值方法
  - 有限差分
mathjax: true
---

## 简介

偏微分方程(Partial Differential Equations, PDE)是描述自然界中各种物理现象的重要数学工具。本文介绍求解PDE的基本数值方法——有限差分法。

<!-- more -->

## 一维热传导方程

考虑一维热传导方程：

$$\frac{\partial u}{\partial t} = \alpha \frac{\partial^2 u}{\partial x^2}$$

其中 $u(x,t)$ 表示温度分布，$\alpha$ 是热扩散系数。

## 有限差分离散化

使用中心差分格式：

$$\frac{\partial^2 u}{\partial x^2} \approx \frac{u_{i+1} - 2u_i + u_{i-1}}{\Delta x^2}$$

使用前向差分：

$$\frac{\partial u}{\partial t} \approx \frac{u_i^{n+1} - u_i^n}{\Delta t}$$

## 稳定性分析

显式格式的稳定性条件（CFL条件）：

$$r = \frac{\alpha \Delta t}{\Delta x^2} \leq \frac{1}{2}$$

## 总结

有限差分法是求解PDE最直观的数值方法，适合规则网格上的问题。

## 参考资料

- LeVeque, R. J. (2007). Finite Difference Methods for Ordinary and Partial Differential Equations
