---
title: TikZ 高级绘图技巧：从基础到精通
date: 2026-01-25 14:10:00
updated: 2026-01-25 14:10:00
categories:
  - 工具与写作
  - LaTeX
tags:
  - TikZ
  - LaTeX
  - 科学绘图
  - 学术写作
description: 深入介绍 TikZ 绘图包的高级技巧，包括数学图形、神经网络架构图、物理示意图和流程图的绘制方法
mathjax: true
---

## 简介

TikZ 是 LaTeX 中最强大的绘图包之一，由 Till Tantau 开发。它能够在 LaTeX 文档中直接绘制高质量的矢量图形，特别适合学术论文中的数学图形、流程图、神经网络架构图等。

<!-- more -->

## 1. TikZ 基础

### 1.1 环境设置

```latex
\documentclass{article}
\usepackage{tikz}
\usetikzlibrary{arrows.meta, positioning, shapes, calc, patterns, decorations.pathmorphing}

\begin{document}
\begin{tikzpicture}
  % 绘图代码
\end{tikzpicture}
\end{document}
```

### 1.2 坐标系统

TikZ 支持多种坐标系统：

```latex
\begin{tikzpicture}
  % 笛卡尔坐标
  \draw (0,0) -- (2,1);
  
  % 极坐标 (角度:半径)
  \draw (0,0) -- (45:2);
  
  % 相对坐标
  \draw (1,1) -- ++(1,0) -- ++(0,1);
  
  % 命名坐标
  \coordinate (A) at (0,0);
  \coordinate (B) at (3,2);
  \draw (A) -- (B);
\end{tikzpicture}
```

### 1.3 基本形状

```latex
\begin{tikzpicture}
  % 矩形
  \draw (0,0) rectangle (2,1);
  
  % 圆形
  \draw (4,0.5) circle (0.5);
  
  % 椭圆
  \draw (7,0.5) ellipse (1 and 0.5);
  
  % 圆弧
  \draw (10,0) arc (0:90:1);
  
  % 填充
  \fill[blue!30] (12,0) rectangle (14,1);
  
  % 填充+边框
  \filldraw[fill=red!20, draw=red] (16,0.5) circle (0.5);
\end{tikzpicture}
```

---

## 2. 数学图形绘制

### 2.1 函数图像

绘制 $f(x) = \sin(x)$ 和 $g(x) = \cos(x)$：

```latex
\begin{tikzpicture}[scale=0.8]
  % 坐标轴
  \draw[->] (-0.5,0) -- (7,0) node[right] {$x$};
  \draw[->] (0,-1.5) -- (0,1.5) node[above] {$y$};
  
  % 网格
  \draw[gray!30, very thin] (-0.5,-1.5) grid (6.5,1.5);
  
  % sin(x) 曲线
  \draw[blue, thick, domain=0:6.28, samples=100] 
    plot (\x, {sin(\x r)}) node[right] {$\sin(x)$};
  
  % cos(x) 曲线
  \draw[red, thick, domain=0:6.28, samples=100] 
    plot (\x, {cos(\x r)}) node[right] {$\cos(x)$};
  
  % 刻度
  \foreach \x in {1.57, 3.14, 4.71, 6.28} {
    \draw (\x, 0.1) -- (\x, -0.1);
  }
  \node[below] at (1.57, -0.1) {$\frac{\pi}{2}$};
  \node[below] at (3.14, -0.1) {$\pi$};
  \node[below] at (4.71, -0.1) {$\frac{3\pi}{2}$};
  \node[below] at (6.28, -0.1) {$2\pi$};
\end{tikzpicture}
```

### 2.2 3D 曲面

绘制三维曲面 $z = \sin(x)\cos(y)$：

```latex
\usepackage{tikz-3dplot}

\begin{tikzpicture}
  \tdplotsetmaincoords{70}{110}
  \begin{scope}[tdplot_main_coords]
    % 坐标轴
    \draw[->] (0,0,0) -- (4,0,0) node[right] {$x$};
    \draw[->] (0,0,0) -- (0,4,0) node[above] {$y$};
    \draw[->] (0,0,0) -- (0,0,3) node[above] {$z$};
    
    % 绘制曲面网格
    \foreach \x in {0,0.5,...,3} {
      \draw[blue!50] plot[domain=0:3, samples=20] 
        (\x, \x, {sin(\x*60)*cos(\x*60)});
    }
  \end{scope}
\end{tikzpicture}
```

### 2.3 向量场

绘制二维向量场 $\mathbf{F}(x,y) = (-y, x)$：

```latex
\begin{tikzpicture}
  % 网格上的向量
  \foreach \x in {-2,-1,0,1,2} {
    \foreach \y in {-2,-1,0,1,2} {
      \pgfmathsetmacro{\vx}{-\y*0.3}
      \pgfmathsetmacro{\vy}{\x*0.3}
      \draw[->, blue, thick] (\x,\y) -- ++(\vx,\vy);
    }
  }
  
  % 坐标轴
  \draw[->] (-3,0) -- (3,0) node[right] {$x$};
  \draw[->] (0,-3) -- (0,3) node[above] {$y$};
\end{tikzpicture}
```

---

## 3. 神经网络架构图

### 3.1 多层感知机 (MLP)

```latex
\begin{tikzpicture}[
  node distance=1.5cm,
  neuron/.style={circle, draw, minimum size=8mm, thick},
  input neuron/.style={neuron, fill=green!30},
  hidden neuron/.style={neuron, fill=blue!30},
  output neuron/.style={neuron, fill=red!30},
  annot/.style={text width=4em, text centered}
]

% 输入层
\foreach \y in {1,...,4}
  \node[input neuron] (I-\y) at (0,-\y) {};

% 隐藏层 1
\foreach \y in {1,...,5}
  \node[hidden neuron] (H1-\y) at (2.5,-\y+0.5) {};

% 隐藏层 2
\foreach \y in {1,...,5}
  \node[hidden neuron] (H2-\y) at (5,-\y+0.5) {};

% 输出层
\foreach \y in {1,...,2}
  \node[output neuron] (O-\y) at (7.5,-\y-1) {};

% 连接
\foreach \source in {1,...,4}
  \foreach \dest in {1,...,5}
    \draw[->] (I-\source) -- (H1-\dest);

\foreach \source in {1,...,5}
  \foreach \dest in {1,...,5}
    \draw[->] (H1-\source) -- (H2-\dest);

\foreach \source in {1,...,5}
  \foreach \dest in {1,...,2}
    \draw[->] (H2-\source) -- (O-\dest);

% 标签
\node[annot, above of=I-1, node distance=1cm] {输入层};
\node[annot, above of=H1-1, node distance=1cm] {隐藏层1};
\node[annot, above of=H2-1, node distance=1cm] {隐藏层2};
\node[annot, above of=O-1, node distance=1cm] {输出层};

\end{tikzpicture}
```

### 3.2 卷积神经网络层

```latex
\begin{tikzpicture}[
  cube/.style={draw, thick, fill opacity=0.7},
  arrow/.style={->, thick, >=stealth}
]

% 输入特征图
\foreach \z in {0,0.2,0.4} {
  \draw[cube, fill=blue!30] (0+\z,0+\z) rectangle (2+\z,2+\z);
}
\node[below] at (1.2, -0.3) {输入 $28 \times 28 \times 3$};

% 卷积核
\draw[arrow] (2.8,1) -- (3.8,1) node[midway, above] {Conv};

% 特征图 1
\foreach \z in {0,0.15,...,0.6} {
  \draw[cube, fill=green!30] (4+\z,0.3+\z) rectangle (5.4+\z,1.7+\z);
}
\node[below] at (5, -0.3) {$24 \times 24 \times 16$};

% 池化
\draw[arrow] (6.2,1) -- (7.2,1) node[midway, above] {Pool};

% 特征图 2
\foreach \z in {0,0.15,...,0.6} {
  \draw[cube, fill=yellow!30] (7.5+\z,0.5+\z) rectangle (8.5+\z,1.5+\z);
}
\node[below] at (8.3, -0.3) {$12 \times 12 \times 16$};

\end{tikzpicture}
```

### 3.3 Transformer 架构

```latex
\begin{tikzpicture}[
  block/.style={draw, rounded corners, minimum width=3cm, minimum height=0.8cm, thick},
  arrow/.style={->, thick, >=stealth}
]

% Encoder
\node[block, fill=blue!20] (embed) at (0,0) {Embedding};
\node[block, fill=blue!30] (pe) at (0,1.2) {Positional Encoding};
\node[block, fill=orange!30] (mha) at (0,2.8) {Multi-Head Attention};
\node[block, fill=green!30] (ffn) at (0,4.4) {Feed Forward};
\node[block, fill=purple!20] (norm1) at (0,3.6) {Add \& Norm};
\node[block, fill=purple!20] (norm2) at (0,5.2) {Add \& Norm};

% 连接
\draw[arrow] (embed) -- (pe);
\draw[arrow] (pe) -- (mha);
\draw[arrow] (mha) -- (norm1);
\draw[arrow] (norm1) -- (ffn);
\draw[arrow] (ffn) -- (norm2);

% 残差连接
\draw[arrow, dashed] (pe.east) -- ++(0.8,0) |- (norm1.east);
\draw[arrow, dashed] (norm1.east) -- ++(1,0) |- (norm2.east);

% 标签
\node[left] at (-2, 3) {\textbf{Encoder Block}};

\end{tikzpicture}
```

---

## 4. 物理示意图

### 4.1 光学系统

```latex
\begin{tikzpicture}
  % 光源
  \fill[yellow] (-3,0) circle (0.2);
  \node[below] at (-3,-0.3) {光源};
  
  % 入射光线
  \draw[red, thick, ->] (-2.8,0) -- (-0.1,0);
  
  % 凸透镜
  \draw[thick, fill=cyan!20] (0,0) ellipse (0.15 and 1.2);
  \node[below] at (0,-1.5) {凸透镜};
  
  % 折射光线
  \draw[red, thick, ->] (0.1,0) -- (2,0);
  \draw[red, thick, ->] (0.1,0.3) -- (2,0);
  \draw[red, thick, ->] (0.1,-0.3) -- (2,0);
  
  % 焦点
  \fill[blue] (2,0) circle (0.1);
  \node[below] at (2,-0.3) {焦点 $F$};
  
  % 光轴
  \draw[dashed] (-3.5,0) -- (3,0);
  
  % 焦距标注
  \draw[<->] (0,-1) -- (2,-1) node[midway, below] {$f$};
\end{tikzpicture}
```

### 4.2 电路图

```latex
\usepackage{circuitikz}

\begin{circuitikz}[american]
  % 电路元件
  \draw (0,0) to[V, l=$V_s$] (0,3)
        to[R, l=$R_1$] (3,3)
        to[L, l=$L$] (3,0)
        to[C, l=$C$] (0,0);
  
  % 并联电阻
  \draw (3,3) to[R, l=$R_2$] (6,3)
        to[short] (6,0)
        to[short] (3,0);
  
  % 接地
  \draw (3,0) node[ground] {};
  
  % 电流标注
  \draw[->, blue] (1.5,3.3) -- (2.5,3.3) node[midway, above] {$I$};
\end{circuitikz}
```

### 4.3 力学分析图

```latex
\begin{tikzpicture}
  % 物体
  \draw[thick, fill=gray!30] (0,0) rectangle (2,1.5);
  \node at (1,0.75) {$m$};
  
  % 重力
  \draw[->, thick, red] (1,0) -- (1,-1.5) node[right] {$m\vec{g}$};
  
  % 支持力
  \draw[->, thick, blue] (1,1.5) -- (1,3) node[right] {$\vec{N}$};
  
  % 摩擦力
  \draw[->, thick, green!60!black] (0,0.75) -- (-1.5,0.75) node[left] {$\vec{f}$};
  
  % 拉力
  \draw[->, thick, orange] (2,0.75) -- (4,1.5) node[right] {$\vec{F}$};
  
  % 角度标注
  \draw[dashed] (2,0.75) -- (4,0.75);
  \draw (3,0.75) arc (0:20:1) node[midway, right] {$\theta$};
  
  % 地面
  \fill[pattern=north east lines] (-1,-0.3) rectangle (3,0);
  \draw[thick] (-1,0) -- (3,0);
\end{tikzpicture}
```

---

## 5. 流程图与状态图

### 5.1 算法流程图

```latex
\usetikzlibrary{shapes.geometric}

\begin{tikzpicture}[
  node distance=1.5cm,
  startstop/.style={rectangle, rounded corners, minimum width=3cm, minimum height=1cm, text centered, draw, fill=red!30},
  process/.style={rectangle, minimum width=3cm, minimum height=1cm, text centered, draw, fill=blue!30},
  decision/.style={diamond, minimum width=3cm, minimum height=1cm, text centered, draw, fill=green!30},
  arrow/.style={thick, ->, >=stealth}
]

\node (start) [startstop] {开始};
\node (input) [process, below of=start] {输入 $n$};
\node (init) [process, below of=input] {$sum = 0, i = 1$};
\node (decision) [decision, below of=init, yshift=-0.5cm] {$i \leq n$?};
\node (add) [process, right of=decision, xshift=3cm] {$sum = sum + i$};
\node (inc) [process, below of=add] {$i = i + 1$};
\node (output) [process, below of=decision, yshift=-1.5cm] {输出 $sum$};
\node (stop) [startstop, below of=output] {结束};

\draw [arrow] (start) -- (input);
\draw [arrow] (input) -- (init);
\draw [arrow] (init) -- (decision);
\draw [arrow] (decision) -- node[above] {是} (add);
\draw [arrow] (add) -- (inc);
\draw [arrow] (inc) -- ++(-3,0) |- (decision);
\draw [arrow] (decision) -- node[right] {否} (output);
\draw [arrow] (output) -- (stop);

\end{tikzpicture}
```

### 5.2 有限状态机

```latex
\usetikzlibrary{automata}

\begin{tikzpicture}[
  ->, >=stealth, 
  node distance=3cm, 
  every state/.style={thick, fill=gray!10}
]

\node[state, initial] (q0) {$q_0$};
\node[state] (q1) [right of=q0] {$q_1$};
\node[state] (q2) [right of=q1] {$q_2$};
\node[state, accepting] (q3) [right of=q2] {$q_3$};

\path (q0) edge [bend left] node [above] {$a$} (q1)
      (q0) edge [loop above] node {$b$} (q0)
      (q1) edge [bend left] node [above] {$b$} (q2)
      (q1) edge [bend left] node [below] {$a$} (q0)
      (q2) edge [bend left] node [above] {$a$} (q3)
      (q2) edge [loop above] node {$b$} (q2)
      (q3) edge [bend left] node [below] {$a,b$} (q0);

\end{tikzpicture}
```

---

## 6. 高级技巧

### 6.1 使用 foreach 循环

```latex
\begin{tikzpicture}
  % 绘制正多边形
  \foreach \n in {3,4,5,6,7,8} {
    \pgfmathsetmacro{\xshift}{(\n-3)*2.5}
    \begin{scope}[shift={(\xshift,0)}]
      \foreach \i in {1,...,\n} {
        \pgfmathsetmacro{\angle}{90 + 360/\n*(\i-1)}
        \coordinate (P\i) at (\angle:1);
      }
      \draw[thick, fill=blue!\n0!white] (P1)
        \foreach \i in {2,...,\n} { -- (P\i) } -- cycle;
      \node[below] at (0,-1.3) {$n = \n$};
    \end{scope}
  }
\end{tikzpicture}
```

### 6.2 使用 calc 库进行坐标计算

```latex
\usetikzlibrary{calc}

\begin{tikzpicture}
  \coordinate (A) at (0,0);
  \coordinate (B) at (4,0);
  \coordinate (C) at (2,3);
  
  % 绘制三角形
  \draw[thick] (A) -- (B) -- (C) -- cycle;
  
  % 中点
  \coordinate (MAB) at ($(A)!0.5!(B)$);
  \coordinate (MBC) at ($(B)!0.5!(C)$);
  \coordinate (MCA) at ($(C)!0.5!(A)$);
  
  % 重心
  \coordinate (G) at ($(A)!0.333!($(B)!0.5!(C)$)$);
  
  % 中线
  \draw[dashed, blue] (A) -- (MBC);
  \draw[dashed, blue] (B) -- (MCA);
  \draw[dashed, blue] (C) -- (MAB);
  
  % 标注
  \fill[red] (G) circle (2pt) node[right] {重心 $G$};
  
  \node[left] at (A) {$A$};
  \node[right] at (B) {$B$};
  \node[above] at (C) {$C$};
\end{tikzpicture}
```

### 6.3 装饰路径

```latex
\usetikzlibrary{decorations.pathmorphing, decorations.markings}

\begin{tikzpicture}
  % 波浪线
  \draw[thick, decorate, decoration={snake, amplitude=2mm, segment length=5mm}]
    (0,0) -- (4,0) node[right] {波浪线};
  
  % 锯齿线
  \draw[thick, decorate, decoration={zigzag, amplitude=2mm, segment length=3mm}]
    (0,-1) -- (4,-1) node[right] {锯齿线};
  
  % 弹簧
  \draw[thick, decorate, decoration={coil, aspect=0.5, amplitude=3mm, segment length=2mm}]
    (0,-2) -- (4,-2) node[right] {弹簧};
  
  % 带箭头的路径
  \draw[thick, decorate, decoration={markings, mark=at position 0.5 with {\arrow{>}}}]
    (0,-3) -- (4,-3) node[right] {中点箭头};
\end{tikzpicture}
```

---

## 7. 实用模板

### 7.1 PINNs 架构图模板

```latex
\begin{tikzpicture}[
  block/.style={draw, rounded corners, minimum width=2cm, minimum height=0.8cm, thick, fill=#1},
  block/.default=white,
  arrow/.style={->, thick, >=stealth}
]

% 输入
\node[block=green!20] (input) at (0,0) {$(x, t)$};

% 神经网络
\node[block=blue!20] (nn) at (3,0) {$\mathcal{NN}_\theta$};

% 输出
\node[block=yellow!20] (output) at (6,0) {$u_\theta(x,t)$};

% 自动微分
\node[block=orange!20] (ad) at (6,-2) {自动微分};

% PDE 残差
\node[block=red!20] (pde) at (3,-2) {$\mathcal{N}[u_\theta] - f$};

% 损失函数
\node[block=purple!20] (loss) at (3,-4) {$\mathcal{L} = \mathcal{L}_{data} + \mathcal{L}_{PDE}$};

% 连接
\draw[arrow] (input) -- (nn);
\draw[arrow] (nn) -- (output);
\draw[arrow] (output) -- (ad);
\draw[arrow] (ad) -- (pde);
\draw[arrow] (pde) -- (loss);

% 反向传播
\draw[arrow, dashed, gray] (loss) -- ++(-4,0) |- (nn);
\node[gray] at (-0.5,-2) {反向传播};

\end{tikzpicture}
```

---

## 总结

TikZ 是 LaTeX 中绑定绘图的瑞士军刀，掌握它可以：

1. **提高论文质量**：矢量图形清晰美观
2. **保持一致性**：图形与文档字体、样式统一
3. **可编程绘图**：通过代码精确控制图形
4. **版本控制**：图形代码可纳入 Git 管理

## 参考资料

- [TikZ & PGF Manual](https://tikz.dev/)
- [TikZ Examples Gallery](https://texample.net/tikz/examples/)
- [CircuiTikZ Documentation](https://www.ctan.org/pkg/circuitikz)
- [TikZ-3dplot Package](https://www.ctan.org/pkg/tikz-3dplot)
