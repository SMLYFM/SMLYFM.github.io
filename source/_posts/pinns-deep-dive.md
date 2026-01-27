---
title: 物理信息神经网络 (PINNs) 深入解析：理论、实现与应用
date: 2026-01-25 14:15:00
updated: 2026-01-27 10:28:02
categories:
  - 科学计算
  - 偏微分方程
tags:
  - PINNs
  - 深度学习
  - PyTorch
  - 科学计算
  - 偏微分方程
  - 自动微分
description: 从理论到实践全面介绍物理信息神经网络，包括数学原理、损失函数设计、PyTorch 实现和典型应用案例
mathjax: true
---

## 简介

物理信息神经网络（Physics-Informed Neural Networks, **PINNs**）是由 Raissi 等人于 2019 年提出的一种将物理先验知识嵌入深度学习框架的方法。它通过在损失函数中引入偏微分方程（PDE）的残差项，实现了**数据驱动**与**物理约束**的有机融合。

<!-- more -->

PINNs 的核心优势：

1. **无需网格**：不依赖传统数值方法的网格划分
2. **少量数据**：通过物理约束大幅减少对训练数据的需求
3. **灵活性**：易于处理复杂几何和高维问题
4. **反问题**：能够同时求解正问题和反问题

---

## 1. 数学基础

### 1.1 问题设定

考虑一般形式的偏微分方程：

$$
\begin{cases}
\mathcal{N}[u(\mathbf{x}, t)] = f(\mathbf{x}, t), & \mathbf{x} \in \Omega, \, t \in [0, T] \\
\mathcal{B}[u(\mathbf{x}, t)] = g(\mathbf{x}, t), & \mathbf{x} \in \partial\Omega \\
u(\mathbf{x}, 0) = h(\mathbf{x}), & \mathbf{x} \in \Omega
\end{cases}
$$

其中：

- $\mathcal{N}$ 是**微分算子**（可以是非线性的）
- $\mathcal{B}$ 是**边界条件算子**
- $\Omega \subset \mathbb{R}^d$ 是计算域
- $\partial\Omega$ 是边界

### 1.2 神经网络近似

PINNs 使用神经网络 $u_\theta(\mathbf{x}, t)$ 来近似 PDE 的解 $u(\mathbf{x}, t)$，其中 $\theta$ 表示网络参数（权重和偏置）。

对于一个 $L$ 层的全连接网络：

$$
u_\theta(\mathbf{x}, t) = \mathcal{NN}_\theta(\mathbf{x}, t) = \sigma_L \circ \mathbf{W}_L \circ \sigma_{L-1} \circ \cdots \circ \sigma_1 \circ \mathbf{W}_1 (\mathbf{x}, t)
$$

其中 $\sigma_i$ 是激活函数，$\mathbf{W}_i$ 是仿射变换。

### 1.3 自动微分

PINNs 的关键在于利用**自动微分**（Automatic Differentiation）计算网络输出对输入的偏导数：

$$
\frac{\partial u_\theta}{\partial x}, \quad \frac{\partial u_\theta}{\partial t}, \quad \frac{\partial^2 u_\theta}{\partial x^2}, \quad \ldots
$$

这与数值微分不同，自动微分是**精确的**（机器精度内）。

---

## 2. 损失函数设计

### 2.1 总损失函数

PINNs 的总损失函数由多个部分组成：

$$
\mathcal{L}(\theta) = \lambda_{data} \mathcal{L}_{data} + \lambda_{PDE} \mathcal{L}_{PDE} + \lambda_{BC} \mathcal{L}_{BC} + \lambda_{IC} \mathcal{L}_{IC}
$$

其中 $\lambda_{*}$ 是权重超参数，用于平衡各项损失。

### 2.2 数据拟合损失

当有观测数据 $\{(\mathbf{x}_i^{data}, t_i^{data}, u_i^{data})\}_{i=1}^{N_{data}}$ 时：

$$
\mathcal{L}_{data} = \frac{1}{N_{data}} \sum_{i=1}^{N_{data}} \left| u_\theta(\mathbf{x}_i^{data}, t_i^{data}) - u_i^{data} \right|^2
$$

### 2.3 PDE 残差损失

在计算域内采样 $N_r$ 个**配点**（collocation points）：

$$
\mathcal{L}_{PDE} = \frac{1}{N_r} \sum_{i=1}^{N_r} \left| \mathcal{N}[u_\theta(\mathbf{x}_i^r, t_i^r)] - f(\mathbf{x}_i^r, t_i^r) \right|^2
$$

这是 PINNs 的核心——**物理约束损失**。

### 2.4 边界条件损失

在边界 $\partial\Omega$ 上采样 $N_{BC}$ 个点：

$$
\mathcal{L}_{BC} = \frac{1}{N_{BC}} \sum_{i=1}^{N_{BC}} \left| \mathcal{B}[u_\theta(\mathbf{x}_i^{BC}, t_i^{BC})] - g(\mathbf{x}_i^{BC}, t_i^{BC}) \right|^2
$$

常见边界条件类型：

- **Dirichlet**：$u = g$
- **Neumann**：$\frac{\partial u}{\partial n} = g$
- **Robin**：$\alpha u + \beta \frac{\partial u}{\partial n} = g$

### 2.5 初始条件损失

在 $t=0$ 时采样 $N_{IC}$ 个点：

$$
\mathcal{L}_{IC} = \frac{1}{N_{IC}} \sum_{i=1}^{N_{IC}} \left| u_\theta(\mathbf{x}_i^{IC}, 0) - h(\mathbf{x}_i^{IC}) \right|^2
$$

---

## 3. PyTorch 实现

### 3.1 网络架构

```python
import torch
import torch.nn as nn
import numpy as np

class PINN(nn.Module):
    """物理信息神经网络
    
    💡 使用全连接网络近似 PDE 解
    """
    def __init__(self, layers: list[int], activation: str = 'tanh'):
        super(PINN, self).__init__()
        
        # 💡 选择激活函数
        if activation == 'tanh':
            self.activation = nn.Tanh()
        elif activation == 'sin':
            self.activation = torch.sin
        elif activation == 'gelu':
            self.activation = nn.GELU()
        else:
            self.activation = nn.Tanh()
        
        # 💡 构建网络层
        self.layers = nn.ModuleList()
        for i in range(len(layers) - 1):
            self.layers.append(nn.Linear(layers[i], layers[i+1]))
        
        # 💡 Xavier 初始化
        self._init_weights()
    
    def _init_weights(self):
        """权重初始化"""
        for layer in self.layers:
            nn.init.xavier_normal_(layer.weight)
            nn.init.zeros_(layer.bias)
    
    def forward(self, x: torch.Tensor, t: torch.Tensor) -> torch.Tensor:
        """前向传播
        
        Args:
            x: 空间坐标 [batch, d]
            t: 时间坐标 [batch, 1]
        
        Returns:
            u: 近似解 [batch, 1]
        """
        # 💡 拼接输入
        inputs = torch.cat([x, t], dim=1)
        
        # 💡 前向传播
        for i, layer in enumerate(self.layers[:-1]):
            inputs = self.activation(layer(inputs))
        
        # 💡 最后一层不加激活函数
        outputs = self.layers[-1](inputs)
        return outputs
```

### 3.2 自动微分计算导数

```python
def compute_derivatives(u: torch.Tensor, 
                       x: torch.Tensor, 
                       t: torch.Tensor) -> dict:
    """计算 u 对 x, t 的各阶偏导数
    
    💡 使用 PyTorch 自动微分
    """
    # 💡 一阶导数
    u_t = torch.autograd.grad(
        u, t, 
        grad_outputs=torch.ones_like(u),
        create_graph=True, retain_graph=True
    )[0]
    
    u_x = torch.autograd.grad(
        u, x,
        grad_outputs=torch.ones_like(u),
        create_graph=True, retain_graph=True
    )[0]
    
    # 💡 二阶导数
    u_xx = torch.autograd.grad(
        u_x, x,
        grad_outputs=torch.ones_like(u_x),
        create_graph=True, retain_graph=True
    )[0]
    
    return {
        'u_t': u_t,
        'u_x': u_x,
        'u_xx': u_xx
    }
```

### 3.3 热传导方程求解器

以一维热传导方程为例：

$$
\frac{\partial u}{\partial t} = \alpha \frac{\partial^2 u}{\partial x^2}, \quad x \in [0, 1], \, t \in [0, 1]
$$

边界条件：$u(0,t) = u(1,t) = 0$

初始条件：$u(x,0) = \sin(\pi x)$

解析解：$u(x,t) = e^{-\alpha \pi^2 t} \sin(\pi x)$

```python
class HeatEquationPINN:
    """热传导方程 PINN 求解器"""
    
    def __init__(self, alpha: float = 0.01):
        self.alpha = alpha
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        
        # 💡 网络结构: 2 输入 (x, t) -> 1 输出 (u)
        layers = [2, 64, 64, 64, 64, 1]
        self.model = PINN(layers).to(self.device)
        
        # 💡 优化器
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr=1e-3)
        self.scheduler = torch.optim.lr_scheduler.StepLR(
            self.optimizer, step_size=2000, gamma=0.5
        )
    
    def pde_residual(self, x: torch.Tensor, t: torch.Tensor) -> torch.Tensor:
        """计算 PDE 残差: u_t - alpha * u_xx"""
        x.requires_grad_(True)
        t.requires_grad_(True)
        
        u = self.model(x, t)
        derivs = compute_derivatives(u, x, t)
        
        # 💡 热传导方程残差
        residual = derivs['u_t'] - self.alpha * derivs['u_xx']
        return residual
    
    def loss_function(self, 
                     x_pde: torch.Tensor, t_pde: torch.Tensor,
                     x_bc: torch.Tensor, t_bc: torch.Tensor,
                     x_ic: torch.Tensor) -> dict:
        """计算总损失"""
        
        # 💡 PDE 残差损失
        residual = self.pde_residual(x_pde, t_pde)
        loss_pde = torch.mean(residual ** 2)
        
        # 💡 边界条件损失 (Dirichlet: u = 0)
        t_bc.requires_grad_(False)
        x_bc.requires_grad_(False)
        u_bc = self.model(x_bc, t_bc)
        loss_bc = torch.mean(u_bc ** 2)
        
        # 💡 初始条件损失: u(x, 0) = sin(pi * x)
        t_ic = torch.zeros_like(x_ic)
        u_ic = self.model(x_ic, t_ic)
        u_ic_exact = torch.sin(np.pi * x_ic)
        loss_ic = torch.mean((u_ic - u_ic_exact) ** 2)
        
        # 💡 总损失
        loss_total = loss_pde + 100 * loss_bc + 100 * loss_ic
        
        return {
            'total': loss_total,
            'pde': loss_pde.item(),
            'bc': loss_bc.item(),
            'ic': loss_ic.item()
        }
    
    def train(self, epochs: int = 10000, n_pde: int = 10000, 
              n_bc: int = 200, n_ic: int = 200):
        """训练模型"""
        
        for epoch in range(epochs):
            self.optimizer.zero_grad()
            
            # 💡 采样配点
            x_pde = torch.rand(n_pde, 1, device=self.device)
            t_pde = torch.rand(n_pde, 1, device=self.device)
            
            # 💡 边界点 (x=0 和 x=1)
            x_bc = torch.cat([
                torch.zeros(n_bc // 2, 1),
                torch.ones(n_bc // 2, 1)
            ]).to(self.device)
            t_bc = torch.rand(n_bc, 1, device=self.device)
            
            # 💡 初始条件点
            x_ic = torch.rand(n_ic, 1, device=self.device)
            
            # 💡 计算损失并反向传播
            losses = self.loss_function(x_pde, t_pde, x_bc, t_bc, x_ic)
            losses['total'].backward()
            
            self.optimizer.step()
            self.scheduler.step()
            
            if epoch % 1000 == 0:
                print(f"Epoch {epoch}: Loss = {losses['total'].item():.6f} "
                      f"(PDE: {losses['pde']:.6f}, BC: {losses['bc']:.6f}, "
                      f"IC: {losses['ic']:.6f})")
    
    def predict(self, x: np.ndarray, t: np.ndarray) -> np.ndarray:
        """预测"""
        self.model.eval()
        with torch.no_grad():
            x_tensor = torch.tensor(x, dtype=torch.float32, device=self.device)
            t_tensor = torch.tensor(t, dtype=torch.float32, device=self.device)
            u = self.model(x_tensor, t_tensor)
        return u.cpu().numpy()
```

### 3.4 训练与可视化

```python
import matplotlib.pyplot as plt

# 💡 创建求解器并训练
solver = HeatEquationPINN(alpha=0.01)
solver.train(epochs=10000)

# 💡 生成预测网格
x = np.linspace(0, 1, 100).reshape(-1, 1)
t = np.linspace(0, 1, 100).reshape(-1, 1)
X, T = np.meshgrid(x.flatten(), t.flatten())

x_flat = X.flatten().reshape(-1, 1)
t_flat = T.flatten().reshape(-1, 1)
u_pred = solver.predict(x_flat, t_flat).reshape(100, 100)

# 💡 解析解
u_exact = np.exp(-0.01 * np.pi**2 * T) * np.sin(np.pi * X)

# 💡 可视化
fig, axes = plt.subplots(1, 3, figsize=(15, 4))

im1 = axes[0].contourf(X, T, u_pred, levels=50, cmap='viridis')
axes[0].set_title('PINN 预测解')
axes[0].set_xlabel('x')
axes[0].set_ylabel('t')
plt.colorbar(im1, ax=axes[0])

im2 = axes[1].contourf(X, T, u_exact, levels=50, cmap='viridis')
axes[1].set_title('解析解')
axes[1].set_xlabel('x')
axes[1].set_ylabel('t')
plt.colorbar(im2, ax=axes[1])

im3 = axes[2].contourf(X, T, np.abs(u_pred - u_exact), levels=50, cmap='hot')
axes[2].set_title('绝对误差')
axes[2].set_xlabel('x')
axes[2].set_ylabel('t')
plt.colorbar(im3, ax=axes[2])

plt.tight_layout()
plt.savefig('heat_equation_pinn.png', dpi=300)
plt.show()
```

---

## 4. 典型应用案例

### 4.1 Burgers 方程

一维粘性 Burgers 方程是非线性 PDE 的经典例子：

$$
\frac{\partial u}{\partial t} + u \frac{\partial u}{\partial x} = \nu \frac{\partial^2 u}{\partial x^2}
$$

```python
def burgers_residual(self, x, t):
    """Burgers 方程残差"""
    x.requires_grad_(True)
    t.requires_grad_(True)
    
    u = self.model(x, t)
    derivs = compute_derivatives(u, x, t)
    
    # 💡 Burgers 方程: u_t + u * u_x - nu * u_xx = 0
    residual = derivs['u_t'] + u * derivs['u_x'] - self.nu * derivs['u_xx']
    return residual
```

### 4.2 Navier-Stokes 方程

二维不可压缩 Navier-Stokes 方程：

$$
\frac{\partial \mathbf{u}}{\partial t} + (\mathbf{u} \cdot \nabla)\mathbf{u} = -\frac{1}{\rho}\nabla p + \nu \nabla^2 \mathbf{u}
$$

$$\nabla \cdot \mathbf{u} = 0$$

PINNs 需要同时预测速度场 $(u, v)$ 和压力场 $p$。

### 4.3 薛定谔方程

复数值 PINNs 求解量子力学问题：

$$
i\hbar \frac{\partial \psi}{\partial t} = -\frac{\hbar^2}{2m}\nabla^2 \psi + V\psi
$$

需要将复数分解为实部和虚部分别建模。

### 4.4 反问题：参数识别

PINNs 的一个强大应用是**反问题**——从观测数据推断未知参数。

例如，从温度场观测数据推断热传导系数 $\alpha$：

```python
class InversePINN(nn.Module):
    def __init__(self, layers):
        super().__init__()
        self.network = PINN(layers)
        
        # 💡 将 alpha 设为可学习参数
        self.alpha = nn.Parameter(torch.tensor([0.1]))
    
    def pde_residual(self, x, t):
        u = self.network(x, t)
        derivs = compute_derivatives(u, x, t)
        
        # 💡 使用可学习的 alpha
        residual = derivs['u_t'] - self.alpha * derivs['u_xx']
        return residual
```

---

## 5. 高级技巧

### 5.1 损失权重自适应

不同损失项的量级可能差异很大，使用**自适应权重**：

```python
class AdaptiveLossWeighting:
    """基于梯度范数的自适应损失权重"""
    
    def __init__(self, num_losses: int):
        self.weights = [1.0] * num_losses
    
    def update(self, model, losses: list[torch.Tensor]):
        grads = []
        for loss in losses:
            model.zero_grad()
            loss.backward(retain_graph=True)
            grad_norm = sum(p.grad.norm()**2 for p in model.parameters() 
                           if p.grad is not None) ** 0.5
            grads.append(grad_norm.item())
        
        # 💡 归一化权重
        max_grad = max(grads)
        self.weights = [max_grad / (g + 1e-8) for g in grads]
```

### 5.2 傅里叶特征编码

对于高频解，使用**傅里叶特征**可以显著提升精度：

$$
\gamma(\mathbf{x}) = [\sin(2\pi \mathbf{B}\mathbf{x}), \cos(2\pi \mathbf{B}\mathbf{x})]
$$

```python
class FourierFeatures(nn.Module):
    """傅里叶特征编码"""
    
    def __init__(self, input_dim: int, num_features: int, scale: float = 1.0):
        super().__init__()
        B = torch.randn(input_dim, num_features) * scale
        self.register_buffer('B', B)
    
    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x_proj = 2 * np.pi * x @ self.B
        return torch.cat([torch.sin(x_proj), torch.cos(x_proj)], dim=-1)
```

### 5.3 残差采样策略

动态调整配点分布，在残差较大的区域增加采样：

```python
def residual_based_sampling(model, n_samples, x_range, t_range):
    """基于残差的自适应采样"""
    
    # 💡 初始均匀采样
    x = torch.rand(n_samples * 10, 1) * (x_range[1] - x_range[0]) + x_range[0]
    t = torch.rand(n_samples * 10, 1) * (t_range[1] - t_range[0]) + t_range[0]
    
    # 💡 计算残差
    with torch.no_grad():
        residual = model.pde_residual(x, t).abs()
    
    # 💡 按残差大小采样
    probs = residual / residual.sum()
    indices = torch.multinomial(probs.flatten(), n_samples, replacement=True)
    
    return x[indices], t[indices]
```

### 5.4 多尺度时间步进

对于长时间演化问题，采用**时间分解**策略：

```python
def sequential_training(solver, t_segments):
    """分段时间域训练"""
    for i, (t_start, t_end) in enumerate(t_segments):
        print(f"Training segment {i+1}: t ∈ [{t_start}, {t_end}]")
        
        # 💡 用前一段的终态作为本段初始条件
        if i > 0:
            x_ic = torch.rand(200, 1)
            t_ic = torch.full_like(x_ic, t_start)
            u_ic = solver.predict(x_ic.numpy(), t_ic.numpy())
            solver.set_initial_condition(x_ic, u_ic)
        
        solver.train_segment(t_start, t_end, epochs=5000)
```

---

## 6. 局限性与挑战

### 6.1 训练困难

- **梯度消失/爆炸**：高阶导数计算可能导致数值不稳定
- **损失平衡**：不同损失项之间的权重调整困难
- **收敛速度慢**：特别是对于复杂 PDE

### 6.2 问题限制

- **刚性问题**：多尺度时间问题难以求解
- **高维问题**：维数灾难仍然存在
- **间断解**：对于激波等间断解表现较差

### 6.3 改进方向

- **分解方法**：将问题分解为多个子问题
- **并行 PINNs**：空间/时间域分解
- **变分 PINNs**：使用弱形式减少导数阶数
- **混合方法**：结合传统数值方法

---

## 总结

PINNs 代表了科学机器学习的一个重要方向，它巧妙地将物理定律融入神经网络训练中。尽管仍存在一些挑战，但其在以下方面展现出巨大潜力：

1. **少数据场景**：物理约束弥补数据不足
2. **反问题**：从观测推断未知参数
3. **复杂几何**：无需传统网格划分
4. **多物理场耦合**：灵活处理多物理问题

随着算法和计算能力的进步，PINNs 将在科学计算领域发挥越来越重要的作用。

---

## 参考资料

- Raissi, M., Perdikaris, P., & Karniadakis, G. E. (2019). Physics-informed neural networks: A deep learning framework for solving forward and inverse problems involving nonlinear partial differential equations. _Journal of Computational Physics_, 378, 686-707.
- Karniadakis, G. E., et al. (2021). Physics-informed machine learning. _Nature Reviews Physics_, 3(6), 422-440.
- [DeepXDE Library](https://deepxde.readthedocs.io/) - PINNs 开源框架
- [NVIDIA Modulus](https://developer.nvidia.com/modulus) - 工业级 PINNs 平台
