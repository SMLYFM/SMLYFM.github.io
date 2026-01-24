---
title: PyTorch自动微分机制详解
date: 2026-01-25 01:27:00
updated: 2026-01-25 01:27:00
categories:
  - pytorch
tags:
  - PyTorch
  - 深度学习
  - 自动微分
highlight_shrink: false
---

## 简介

PyTorch 的自动微分（Autograd）是其核心功能之一，它使得神经网络的梯度计算变得简单高效。

<!-- more -->

## 张量与梯度

创建需要梯度的张量：

```python
import torch

# 💡 requires_grad=True 启用梯度追踪
x = torch.tensor([2.0, 3.0], requires_grad=True)
y = x ** 2 + 2 * x + 1

# 计算梯度
y.backward(torch.ones_like(y))

print(x.grad)  # tensor([6., 8.])
# dy/dx = 2x + 2, 当 x=[2,3] 时，结果为 [6, 8]
```

## 计算图

PyTorch 动态构建计算图：

```python
import torch

a = torch.tensor([2.0], requires_grad=True)
b = torch.tensor([3.0], requires_grad=True)

c = a * b
d = c + a
e = d ** 2

# 反向传播
e.backward()

print(f"a.grad = {a.grad}")  # 2 * (a*b + a) * (b + 1) = 2 * 8 * 4 = 64
print(f"b.grad = {b.grad}")  # 2 * (a*b + a) * a = 2 * 8 * 2 = 32
```

## 禁用梯度计算

推理时禁用梯度以节省内存：

```python
# 方法1：使用上下文管理器
with torch.no_grad():
    y = model(x)

# 方法2：使用装饰器
@torch.no_grad()
def inference(model, x):
    return model(x)
```

## 自定义函数的梯度

```python
class MyReLU(torch.autograd.Function):
    @staticmethod
    def forward(ctx, input):
        ctx.save_for_backward(input)
        return input.clamp(min=0)
    
    @staticmethod
    def backward(ctx, grad_output):
        input, = ctx.saved_tensors
        grad_input = grad_output.clone()
        grad_input[input < 0] = 0
        return grad_input
```

## 总结

理解 PyTorch 的自动微分机制是深度学习开发的基础。

## 参考资料

- [PyTorch Autograd Tutorial](https://pytorch.org/tutorials/beginner/blitz/autograd_tutorial.html)
