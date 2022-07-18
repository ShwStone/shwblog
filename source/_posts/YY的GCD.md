---
title: YY的GCD
date: 2022-07-13 16:22:55
tags:
categories:
- 信奥
- 题解
---
## 根本写不出莫反
题目传送门：[Link](https://www.luogu.com.cn/problem/P2257)

<!-- more -->

由于本蒟蒻实在是看不懂如下过程：

$$\sum_{k \in prime}{ \sum_{d=1}^{\lfloor \frac{n}{k} \rfloor}{\mu (d) * \lfloor \frac{n}{T} \rfloor * \lfloor \frac{m}{T} \rfloor}}$$  
$$= \sum_{T=1}^{n}{\lfloor \frac{n}{T} \rfloor * \lfloor \frac{m}{T} \rfloor \sum_{k|T,k \in prime}{\mu(\frac{T}{k})}}$$  

~~上来LeTax就直接爆炸~~

更看不出来后面那一坨东西是怎么预处理的，所以我决定~~跟着题解~~自己推一推柿子。（感谢大佬 [@凄魉的题解](https://www.luogu.com.cn/blog/qlwpc/solutin-p2257) ，这里再修缮一下数学上的纰漏，易于理解。）

莫比乌斯变换最重要的柿子就是这个：  

$$\sum_{d|n}{\mu(d)}=[n=1]$$  

这样子就可以把这个难求的东西  

$$[gcd(i,j)=1]$$  

替换成这个好东西  

$$\sum_{d|gcd(i,j)}{\mu(d)}$$    

但是现在题目要求这个：  

$$[gcd(i,j) \in prime]$$  

所以要是有一个函数 $f(n)$ 满足如下柿子：  

$$\sum_{d|n}{f(d)=[n \in prime]}$$  

就可以愉快地代入了。  

怎么推呢？  

设 $f'(n)=[n \in prime]$ ,则有：

$$\sum_{d|n}{f(d)=f'(n)}$$  
$$f(n) + \sum_{d|n,d \neq n}{f(d)}=f'(n)$$  

所以得到 $f(n)$ 的递推式：  

$$f(n)=f'(n)-\sum_{d|n,d \neq n}{f(d)}$$  

而 $f'(n)$ 可以用筛法求出来的（其实就是筛质数），所以再用 $O(n \ln n)$ 的时间推出 $f(n)$ 如下：  

```cpp
\\ is_prime[i]就是f'(i)
for (int i = 1; i <= n; i++) {
    f[i] = is_prime[i] - f[i];
    for (int j = i + i; j <= n; j += i) {
        f[j] += f[i];
    }
}
```

我们发现在之后也用不到 $f'(n)$ 了，所以不如把 $f'(n)$ 筛到 `f[]` 数组里，然后自己跟自己加加减减，这样可以少开一个数组。  

```cpp
\\ 现在的f[i]是之前的is_prime[i]
for (int i = 1; i <= n; i++) {
    for (int j = i + i; j <= n; j += i) {
        f[j] -= f[i];
    }
}
```

快乐的求完了。  

然后来看一看原题怎么求：

$$Ans=\sum_{i=1}^n{\sum_{j=1}^m{[gcd(i,j) \in prime]}}$$
$$Ans=\sum_{i=1}^n{\sum_{j=1}^m{\sum_{d|gcd(i,j)}{f(d)}}}$$
$$Ans=\sum_{i=1}^n{\sum_{j=1}^m{\sum_{d|i,d|j}{f(d)}}}$$
$$Ans=\sum_{d=1}{\sum_{i=1}^n{[d|i]\sum_{j=1}^m{[d|j]f(d)}}}$$
$$Ans=\sum_{d=1}{\sum_{i=1}^{\lfloor \frac{n}{d} \rfloor}{\sum_{j=1}^{\lfloor \frac{m}{d} \rfloor}{f(d)}}}$$
$$Ans=\sum_{d=1}{\lfloor \frac{n}{d} \rfloor \lfloor \frac{m}{d} \rfloor f(d)}$$

简直不要太简洁。

再看一看 $d$ 的上限：

$$Ans=\sum_{d=1}^{min(n,m)}{\lfloor \frac{n}{d} \rfloor \lfloor \frac{m}{d} \rfloor f(d)}$$

最后贴上代码：

```cpp
\\ 咕咕咕
```





















