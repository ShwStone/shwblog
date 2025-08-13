---
abbrlink: ''
categories:
- - 数学
comments: true
date: '2025-06-11T16:37:07.079662+08:00'
sticky: 12
tags:
- 线性代数
- 数学
title: MP伪逆和多元线性回归
updated: '2025-06-11T16:47:01.352+08:00'
---
<div></div>

<!--more-->

## 伪逆和广义逆

### 伪逆

#### 定义和性质

伪逆是一种针对**满秩矩阵**的概念。对于秩为 $r$，大小为 $n \times m$ 的矩阵 $A$，如果：

- $r = m \le n$，则存在唯一的左伪逆 $L \in \mathbb R^{m \times n}$ 使得 $LA = I_m$
- $r = n \le m$，则存在唯一的左伪逆 $R \in \mathbb R^{m \times n}$ 使得 $AR = I_n$

一个自然的点是，如果 $r = m = n$，则 $L,R$ 退化到 $A^{-1}$。

不难注意到一个特点：无论左伪逆还是右伪逆，形状都是 $A^\text T$ 的形状。这在记忆公式的时候非常有用。

左逆和右逆没有本质区别，因为 $R^\text TA^\text T = I_n$，所以 $R^\text T$ 是 $A^\text T$ 的左逆。

关于唯一性的证明不重要，但还是附上，以左伪逆为例：

> 如果存在 $L_1 A = L_2A = I_m$，则：
>
> - $A$ 在 $\mathbb R^n$ 到 $R(A)$ 上是一一映射，则 $L_1, L_2$ 在 $R(A)$ 上是相同的一一映射，即 $A$ 的逆映射。
> - 由于 $L_1,L_2$ 秩为 $n$，则对于任何 $y$ 正交于 $R(A)$，$L_1y = L_2y = 0$。
>
> 综上，对于任意 $y \in \mathbb R^m$，将其分解为 $y = y_R + y_N$，其中 $y_R \in R(A)$，$y_N$ 正交于 $R(A)$，则 $L_1 y = L_2 y = Ly_R$。说明 $L_1=L_2$。

#### 计算

$L, R$ 计算如下：

- $L = (A^\text TA)^{-1}A^\text T$
- $R = A^\text T(AA^\text T)^{-1}$

以 $L$ 为例进行说明：

> 引理：若 $r = m \le n$，即 $A$ 列满秩，则 $A^\text TA$ 可逆。
> 证明：在 $x \ne 0$ 时，由于 $A^\text T Ax = 0 \Rightarrow x^\text TA^\text T Ax = 0 \Leftrightarrow Ax = 0$，但是 $A$ 列满秩，不存在 $x \ne 0,Ax =0$，也就不存在 $A^\text T Ax = 0$，所以 $A^\text T A$ 列满秩。而它又是方阵，则 $A^\text TA$ 可逆。

既然存在 $L$，说明 $r = m \le n$，由引理 $A^\text T A \in \mathbb R^{m \times m}$ 是可逆，则

$$
LA = (A^\text T A)^{-1} A^\text T A = I_m
$$

### 普通广义逆

所谓广义逆，是**放弃了满秩要求**后更一般的逆。

对于一般矩阵 $A  \in \mathbb R^{n \times m}$，当 $r < \min(n, m)$ 时，不可能有任何矩阵 $A^-$ 满足 $AA^- = I$ 或 $A^-A = I$。此时的广义逆从线性方程组着手。

对于理想的逆，应该能够做到 $x = A^-y \Leftrightarrow Ax = y$。可惜 $A$ 不可逆。所以我们退而求其次，把充要条件换成充分条件：若 $x = A^-y \Rightarrow Ax = y$，称 $A^-$ 是 $A$ 的广义逆矩阵。

但是这个说法并不严谨，因为没有对 $y$ 的范围做限制，否则当 $A^-$ 不是单射的时候就不可能成立。

严谨的说，广义逆矩阵要满足：$\forall y \in R(A),A(A^-y) = y$。又因为 $\forall x,Ax \in R(A)$，所以：

$$
\forall x, AA^-Ax = Ax
$$

**即 $AA^-A = A$。这就是广义逆的充要条件。** 显然，伪逆是一种特殊的广义逆。

### 穆尔-彭罗斯（Moore–Penrose）广义逆

广义逆不是唯一的。有很多自由度：

1. 我们只规定了 $\forall y \in R(A)$，$A^-y$ 应该取什么值。但是对于 $y \perp R(A)$，我们没有任何限制。
2. 我们只规定了 $A(A^-y) = y$，但是没有指明 $A^-y$ 和 $\ker(A)$ 的关系，$A^-y$ 即使不和 $\ker A$ 正交也完全满足要求。

如果我们进一步，对 $A^-y$ 的取值做一些限定，就会得到要求更强的广义逆。M-P 逆从**最小化 L2 范数**出发，做出了如下要求：

- 对于 $y \in R(A)$，我们希望 $A^-y \perp \ker(A)$。
- 对于 $y \perp R(A)$，我们希望 $A^-y = 0$。

这样的广义逆，就是 Moore–Penrose 逆，我们用 $A^+$ 来表示。

> 这种逆的性质非常好，如下图所示：
>
> ![](https://images.shwstone.cn/images/M-P-inverse_a63202ce8c7e5d990bbcf11bb9e0f460.png)
>
> 左下示意的是 $\ker(A)$ 子空间，右上示意的是 $R(A)$ 子空间。左上是行空间 $R(A^\text T)$，它正交于 $\ker A$，他们的直和是 $\mathbb R^n$（注意这个图的 $A$ 是 $m \times n$ 的，和前文相反）；右下是左零空间 $\ker(A^\text T)$，它正交于 $R(A)$，它们的直和是 $\mathbb R_m$。这段话是”线性代数基本定理“，在这里不展开。
>
> M-P 逆是对空间的这种分割下最自然的逆：在 $R(A)$ 上，它是 $A$ 的逆映射；而在 $\ker(A^\text T)$ 上，它恒为零映射。

#### 四条件

上面补充的两个要求，加上广义逆本身要求的 $\forall y \in R(A),A(A^-y) = y$，一共三个要求。这三个要求和 M-P 四条件是等价的。这四个条件是：

1. $AA^-A = A$
2. $A^-AA^- = A^-$
3. $(AA^+)^\text T = AA^+$
4. $(A^+A)^\text T = A^\text +A$

> **证明：**
> **先证三条加强要求  $\implies$  Penrose 四条件**：
>
> - 条件1已显然：三条要求中的第三条就是 $AA^-A=A$ 。
> - 条件2（ $A^-AA^- = A^-$ ）
>   任取  $y\in\mathbb R^m$ ，分两种情况讨论。
>
>   - 若  $y\in R(A)$ ，则  $A^-y\perp \ker A$ ，又  $A(A^-y) = y$ ，即  $A^-y$  就是  $Ax = y$  的唯一最小范数解。而 $A^-AA^-y = A^- y$
>   - 若  $y\perp R(A)$ ，则  $A^-y=0$ ， $A^-AA^-y = A^-A 0 = 0 = A^-y$
>   - 综合即对任意  $y$ ， $A^-AA^- y = A^- y$ ，即  $A^-AA^- = A^-$
> - 条件3（ $AA^-$  对称）：
>   先观察  $AA^-$  是  $R(A)$  上的正交投影。对于  $v,w\in\mathbb R^m$ ，都有
>   $\langle v, AA^- w\rangle = \langle AA^-v, w\rangle$ ，
>   因为  $AA^-$  映向的是  $R(A)$ ， $A^-$  反解回到  $R(A^T)$ ，在分解正交的空间结构下 $AA^-$  自然是对称的。
> - 条件4（ $A^-A$  对称）：
>   同理， $A^-A$  是  $R(A^T)$  上的正交投影，亦对称。
>
> **再证 Penrose 四条件  $\implies$  这三条加强要求**：
>
> - 首先， $AA^-A = A$  保证只要  $y\in R(A)$ ， $A(A^-y)=y$ （广义逆定义）。
> - $A^-AA^- = A^-$  保证  $A^-y$  是所有  $Ax = y$  解中惟一与  $\ker(A)$  正交的那个。这就是“最小范数”要求。
> - $AA^-$ 、 $A^-A$  都是对称投影（正交投影），这意味着  $A^-y = 0$  对于  $y\perp R(A)$ ，即将正交补映为零。
>
> 综上，**这三条加强要求与 Moore–Penrose 四条件充要等价**。

**这种逆矩阵是存在且唯一的**。

存在性和唯一性的证明几乎是构造性的，这一节的第一个引用块就几乎说明了一切。

#### 计算

可以通过 SVD 分解计算 M-P 逆矩阵。

- 对于对角矩阵 $D$，其 M-P 逆 $D^+$ 恰为 $D^\text T$ 中所有非零元素取倒数的结果。
- 对于一般矩阵 $A$，设其 SVD 分解为 $A = U\Sigma V^\text T$，则其 M-P 逆为 $A^+ = V\Sigma^+U^\text T$。

这两个结果都可以通过带入四条件进行检验。

**特别地，如果 $A$ 可逆，退化为一般逆；如果 $A$ 行满秩或列满秩，退化为对应伪逆**。

注意计算时：

- **有没有计算 $\Sigma^+$**，是对 $\Sigma$ **转置后取倒数**。
- 是否算的是 $V\Sigma^+U^\text T$。**别把转置搞混了**！

## 多元线性回归

### 建模

有很多办法可以把问题建模为线性方程组。比如，给定散点数据 $X, \mathbf y$，其中：

$$
X = \begin{bmatrix}
    \mathbf x_1 ^\text T \\
    \mathbf x_2 ^\text T\\
    \vdots \\
    \mathbf x_n ^\text T\\
\end{bmatrix}, \mathbf x_i \in \mathbb R^m, \mathbf y \in \mathbb R^n
$$

$(\mathbf x_i, y_i)$ 是一组数据，也许是某个复杂现象的自变量-因变量对。这样的数据一共有 $n$ 组。

我们希望用线性方程来近似拟合这个一般函数。也即用如下方程：

$$
y = \mathbf x^\text T\beta + b_0
$$

不妨记 $\mathbf x_0 = \begin{bmatrix} \mathbf x \\ 1 \end{bmatrix},\beta_0 = \begin{bmatrix} \mathbf \beta \\ b_0 \end{bmatrix}$，方程重写如下：

$$
y = \mathbf x_0^\text T\beta_0
$$

$\beta_0$ 是参数，也是我们做拟合需要求出的东西。这样的话，记：

$$
X_0 = \begin{bmatrix}
    \mathbf x_1 ^\text T & 1 \\
    \mathbf x_2 ^\text T & 1 \\
    \vdots  & \vdots \\
    \mathbf x_n ^\text T & 1\\
\end{bmatrix}
$$

求 $\beta_0$ 就是求解线性方程组 $X_0\beta_0 = \mathbf y$。这就是把线性拟合问题建模为线性方程组的过程。

### M-P 逆求解

根据 M-P 逆的内容，对于任何一般的方程组 $A\mathbf x = \mathbf y$，我们总有一个 M-P 逆解：

$$
\mathbf{\hat x} = A^+\mathbf y
$$

这个解具有如下性质：

1. 若 $\mathbf y \in R(A)$，即原方程组有至少一个解，此时 $\mathbf{\hat x} \perp \ker(A)$。
2. 否则可以拆分 $\mathbf y = \mathbf y_R + \mathbf y_N$，其中 $\mathbf y_R \in R(A)$，$\mathbf y_N \perp R(A)$，则此时 $\mathbf{\hat x} = A^+(\mathbf y_R + \mathbf y_N) = A^+\mathbf y_R$。

#### 有解情况

对于第一条，我们回顾一下解线性方程组解的性质：

> 如果有解（此时 $\mathbf y \in R(A)$），通解的格式为 $\mathbf x = \mathbf{\bar x} + \mathbf x_0$。其中 $\mathbf{\bar x}$ 满足 $A\mathbf{\bar x} = \mathbf y$，而 $\mathbf x_0$ 是任意 $\ker(A)$ 中的向量。

此时可能有很多解，我们的 $\mathbf{\hat x}$ 有什么优势呢？

M-P 逆的优势在此：**在原方程组有解时，M-P 逆求得的解是所有解中 L2 范数最小的。**

> 证明：通解中的任何一个解都可以进行拆分：
>
> $$
> \mathbf x = \mathbf x_R + \mathbf x_N, \mathbf x_R \perp \ker(A), \mathbf x_N \in \ker(A)
> $$
>
> 由于通解的格式是 $\mathbf x = \mathbf{\bar x} + \mathbf x_0$，那个能变化的 $\mathbf x_0 \in \ker(A)$，所以**对于通解中的任意一个解，拆分后得到的 $\mathbf x_R$ 都是相同的，变化的部分只有 $\mathbf x_N$**。
>
> 进一步，考虑解的 L2 范数。因为 $\mathbf x_R$ 与 $\ker(A)$ 正交，自然也与 $\mathbf x_N$ 正交，所以：
>
> $$
> \Vert \mathbf x \Vert^2 = \Vert \mathbf x_R \Vert^2 + \Vert \mathbf x_N \Vert^2
> $$
>
> 前者对于通解中的所有解都是固定值，而后者非负。因此，所有通解中 L2 范数最小的那个必然满足 $\mathbf x_N = 0$，也即 $\mathbf x = \mathbf x_R \perp \ker(A)$。而我们又知道，M-P 逆求得的解恰好满足 $\mathbf{\hat x} \perp \ker(A)$，所以我们得到结论：在原方程组有解时，M-P 逆求得的解是所有解中 L2 范数最小的。

#### 无解情况

此时应用第二条性质。把 $\mathbf y$ 拆分成 $\mathbf y = \mathbf y_R + \mathbf y_N$，其中 $\mathbf y_R \in R(A)$，$\mathbf y_N \perp R(A)$。

既然原方程组无解，我们可以退而求其次，求一个误差最小的解。所谓误差，指的是这个向量：

$$
\mathbf e = \mathbf y - A\mathbf{\hat x} = (\mathbf y_R - A\mathbf{\hat x}) + \mathbf y_N
$$

此时 M-P 逆的优势如下：**在原方程无解时，M-P 逆求得的解是误差 L2 范数最小的，而且是误差范数最小的解中自身 L2 范数最小的。**

> 证明：运用和有解情况非常相似的分析方法：因为 $A\mathbf{\hat x} \in R(A),\mathbf y_R \in R(A)$，所以括号项也在 $R(A)$ 中；但是 $\mathbf y_N \perp R(A)$，所以上式的 L2 范数如下：
>
> $$
> \Vert \mathbf e \Vert^2 = \Vert \mathbf y_R - A\mathbf{\hat x} \Vert^2 + \Vert \mathbf y_N \Vert^2
> $$
>
> 第二项是和 $\mathbf{\hat x}$ 无关的，所以最小化 $\Vert \mathbf e \Vert$ 就是要最小化 $\Vert \mathbf y_R - A\mathbf{\hat x} \Vert$。不难发现这一项是可以取到 0 的，因为 $\mathbf y_R \in R(A)$，所以 $A\mathbf x = \mathbf y_R$ 必然有解。
>
> 根据性质二，$\mathbf y_R$ 的 M-P 逆解和 $\mathbf y$ 的 M-P 逆解是同一个；再根据有解情况的分析，M-P 逆的解 $\mathbf {\hat x}$ 是所有解里范数最小的，所以综合来说，M-P 逆解是误差范数最小的，而且是误差范数最小的解中自身范数最小的。

#### 总结

既然 M-P 逆求得的解在任何情况下都使得误差范数与自身范数同时最小，我们把这个解称作 $A\mathbf x = \mathbf y$ 的**最小二乘解**。

这个解在原方程有解时是 L2 范数最小的；在原方程无解时是使得误差 L2 范数最小的所有解中，自身 L2 范数最小的。

### 帽子矩阵

我们回到多元线性回归的情况。我们已经将它建模成了 $X_0\beta_0 = \mathbf y$ 的形式，因而可以求出参数 $\beta_0$ 的最小二乘解：

$$
\begin{aligned}
\hat \beta_0 &= X_0^+\mathbf y \\
\mathbf{\hat y} &= X_0X_0^+\mathbf y
\end{aligned}
$$

这和帽子矩阵有什么关系呢？

是这样的，最小二乘解适用于任何形态的方程，无论它是过定还是欠定，秩满还是秩亏。但是在回归分析的时候，最常见的情况是 $n \gg m$，即数据量远大于参数量，这种过定的情况下，一般 $X_0$ 都是**列满秩**的，即 $n \gg m+1 = \text{rank }A$。

此时，**M-P 逆退化成左伪逆**，也即：

$$
\begin{aligned}
\hat \beta_0 &= (X_0^\text TX_0)^{-1}X_0^\text T\mathbf y\\
\mathbf{\hat y} &= X_0(X_0^\text TX_0)^{-1}X_0^\text T\mathbf y
\end{aligned}
$$

其中，$X_0(X_0^\text TX_0)^{-1}X_0^\text T$ 是个 $n \times n$ 的对称矩阵，被称为帽子矩阵 $H$。

所以，所谓帽子矩阵，其实是 M-P 逆在列满秩时，$AA^+$ 的特殊情况。

这个矩阵是一个对称幂等阵，即：

- $H^\text T = H$
- $H^n = H$
- $(I - H)^n = I - H$。这一点可以展开后由第二点立刻得到。

而我们关心的另一个量 $\mathbf e = (I - H)\mathbf y$。
