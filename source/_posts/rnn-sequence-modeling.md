---
title: 循环神经网络 (RNN) 与序列建模
date: 2026-01-25 03:06:00
updated: 2026-01-25 03:06:00
categories:
  - 计算机
  - 深度学习
tags:
  - RNN
  - LSTM
  - GRU
  - 序列建模
  - 自然语言处理
  - 时间序列
mathjax: true
description: 深入讲解循环神经网络家族，包括 Vanilla RNN、LSTM、GRU 的原理、梯度问题及 PyTorch 实现
cover: https://images.unsplash.com/photo-1516110833967-0b5716ca1387?w=800
---

## 引言

循环神经网络（Recurrent Neural Network, RNN）是处理序列数据的经典模型。从自然语言处理到语音识别，从时间序列预测到音乐生成，RNN 及其变体在序列建模任务中发挥着重要作用。

<!-- more -->

## 1. 序列建模的挑战

### 1.1 序列数据的特点

序列数据的关键特性：

- **可变长度**：不同序列长度不同
- **顺序依赖**：元素的顺序蕴含信息
- **长程依赖**：远距离元素可能相关

### 1.2 前馈网络的局限

前馈网络（如 MLP）的问题：

1. **固定输入大小**：无法处理变长序列
2. **无记忆**：无法利用历史信息
3. **参数不共享**：不同位置独立处理

## 2. 标准 RNN

### 2.1 基本结构

RNN 的核心思想：**隐状态**（hidden state）在时间步之间传递。

$$\mathbf{h}_t = \tanh(\mathbf{W}_{hh}\mathbf{h}_{t-1} + \mathbf{W}_{xh}\mathbf{x}_t + \mathbf{b}_h)$$
$$\mathbf{y}_t = \mathbf{W}_{hy}\mathbf{h}_t + \mathbf{b}_y$$

其中：

- $\mathbf{x}_t$：时刻 $t$ 的输入
- $\mathbf{h}_t$：时刻 $t$ 的隐状态
- $\mathbf{y}_t$：时刻 $t$ 的输出

### 2.2 展开视图

将 RNN 在时间上展开：

```
x₀ → [RNN] → h₀ → y₀
       ↓
x₁ → [RNN] → h₁ → y₁
       ↓
x₂ → [RNN] → h₂ → y₂
       ↓
      ...
```

**权值共享**：所有时间步使用相同的权重矩阵。

### 2.3 不同的 RNN 架构

| 类型 | 输入 → 输出 | 应用 |
|------|------------|------|
| 一对一 | 单输入 → 单输出 | 普通前馈网络 |
| 一对多 | 单输入 → 序列 | 图像描述生成 |
| 多对一 | 序列 → 单输出 | 情感分类 |
| 多对多 | 序列 → 序列（同步） | 词性标注 |
| 多对多 | 序列 → 序列（异步） | 机器翻译 |

## 3. 梯度问题

### 3.1 时间上的反向传播 (BPTT)

损失对权重的梯度涉及链式法则：

$$\frac{\partial L}{\partial \mathbf{W}_{hh}} = \sum_{t=1}^{T} \sum_{k=1}^{t} \frac{\partial L_t}{\partial \mathbf{h}_t} \left( \prod_{j=k+1}^{t} \frac{\partial \mathbf{h}_j}{\partial \mathbf{h}_{j-1}} \right) \frac{\partial \mathbf{h}_k}{\partial \mathbf{W}_{hh}}$$

### 3.2 梯度消失

$$\frac{\partial \mathbf{h}_t}{\partial \mathbf{h}_{t-1}} = \mathbf{W}_{hh}^T \text{diag}(\tanh'(\cdot))$$

如果 $\|\mathbf{W}_{hh}\|$ 较小或 $\tanh'$ 接近 0，梯度会指数级衰减：

$$\left\| \prod_{j=k+1}^{t} \frac{\partial \mathbf{h}_j}{\partial \mathbf{h}_{j-1}} \right\| \approx 0 \quad \text{当 } t - k \text{ 较大时}$$

**后果**：无法学习长程依赖。

### 3.3 梯度爆炸

如果 $\|\mathbf{W}_{hh}\|$ 较大，梯度会指数级增长。

**解决方案**：梯度裁剪（Gradient Clipping）

```python
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=5.0)
```

## 4. 长短期记忆网络 (LSTM)

### 4.1 核心思想

LSTM 引入**门控机制**（gating mechanism）：

- **遗忘门**：决定丢弃哪些旧信息
- **输入门**：决定存储哪些新信息
- **输出门**：决定输出哪些信息

### 4.2 数学公式

**遗忘门**：
$$\mathbf{f}_t = \sigma(\mathbf{W}_f[\mathbf{h}_{t-1}, \mathbf{x}_t] + \mathbf{b}_f)$$

**输入门**：
$$\mathbf{i}_t = \sigma(\mathbf{W}_i[\mathbf{h}_{t-1}, \mathbf{x}_t] + \mathbf{b}_i)$$

**候选记忆**：
$$\tilde{\mathbf{c}}_t = \tanh(\mathbf{W}_c[\mathbf{h}_{t-1}, \mathbf{x}_t] + \mathbf{b}_c)$$

**记忆更新**：
$$\mathbf{c}_t = \mathbf{f}_t \odot \mathbf{c}_{t-1} + \mathbf{i}_t \odot \tilde{\mathbf{c}}_t$$

**输出门**：
$$\mathbf{o}_t = \sigma(\mathbf{W}_o[\mathbf{h}_{t-1}, \mathbf{x}_t] + \mathbf{b}_o)$$

**隐状态输出**：
$$\mathbf{h}_t = \mathbf{o}_t \odot \tanh(\mathbf{c}_t)$$

### 4.3 为什么 LSTM 有效

**记忆单元 $\mathbf{c}_t$** 的梯度路径：
$$\frac{\partial \mathbf{c}_t}{\partial \mathbf{c}_{t-1}} = \mathbf{f}_t$$

- 遗忘门 $\mathbf{f}_t$ 接近 1 时，梯度直接传递
- 形成**恒等映射**，类似于 ResNet 的跳跃连接
- 缓解梯度消失问题

## 5. 门控循环单元 (GRU)

### 5.1 简化的门控

GRU 是 LSTM 的简化版本，只有两个门：

**更新门**：
$$\mathbf{z}_t = \sigma(\mathbf{W}_z[\mathbf{h}_{t-1}, \mathbf{x}_t])$$

**重置门**：
$$\mathbf{r}_t = \sigma(\mathbf{W}_r[\mathbf{h}_{t-1}, \mathbf{x}_t])$$

**候选隐状态**：
$$\tilde{\mathbf{h}}_t = \tanh(\mathbf{W}[\mathbf{r}_t \odot \mathbf{h}_{t-1}, \mathbf{x}_t])$$

**隐状态更新**：
$$\mathbf{h}_t = (1 - \mathbf{z}_t) \odot \mathbf{h}_{t-1} + \mathbf{z}_t \odot \tilde{\mathbf{h}}_t$$

### 5.2 LSTM vs GRU

| 特性 | LSTM | GRU |
|------|------|-----|
| 门数量 | 3 (遗忘、输入、输出) | 2 (更新、重置) |
| 参数量 | 较多 | 较少 |
| 记忆 | 分离的 $\mathbf{c}$ 和 $\mathbf{h}$ | 只有 $\mathbf{h}$ |
| 训练速度 | 较慢 | 较快 |
| 性能 | 通常相当 | 通常相当 |

## 6. 双向 RNN

### 6.1 动机

单向 RNN 只能看到过去的信息。对于某些任务（如标注），未来的上下文也很重要。

### 6.2 结构

```
→ 前向 RNN：x₀ → x₁ → x₂ → x₃
← 后向 RNN：x₃ ← x₂ ← x₁ ← x₀

输出 = concat(前向隐状态, 后向隐状态)
```

### 6.3 PyTorch 实现

```python
rnn = nn.LSTM(
    input_size=embedding_dim,
    hidden_size=hidden_dim,
    num_layers=2,
    bidirectional=True,  # 启用双向
    dropout=0.5
)
# 输出维度变为 2 * hidden_dim
```

## 7. 深层 RNN

### 7.1 堆叠多层

```
Input → RNN Layer 1 → RNN Layer 2 → ... → Output
```

第 $l$ 层的输入是第 $l-1$ 层的输出（隐状态序列）。

### 7.2 残差连接

对于深层 RNN，加入残差连接：

$$\mathbf{h}_t^{(l)} = \text{RNN}(\mathbf{h}_{t-1}^{(l)}, \mathbf{h}_t^{(l-1)}) + \mathbf{h}_t^{(l-1)}$$

## 8. PyTorch 实现

### 8.1 基本 LSTM

```python
import torch
import torch.nn as nn

class LSTMClassifier(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, num_classes):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.lstm = nn.LSTM(
            input_size=embed_dim,
            hidden_size=hidden_dim,
            num_layers=2,
            batch_first=True,
            dropout=0.5,
            bidirectional=True
        )
        self.fc = nn.Linear(hidden_dim * 2, num_classes)
        self.dropout = nn.Dropout(0.5)
    
    def forward(self, x):
        # x: (batch, seq_len)
        embedded = self.dropout(self.embedding(x))  # (batch, seq_len, embed_dim)
        
        # LSTM 输出
        output, (h_n, c_n) = self.lstm(embedded)
        # output: (batch, seq_len, hidden*2)
        # h_n: (num_layers*2, batch, hidden)
        
        # 取最后时刻的隐状态
        # 拼接前向和后向的最后一层
        hidden = torch.cat([h_n[-2], h_n[-1]], dim=1)  # (batch, hidden*2)
        
        out = self.fc(self.dropout(hidden))
        return out
```

### 8.2 序列到序列 (Seq2Seq)

```python
class Encoder(nn.Module):
    def __init__(self, input_dim, embed_dim, hidden_dim, n_layers, dropout):
        super().__init__()
        self.embedding = nn.Embedding(input_dim, embed_dim)
        self.rnn = nn.GRU(embed_dim, hidden_dim, n_layers, dropout=dropout)
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, src):
        # src: (src_len, batch)
        embedded = self.dropout(self.embedding(src))
        outputs, hidden = self.rnn(embedded)
        return hidden

class Decoder(nn.Module):
    def __init__(self, output_dim, embed_dim, hidden_dim, n_layers, dropout):
        super().__init__()
        self.output_dim = output_dim
        self.embedding = nn.Embedding(output_dim, embed_dim)
        self.rnn = nn.GRU(embed_dim, hidden_dim, n_layers, dropout=dropout)
        self.fc = nn.Linear(hidden_dim, output_dim)
        self.dropout = nn.Dropout(dropout)
    
    def forward(self, input, hidden):
        # input: (batch,) - 单个时间步
        input = input.unsqueeze(0)  # (1, batch)
        embedded = self.dropout(self.embedding(input))
        output, hidden = self.rnn(embedded, hidden)
        prediction = self.fc(output.squeeze(0))
        return prediction, hidden

class Seq2Seq(nn.Module):
    def __init__(self, encoder, decoder, device):
        super().__init__()
        self.encoder = encoder
        self.decoder = decoder
        self.device = device
    
    def forward(self, src, trg, teacher_forcing_ratio=0.5):
        batch_size = trg.shape[1]
        trg_len = trg.shape[0]
        trg_vocab_size = self.decoder.output_dim
        
        outputs = torch.zeros(trg_len, batch_size, trg_vocab_size).to(self.device)
        hidden = self.encoder(src)
        
        input = trg[0, :]  # <sos> token
        
        for t in range(1, trg_len):
            output, hidden = self.decoder(input, hidden)
            outputs[t] = output
            
            # Teacher forcing
            teacher_force = random.random() < teacher_forcing_ratio
            top1 = output.argmax(1)
            input = trg[t] if teacher_force else top1
        
        return outputs
```

### 8.3 语言模型

```python
class LanguageModel(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, num_layers):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.lstm = nn.LSTM(embed_dim, hidden_dim, num_layers, batch_first=True)
        self.fc = nn.Linear(hidden_dim, vocab_size)
    
    def forward(self, x, hidden=None):
        embedded = self.embedding(x)
        output, hidden = self.lstm(embedded, hidden)
        logits = self.fc(output)
        return logits, hidden
    
    def generate(self, start_token, max_len=100, temperature=1.0):
        self.eval()
        tokens = [start_token]
        hidden = None
        
        with torch.no_grad():
            for _ in range(max_len):
                x = torch.tensor([[tokens[-1]]])
                logits, hidden = self.forward(x, hidden)
                
                # 温度采样
                probs = F.softmax(logits[0, -1] / temperature, dim=0)
                next_token = torch.multinomial(probs, 1).item()
                
                tokens.append(next_token)
                if next_token == eos_token:
                    break
        
        return tokens
```

## 9. RNN 的现代替代

### 9.1 Transformer

注意力机制替代循环结构：

- 并行计算，训练更快
- 直接建模长程依赖
- 但需要更多内存

### 9.2 状态空间模型 (SSM)

如 Mamba，结合 RNN 的高效推理和 Transformer 的并行训练。

### 9.3 RNN 仍有价值的场景

- 流式处理（实时语音识别）
- 资源受限设备
- 极长序列（某些情况）

## 总结

RNN 家族的核心思想：

1. **隐状态**：携带序列历史信息
2. **权值共享**：处理可变长度输入
3. **门控机制**：LSTM/GRU 解决梯度问题
4. **双向处理**：利用未来上下文
5. **深层堆叠**：增加表达能力

虽然 Transformer 在许多任务上超越了 RNN，但理解 RNN 仍然重要，因为它揭示了序列建模的核心挑战和解决思路。

## 参考资料

- Hochreiter, S. & Schmidhuber, J. *Long Short-Term Memory*, 1997
- Cho, K. et al. *Learning Phrase Representations using RNN Encoder-Decoder*, 2014
- Goodfellow, I. et al. *Deep Learning*, Chapter 10, 2016
- [colah's blog: Understanding LSTM Networks](https://colah.github.io/posts/2015-08-Understanding-LSTMs/)
