---
abbrlink: ''
categories: []
comments: true
date: '2025-03-07T15:48:01.048475+08:00'
sticky: 11
tags: []
title: 梯度、泰勒与Hesse
updated: '2025-03-07T17:52:10.823+08:00'
---
$$
f(\mathrm{x}) = \sum_{p=0}^{+\infty}\frac{(\mathrm{x} \cdot \nabla)^p}{p!} f(\mathrm{0})
$$

<!--more-->

## 梯度

对于二元函数 $z=f(x,y)$，既可以从二维等值线的方式把 $x,y$ 和 $z$ 单独对待，也可以将 $(x,y,z)$ 看作三维空间中的一个曲面。从后者的角度出发，对于三维曲面上的一个点，有两个东西是特殊的：过这个点的切面，和垂直与切面的直线。

多元函数可微，实际上就是说，在足够小的邻域内，函数可以被偏导数线性表示；换言之，三维曲面上的一个点的邻域可以被（按极限定义）近似为一个平面。这个平面可以被表示如下：

$$
z - z_{0} = \frac{\partial z}{\partial x} (x-x_{0}) + \frac{\partial z}{\partial y}(y - y_{0})
$$

整理之后不难得到，这个切平面对应的法向量是 $(\frac{\partial z}{\partial x},\frac{\partial z}{\partial y},-1)$。

将这个法向量重新投影到二维等值线上，我们就会得到如下结果：

投影向量为 $(\frac{\partial z}{\partial x}, \frac{\partial z}{\partial y})$，即梯度 $\nabla z$。而从法向量的性质和 -1 分量可以看出：

- $\nabla z$ 垂直于等值线的切线。
- 沿着 $\nabla z$ 方向，$z$ 值变大。（这稍有困惑，因为法向量总是朝着 $z$ 值变小，所以同方向上的平面反而变大）

结合上面两点，我们能够直观地理解：梯度方向是 $z$ 值上升最快的方向。

## 泰勒

我们沿用线性代数的视角继续看函数。

一元泰勒展开，从线代角度，就是把 $f(x)$ 分解成一组无限基 $\{1,x,x^2,x^3,\dots\}$ 的线性组合。具体来说，$f(x)$ 在这组基上的分量可以由求导确定：如果 $f(x) = cx^k + g(x)$ 且 $g(x)$ 不包含 $x^k$  项，则有：

$$
\left.\frac{\mathrm{d}^kf(x)}{\mathrm{d}x^k}\right|_{x=0} = k!c
$$

换而言之，算子 $\frac{\mathrm{d}^k}{k!\mathrm{d}x^k}$ 可以求出 $f(x)$ 在基 $x^k$ 上的分量。注意应该在原点求这个导数。

上面的分析可以方便地转移到多元函数：我们尝试把 $n$ 元函数分解到如下形式的一组基上：

$$
B_{k_{1},k_{2},\dots,k_{n}}(\mathrm{x})=\prod_{i=1}^n x_{i}^{k_{i}}
$$

和之前相似，如果 $f(\mathbf{x})$ 在 $B_{k_{i}}(\mathrm{x})$ 上的分量是 $c$，则有：

$$
\left.\prod_{i=1}^n\frac{\partial^{k_i}}{\partial x_{i}^{k_{i}}}f(\mathbf{x})\right|_{\mathbf{x}=0} = c\prod_{i=1}^n k_{i}!
$$

要说明一下：对于微分算子 $\frac{\partial}{\partial x}$，乘法被视作复合，也即求高阶偏导数。所以，上式的左边意思是，对第一分量求 $k_{1}$ 次偏导，第二分量求 $k_{2}$ 次偏导，以此类推。

则算子

$$
\prod_{i=1}^n\frac{1}{k_{i}}\cdot\frac{\partial^{k_{i}}}{\partial x_{i}^{k_{i}}}
$$

应用在 $\mathrm{x}=0$ 上就可以得到 $f(\mathbf{x})$ 在 $B_{k_{i}}$ 上的分量。

我们记 $p = \sum_i k_{i}$。类似二项式定理，我们也有多项式定理：

$$
\left( \sum_{i=1}^n x_{i} \right)^p = p!\sum_{\sum_{i} k_{i}=p} \prod_{i=1}^n \frac{x_{i}^{k_{i}}}{k_{i}!}
$$

用这个定理，我们可以把 $p$ 相同（即阶数相同）的分量统一计算：

$$
\begin{aligned}
f_{p}(\mathrm{x}) &= \sum_{\sum_{i} k_{i}=p} B_{k_{i}}\prod_{i=1}^n\frac{1}{ k_{i}!}\cdot\frac{\partial^{k_{i}} f(0)}{\partial x_{i}^{k_{i}}}\\
&= \sum_{\sum_{i} k_{i}=p} \prod_{i=1}^n \frac{x_{i}^{k_{i}}}{k_{i}!}\cdot\frac{\partial^{k_{i}}}{\partial x_{i}^{k_{i}}}f(\mathrm{0}) \\
&= \sum_{\sum_{i} k_{i}=p} \prod_{i=1}^n \frac{\left(x_{i}\cdot\frac{\partial}{\partial x_{i}}\right)^{k_{i}}}{k_{i}!}f(\mathrm{0}) \\
&= \frac{1}{p!}\left( \sum_{i=1}^n x_{i} \cdot\frac{\partial}{\partial x_{i}} \right)^p f(\mathrm{0}) \\
&= \frac{(\mathrm{x} \cdot \nabla)^p}{p!} f(\mathrm{0})
\end{aligned}
$$

第四个等号用到了多项式定理。

其中 $\mathrm{x}\cdot\nabla$ 表示 $\mathrm{x}$ 向量和梯度算符的形式内积（并不是真的内积，只是符合形式）。注意这个内积不是对 $\mathrm{x}$ 求梯度，这个内积的结果仍然是一个微分算符。

注意微分算子的乘和加与实数类似，也满足多项式定理。

最后得到 $f(\mathrm{x})$ 的完全分解：

$$
\begin{aligned}
f(\mathrm{x}) &= \sum_{p=0}^{+\infty} f_{p}(\mathrm{x})\\
&= \sum_{p=0}^{+\infty} \frac{(\mathrm{x} \cdot \nabla )^p}{p!}f(\mathrm{0})
\end{aligned}
$$

最后要注意我们其实是在 0 处进行泰勒展开，任意处的展开只需做个平移。

结束了！我们把这个式子和书上给的二阶泰勒公式做一个比较，看看这个 $(\mathrm{x} \cdot \nabla)^p$ 是个什么玩意。

## Hesse

下面以二元为例，假设 $\mathrm{x}=(x,y)$。

一阶项 $(\mathrm{x}\cdot \nabla)^1f(0)$ 就是 $xf_{x}(0) + yf_{y}(0)$，也就是 $\mathrm{x}\cdot \nabla f(0)$。

而二阶项 $(\mathrm{x}\cdot \nabla)^2f(0)$ 是下面这个东西：

$$
\begin{aligned}
(\mathrm{x}\cdot \nabla)^2f(0) &= \left( x \frac{\partial}{\partial x} + y \frac{\partial}{\partial y} \right)^2f(0) \\
&= x^2f_{xx}(0) + 2xyf_{xy}(0) + y^2f_{yy}(0)
\end{aligned}
$$

这可以看作关于 $\mathrm{x}$ 的一个二次型，所以可以重新整理如下：

$$
(\mathrm{x}\cdot \nabla)^2f(0) = \mathrm{x}^{\dagger}\mathrm{H}_{f}\mathrm{x}
$$

其中：

$$
\mathrm{H}_{f} = \begin{bmatrix}
f_{xx}(0) & f_{xy}(0)\\ \\
f_{xy}(0) & f_{yy}(0)
\end{bmatrix}
$$

从这就可以看出，用 $\nabla f$ 和 $\mathrm{H}_f$ 表示的泰勒公式只是一般公式中，把梯度符号向后结合，把 $\mathrm{x}$ 分离开的特殊情况罢了。
