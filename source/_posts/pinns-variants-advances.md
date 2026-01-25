---
title: PINNs 变体与前沿进展：从基础到 DeepONet
date: 2026-01-25 14:20:00
updated: 2026-01-25 14:20:00
categories:
  - 科学计算
  - 偏微分方程
tags:
  - PINNs
  - DeepONet
  - 神经算子
  - 深度学习
  - 科学计算
description: 介绍 PINNs 的各种变体和改进方法，包括 hp-VPINNs、XPINN、DeepONet 等前沿进展
mathjax: true
---

## 简介

自 2019 年 PINNs 论文发表以来，研究者们提出了众多改进变体来解决原始 PINNs 的局限性。本文介绍几种重要的 PINNs 变体及其应用场景。

<!-- more -->

---

## 1. hp-VPINNs：变分物理信息神经网络

### 1.1 动机

原始 PINNs 使用 PDE 的**强形式**（strong form），需要计算高阶导数。而 **hp-VPINNs** 采用**弱形式**（weak form），通过变分原理减少导数阶数。

### 1.2 数学原理

对于椭圆型 PDE：

$$
-\nabla \cdot (k \nabla u) = f \quad \text{in } \Omega
$$

强形式需要计算 $\nabla^2 u$。而弱形式为：

$$
\int_\Omega k \nabla u \cdot \nabla v \, d\mathbf{x} = \int_\Omega f v \, d\mathbf{x}, \quad \forall v \in V
$$

只需要一阶导数 $\nabla u$。

### 1.3 hp 细化策略

- **h 细化**：增加计算域的子区域数量
- **p 细化**：在每个子区域内增加测试函数的多项式次数

```python
class VPINNLoss:
    """变分 PINN 损失函数"""
    
    def __init__(self, test_functions):
        self.test_functions = test_functions
    
    def compute(self, model, x, k, f):
        u = model(x)
        u_x = torch.autograd.grad(u, x, 
                                   grad_outputs=torch.ones_like(u),
                                   create_graph=True)[0]
        
        loss = 0
        for v in self.test_functions:
            v_x = torch.autograd.grad(v(x), x,
                                       grad_outputs=torch.ones_like(v(x)),
                                       create_graph=True)[0]
            
            # 💡 弱形式：∫ k∇u·∇v dx = ∫ fv dx
            lhs = torch.mean(k * u_x * v_x)
            rhs = torch.mean(f * v(x))
            loss += (lhs - rhs) ** 2
        
        return loss
```

### 1.4 优势

- 降低对网络光滑性的要求
- 更容易处理复杂边界条件
- 对非光滑解更鲁棒

---

## 2. XPINN：扩展物理信息神经网络

### 2.1 动机

原始 PINNs 难以处理大规模、复杂几何问题。**XPINN** 采用**区域分解**策略，将计算域划分为多个子域。

### 2.2 方法

将 $\Omega$ 分解为 $K$ 个子域：

$$
\Omega = \bigcup_{k=1}^K \Omega_k, \quad \Gamma_{ij} = \partial\Omega_i \cap \partial\Omega_j
$$

每个子域使用独立的神经网络 $u_k^\theta$。

### 2.3 界面条件

在子域界面 $\Gamma_{ij}$ 上施加连续性约束：

$$
\begin{cases}
u_i(\mathbf{x}) = u_j(\mathbf{x}), & \mathbf{x} \in \Gamma_{ij} \\
\frac{\partial u_i}{\partial n_i}(\mathbf{x}) = -\frac{\partial u_j}{\partial n_j}(\mathbf{x}), & \mathbf{x} \in \Gamma_{ij}
\end{cases}
$$

### 2.4 损失函数

$$
\mathcal{L} = \sum_{k=1}^K \mathcal{L}_k^{PDE} + \sum_{i<j} \left( \mathcal{L}_{ij}^{cont} + \mathcal{L}_{ij}^{flux} \right)
$$

```python
class XPINN:
    """扩展物理信息神经网络"""
    
    def __init__(self, n_subdomains):
        self.networks = nn.ModuleList([
            PINN([2, 64, 64, 64, 1]) 
            for _ in range(n_subdomains)
        ])
    
    def interface_loss(self, x_interface, i, j):
        """界面连续性损失"""
        u_i = self.networks[i](x_interface)
        u_j = self.networks[j](x_interface)
        
        # 💡 解的连续性
        loss_cont = torch.mean((u_i - u_j) ** 2)
        
        # 💡 通量的连续性（需要法向导数）
        # ... 
        
        return loss_cont
```

### 2.5 优势

- **并行化**：子域可并行训练
- **扩展性**：可处理更大规模问题
- **灵活性**：不同子域可使用不同网络架构

---

## 3. DeepONet：深度算子网络

### 3.1 动机

传统 PINNs 针对**特定问题**训练，无法泛化。**DeepONet** 学习整个**算子映射**，可泛化到不同输入函数。

### 3.2 通用逼近定理

Chen & Chen (1995) 证明：任意连续算子 $G$ 可以表示为：

$$
G(u)(y) \approx \sum_{k=1}^p \underbrace{b_k(u(x_1), ..., u(x_m))}_{\text{Branch Net}} \cdot \underbrace{t_k(y)}_{\text{Trunk Net}}
$$

### 3.3 架构

DeepONet 包含两个子网络：

1. **Branch Net**：编码输入函数 $u$ 在传感器点 $\{x_i\}$ 处的值
2. **Trunk Net**：编码查询位置 $y$

```python
class DeepONet(nn.Module):
    """深度算子网络"""
    
    def __init__(self, 
                 branch_layers: list[int],
                 trunk_layers: list[int],
                 output_dim: int):
        super().__init__()
        
        # 💡 Branch Net: 编码输入函数
        self.branch_net = self._build_mlp(branch_layers)
        
        # 💡 Trunk Net: 编码查询位置
        self.trunk_net = self._build_mlp(trunk_layers)
        
        # 💡 输出维度
        self.output_dim = output_dim
    
    def _build_mlp(self, layers):
        modules = []
        for i in range(len(layers) - 1):
            modules.append(nn.Linear(layers[i], layers[i+1]))
            if i < len(layers) - 2:
                modules.append(nn.Tanh())
        return nn.Sequential(*modules)
    
    def forward(self, 
                u_sensors: torch.Tensor,  # [batch, n_sensors]
                y: torch.Tensor           # [batch, dim]
               ) -> torch.Tensor:
        """
        Args:
            u_sensors: 输入函数在传感器点的值
            y: 查询位置
        
        Returns:
            G(u)(y): 算子在 y 处的输出
        """
        # 💡 Branch 输出: [batch, p]
        branch_out = self.branch_net(u_sensors)
        
        # 💡 Trunk 输出: [batch, p]
        trunk_out = self.trunk_net(y)
        
        # 💡 点积合成: [batch, 1]
        output = torch.sum(branch_out * trunk_out, dim=-1, keepdim=True)
        return output
```

### 3.4 训练

训练数据为多组 $(u, y, G(u)(y))$ 三元组：

```python
def train_deeponet(model, data_loader, epochs=10000):
    optimizer = torch.optim.Adam(model.parameters(), lr=1e-3)
    
    for epoch in range(epochs):
        for u_sensors, y, target in data_loader:
            optimizer.zero_grad()
            
            pred = model(u_sensors, y)
            loss = F.mse_loss(pred, target)
            
            loss.backward()
            optimizer.step()
```

### 3.5 Physics-Informed DeepONet

结合 PINNs 和 DeepONet：

$$
\mathcal{L} = \mathcal{L}_{data} + \lambda_{physics} \mathcal{L}_{physics}
$$

其中 $\mathcal{L}_{physics}$ 是 PDE 残差损失。

---

## 4. Fourier Neural Operator (FNO)

### 4.1 动机

DeepONet 在实践中有时受限于点评估。**FNO** 直接在傅里叶空间进行卷积，更适合周期性问题。

### 4.2 谱卷积

FNO 的核心是**谱卷积层**：

$$
(\mathcal{K}(\phi)v)(x) = \mathcal{F}^{-1}\left( R_\phi \cdot \mathcal{F}(v) \right)(x)
$$

其中 $\mathcal{F}$ 是傅里叶变换，$R_\phi$ 是可学习的傅里叶空间权重。

### 4.3 PyTorch 实现

```python
class SpectralConv2d(nn.Module):
    """2D 谱卷积层"""
    
    def __init__(self, in_channels, out_channels, modes1, modes2):
        super().__init__()
        self.in_channels = in_channels
        self.out_channels = out_channels
        self.modes1 = modes1  # 保留的傅里叶模式数
        self.modes2 = modes2
        
        # 💡 傅里叶空间中的可学习权重
        scale = 1 / (in_channels * out_channels)
        self.weights1 = nn.Parameter(
            scale * torch.rand(in_channels, out_channels, modes1, modes2, 2)
        )
        self.weights2 = nn.Parameter(
            scale * torch.rand(in_channels, out_channels, modes1, modes2, 2)
        )
    
    def compl_mul2d(self, input, weights):
        """复数乘法"""
        return torch.einsum("bixy,ioxy->boxy", input, 
                           torch.view_as_complex(weights))
    
    def forward(self, x):
        batch_size = x.shape[0]
        
        # 💡 FFT
        x_ft = torch.fft.rfft2(x)
        
        # 💡 在低频模式上相乘
        out_ft = torch.zeros(batch_size, self.out_channels, 
                            x.size(-2), x.size(-1)//2 + 1,
                            dtype=torch.cfloat, device=x.device)
        
        out_ft[:, :, :self.modes1, :self.modes2] = \
            self.compl_mul2d(x_ft[:, :, :self.modes1, :self.modes2], 
                            self.weights1)
        out_ft[:, :, -self.modes1:, :self.modes2] = \
            self.compl_mul2d(x_ft[:, :, -self.modes1:, :self.modes2], 
                            self.weights2)
        
        # 💡 逆 FFT
        x = torch.fft.irfft2(out_ft, s=(x.size(-2), x.size(-1)))
        return x


class FNO2d(nn.Module):
    """2D 傅里叶神经算子"""
    
    def __init__(self, modes1, modes2, width):
        super().__init__()
        self.modes1 = modes1
        self.modes2 = modes2
        self.width = width
        
        # 💡 提升维度
        self.fc0 = nn.Linear(3, width)  # (x, y, a) -> width
        
        # 💡 傅里叶层
        self.conv0 = SpectralConv2d(width, width, modes1, modes2)
        self.conv1 = SpectralConv2d(width, width, modes1, modes2)
        self.conv2 = SpectralConv2d(width, width, modes1, modes2)
        self.conv3 = SpectralConv2d(width, width, modes1, modes2)
        
        # 💡 残差连接
        self.w0 = nn.Conv2d(width, width, 1)
        self.w1 = nn.Conv2d(width, width, 1)
        self.w2 = nn.Conv2d(width, width, 1)
        self.w3 = nn.Conv2d(width, width, 1)
        
        # 💡 投影输出
        self.fc1 = nn.Linear(width, 128)
        self.fc2 = nn.Linear(128, 1)
    
    def forward(self, x):
        # x: [batch, x, y, 3]
        x = self.fc0(x)
        x = x.permute(0, 3, 1, 2)  # [batch, width, x, y]
        
        # 💡 傅里叶层 + 残差
        x1 = self.conv0(x)
        x2 = self.w0(x)
        x = F.gelu(x1 + x2)
        
        x1 = self.conv1(x)
        x2 = self.w1(x)
        x = F.gelu(x1 + x2)
        
        x1 = self.conv2(x)
        x2 = self.w2(x)
        x = F.gelu(x1 + x2)
        
        x1 = self.conv3(x)
        x2 = self.w3(x)
        x = x1 + x2
        
        # 💡 投影到输出
        x = x.permute(0, 2, 3, 1)  # [batch, x, y, width]
        x = self.fc1(x)
        x = F.gelu(x)
        x = self.fc2(x)
        
        return x
```

### 4.4 应用场景

- **Darcy 流**：多孔介质流动
- **Navier-Stokes**：湍流预测
- **气象预测**：全球天气建模

---

## 5. 其他变体

### 5.1 Conservative PINNs (cPINNs)

针对守恒律方程，强制满足守恒性质：

$$
\frac{d}{dt}\int_\Omega u \, dx = -\oint_{\partial\Omega} \mathbf{F} \cdot \mathbf{n} \, dS
$$

### 5.2 Gradient-Enhanced PINNs

利用梯度信息增强训练：

$$
\mathcal{L}_{grad} = \sum_i \left| \frac{\partial u_\theta}{\partial x_i} - \frac{\partial u_{data}}{\partial x_i} \right|^2
$$

### 5.3 Hard-Constrained PINNs

通过网络架构**硬编码**边界条件：

$$
u_\theta(x) = B(x) + D(x) \cdot N_\theta(x)
$$

其中 $B(x)$ 满足边界条件，$D(x)$ 在边界处为零。

```python
class HardConstrainedPINN(nn.Module):
    """硬约束 PINN"""
    
    def __init__(self, network):
        super().__init__()
        self.network = network
    
    def forward(self, x, t):
        # 💡 距离函数：在边界 x=0, x=1 处为 0
        D = x * (1 - x)
        
        # 💡 网络预测
        N = self.network(torch.cat([x, t], dim=1))
        
        # 💡 自动满足 Dirichlet 边界条件 u(0,t) = u(1,t) = 0
        u = D * N
        return u
```

### 5.4 Transfer Learning for PINNs

在相似问题间迁移学习：

1. 在源问题上预训练
2. 冻结前几层，微调后几层
3. 适应目标问题

---

## 6. 工具与资源

### 6.1 开源框架

| 框架 | 特点 | 链接 |
| ------ | ------ | ------ |
| DeepXDE | 多后端支持，易用 | [deepxde.readthedocs.io](https://deepxde.readthedocs.io/) |
| NVIDIA Modulus | 工业级，多GPU | [developer.nvidia.com/modulus](https://developer.nvidia.com/modulus) |
| SciANN | Keras 接口 | [github.com/sciann/sciann](https://github.com/sciann/sciann) |
| PyDEns | 配置驱动 | [github.com/analysiscenter/pydens](https://github.com/analysiscenter/pydens) |
| NeuralPDE.jl | Julia 生态 | [github.com/SciML/NeuralPDE.jl](https://github.com/SciML/NeuralPDE.jl) |

### 6.2 Benchmark 问题

- **热传导方程**：验证基本功能
- **Burgers 方程**：非线性对流
- **Allen-Cahn 方程**：相场模型
- **Navier-Stokes**：流体力学
- **Schrödinger 方程**：量子力学

---

## 总结

PINNs 家族正在快速发展：

| 变体 | 核心改进 | 适用场景 |
| ------ | ---------- | ---------- |
| hp-VPINNs | 弱形式 | 非光滑解、复杂边界 |
| XPINN | 区域分解 | 大规模问题 |
| DeepONet | 算子学习 | 参数化问题族 |
| FNO | 谱方法 | 周期性、大规模 |
| cPINNs | 守恒性 | 守恒律方程 |

选择合适的变体取决于：

1. **问题规模**：小问题用 PINNs，大问题用 XPINN/FNO
2. **数据可用性**：少数据用 PINNs，有数据用 DeepONet
3. **解的光滑性**：非光滑用 hp-VPINNs
4. **泛化需求**：需泛化用 DeepONet/FNO

---

## 参考资料

- Kharazmi, E., et al. (2021). hp-VPINNs: Variational physics-informed neural networks with domain decomposition. _CMAME_.
- Jagtap, A. D., & Karniadakis, G. E. (2020). Extended physics-informed neural networks (XPINNs). _CMAME_.
- Lu, L., et al. (2021). Learning nonlinear operators via DeepONet. _Nature Machine Intelligence_.
- Li, Z., et al. (2021). Fourier neural operator for parametric partial differential equations. _ICLR_.
