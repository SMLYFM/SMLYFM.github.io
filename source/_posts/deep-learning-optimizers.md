---
title: 深度学习优化算法详解：从SGD到Adam
date: 2026-01-19 10:00:00
updated: 2026-01-23 22:00:00
categories:
  - 计算机
  - 深度学习
tags:
  - 优化算法
  - SGD
  - Adam
  - 深度学习
  - PyTorch
description: 详细介绍深度学习中常用的优化算法及其在PyTorch中的实现
---

# 深度学习优化算法详解

优化算法是深度学习训练的核心，选择合适的优化器对模型性能至关重要。

## 随机梯度下降 (SGD)

最基础的优化方法：

```python
optimizer = torch.optim.SGD(model.parameters(), lr=0.01, momentum=0.9)
```

### 特点

- 简单高效
- 需要仔细调整学习率
- 可能陷入鞍点

## Adam 优化器

结合动量和自适应学习率：

```python
optimizer = torch.optim.Adam(model.parameters(), lr=0.001, 
                              betas=(0.9, 0.999))
```

### 优势

- 自适应学习率
- 收敛快速
- 对超参数不敏感

## 实践建议

1. 对于CV任务，SGD+Momentum通常效果更好
2. 对于NLP任务，Adam是首选
3. 学习率调度策略很重要

---

**相关阅读**：

- 学习率调度
- 梯度裁剪
- 正则化技术
