---
abbrlink: ''
categories:
- - 概率论
comments: true
date: '2025-04-16T11:44:29.472744+08:00'
sticky: 12
tags:
- 概率论
title: Gamma分布——又是泊松过程？
updated: '2025-04-16T11:47:21.508+08:00'
---
前置：[两个分布与泊松过程](https://shwstone.cn/2025/03/15/%E4%B8%A4%E4%B8%AA%E5%88%86%E5%B8%83%E4%B8%8E%E6%B3%8A%E6%9D%BE%E8%BF%87%E7%A8%8B/)

<!--more-->

## 还是泊松过程

如果说指数分布描述了第一次成功事件的等待时间，那么它的“同门师兄”——**Gamma分布**，则将这种等待诠释得更为深刻：它刻画了在连续时间轴上，等待第 $n$ 次泊松事件（如潜艇发射鱼雷、网络数据包到达）所需的时间。

在开始前，我们给出 Gamma 分布的数学定义：

这是一个连续型分布，有两个参数 $\alpha$（形状参数，$\in \mathbb{N}_+$）和 $\beta$（速率参数，$\beta>0$），其概率密度函数为：

$$
p(t; \alpha, \beta) = \frac{\beta^\alpha t^{\alpha-1} \mathrm{e}^{-\beta t}}{\Gamma(\alpha)} \quad (t \ge 0)
$$

这里 $\Gamma(\alpha) = (\alpha-1)!$ 是 Gamma 函数，当 $\alpha$ 为自然数时退化为阶乘。

![Gamma 分布示意图](https://images.shwstone.cn/images/gamma_9693d86ebff05cc568423ad2278a7c95.png)

Gamma 分布在 $\alpha=1$ 时退化为指数分布 $\text{Exp}(\beta)$，这暗示一个直观的猜想：或许 Gamma 分布是 $n$ 个独立的指数分布变量之和？

**答案是肯定的**，这正是它与泊松过程的关联所在。

在[之前的分析](https://shwstone.cn/2025/03/15/%E4%B8%A4%E4%B8%AA%E5%88%86%E5%B8%83%E4%B8%8E%E6%B3%8A%E6%9D%BE%E8%BF%87%E7%A8%8B/)中，我们已知泊松过程的独立增量和平稳增量特性，使得：

1. **第一次到达时间**服从参数为 $\lambda$ 的指数分布 $T_1 \sim \text{Exp}(\lambda)$。
2. **相邻两次到达时间的间隔**同样服从 $\text{Exp}(\lambda)$，且与此前事件数无记忆（无关联）。

这启发我们：**第n次到达时间 $T_n$ 就是n个独立的 $\text{Exp}(\lambda)$ 变量之和**。

即：

$$
T_n = \underbrace{X_1 + X_2 + \cdots + X_n}_{n \text{个间隔之和}}, \quad \text{其中} X_i \stackrel{\text{iid}}{\sim} \text{Exp}(\lambda)
$$

### 卷积验证

我们知道，计算随机变量的和需要使用卷积。不妨做点计算，我们一步步计算 $T_n$ 的分布：

- 当 $n=1$ 时，$T_1 = X_1$，显然满足 $p(t) = \lambda \mathrm{e}^{-\lambda t}$。
- 当 $n=2$ 时，$T_2 = X_1 + X_2$，通过卷积计算：

$$
\begin{align}
p_{T_2}(t) &= \int_0^t p_{X_1}(x) \cdot p_{X_2}(t-x) \ \mathrm{d}x \\
&= \int_0^t \lambda \mathrm{e}^{-\lambda x} \cdot \lambda \mathrm{e}^{-\lambda(t-x)} \ \mathrm{d}x \\
&= \lambda^2 t \mathrm{e}^{-\lambda t} \quad (t \ge 0)
\end{align}
$$

这正对应参数为 $\alpha=2$、$\beta=\lambda$ 的 Gamma 分布密度函数。

- **归纳至一般情况**：假设 $T_n$ 的密度函数为 $p_{T_n}(t) = \frac{\lambda^n t^{n-1} \mathrm{e}^{-\lambda t}}{(n-1)!}$，则 $T_{n+1}$ 通过卷积可得：

$$
\begin{align}
p_{T_{n+1}}(t) &= \int_0^t p_{T_n}(x) \cdot p_{X_{n+1}}(t-x) \ \mathrm{d}x \\
&= \frac{\lambda^n}{(n-1)!} \int_0^t x^{n-1} \mathrm{e}^{-\lambda x} \cdot \lambda \mathrm{e}^{-\lambda(t-x)} \ \mathrm{d}x \\
&= \frac{\lambda^{n+1}}{(n-1)!} \mathrm{e}^{-\lambda t} \int_0^t x^{n-1} \ \mathrm{d}x \\
&= \frac{\lambda^{n+1} t^n \mathrm{e}^{-\lambda t}}{n!}
\end{align}
$$

完成归纳递推，**$T_n$ 确实服从参数为 $\alpha=n$、$\beta=\lambda$ 的 Gamma 分布**。

### 矩函数验证

可以使用[矩函数](https://en.wikipedia.org/wiki/Moment-generating_function)的方法绕过卷积的计算。

{% spoiler What is 矩函数 %}

随机变量 $X$ 的矩函数（MGF）$G_X(t)$，有两种看待视角。一种是 $M_X(t) =\mathbb{E}[\mathrm e^{Xt}]$，另一种是把 $M_X(t)$ 看成概率密度函数 $f(x)$ 的双边拉普拉斯变换。

矩函数的形式和性质都很有趣，我们这里不关注在统计量中的应用。只是关注双边拉普拉斯变换的性质。

对于任何函数 $f(x)$ 做双边拉普拉斯变换的公式如下：

$$
M_X(t) = \mathcal L_f(t) = \int_{-\infty}^{+\infty} \mathrm e^{xt}f(x) \mathrm dx
$$

这种类傅里叶变换能够把原函数的卷积转化为变换结果的乘法，即：

$$
\mathcal L_{f \ast g}(t) = \mathcal L_f(t)\cdot \mathcal L_g(t)
$$

其中：

$$
(f \ast g)(x_0) = \int_{-\infty}^{+\infty} f(x)g(x_0 - x) \mathrm dx
$$

也即 $f,g$ 的卷积。不难发现，如果 $f,g$ 是 $X,Y$ 的概率密度函数，则 $f \ast g$ 是 $X+Y$ 的概率密度函数。

双边拉普拉斯变换满足这样的性质：如果 $\mathcal L_f = \mathcal L_g$，则函数 $f$ 与 $g$ **几乎处处相等**。

{% endspoiler %}

对于性质比较好的随机变量，我们可以认为，如果两个随机变量有相同的矩函数，它们也具有相同的分布。

$X_i$ 遵循指数分布，其矩函数为：

$$
M_X(t) = \int_0^\infty \mathrm{e}^{tx} \cdot \lambda \mathrm{e}^{-\lambda x} \mathrm{d}x = \frac{\lambda}{\lambda - t}
$$

$X_1, X_2, \dots, X_n$ 是**独立同分布**的随机变量（此处均为 $\text{Exp}(\lambda)$），那么它们的和：

$$
S_n = X_1 + X_2 + \cdots + X_n
$$

的矩函数为各变量矩函数的**乘积**：

$$
M_{S_n}(t) = \prod_{i=1}^n M_{X_i}(t) = \left( \frac{\lambda}{\lambda - t} \right)^n
$$

另一方面，我们考察 Gamma 分布的矩函数：

$$
\begin{aligned}
M_\Gamma(t) &= \int_0^\infty \mathrm{e}^{tx} \cdot \frac{\beta^\alpha x^{\alpha-1} \mathrm{e}^{-\beta x}}{\Gamma(\alpha)} \mathrm{d}x\\
&= \frac{\beta^\alpha}{\Gamma(\alpha)} \int_0^\infty x^{\alpha-1} \mathrm{e}^{-(\beta - t)x} \mathrm{d}x\\
&= \frac{\beta^\alpha}{\Gamma(\alpha)} \cdot \frac{\Gamma(\alpha)}{(\beta - t)^\alpha} \\
&= \left( \frac{\beta}{\beta - t} \right)^\alpha
\end{aligned}
$$

其中第三个等号的关键点是 $\Gamma$ 函数的定义：

$$
\int_0^\infty x^{\alpha-1} \mathrm{e}^{-k x} \, \mathrm{d}x = \frac{\Gamma(\alpha)}{k^\alpha}.
$$

两边一对比，立刻发现，若令 $\beta = \lambda, \alpha = n$，则有：

$$
S_n \sim \Gamma(n, \lambda)
$$

### 总结

无论怎么推导，我们都得到了如下结果：

当 $\alpha$ 为整数时，**参数为 $\lambda$ 的连续泊松过程的第 $\alpha$ 次到达时间遵循分布 $\Gamma(\alpha, \lambda)$**。

当然，要注意到，Gamma 分布对 $\alpha$ 的定义域做了延拓，正如 $\Gamma(n)$ 是 $(n-1)!$ 的合理延拓。

