---
abbrlink: ''
categories:
- - 数学
date: '2024-09-16T15:16:14.987120+08:00'
sticky: 11
tags:
- XCPC
- 数学
title: 行列式的妙用-ICPC2024Online1-C
updated: '2024-09-16T15:16:18.654+08:00'
---
## 题目大意

[$\mathcal {Link}$](https://qoj.ac/contest/1794/problem/9310)

给定 $n$ 个区间 $[l_i, r_i]$，求有多少个 $ 1 \sim n$ 的排列 $ p$ 满足 $p_i \in [l_i, r_i]$。输出答案$\mod 2$ 的结果。

<!--more-->

## 思路分析

还是很妙的。我们根据限制条件构造矩阵 $A$，使得：$A_{ij} = [j \in [l_i, r_i]]$。要求的答案如下：

$$
\sum_{p}\prod_{i=1}^{n} A_{ip_i}
$$

其中 $p$ 为所有排列。其实就是枚举排列判断是否合法。

这个定义是不是看着很像行列式？行列式完全展开如下：

$$
\det(A) = \sum_p\operatorname{sgn}(p)\prod_{i=1}^n A_{ip_i}
$$

只是去掉了正负号而已。事实上，要求的式子被称为**积和式（permanent）**，记作 $\operatorname{perm}(A)$。由于只是去掉了正负号，不难发现：

$$
\operatorname{perm}(A) \equiv \det(A) \pmod 2
$$

进一步地，模二意义下行列式是否为 0，实际上是判断矩阵在模二意义下是否可逆，即检查是否有向量能被其他向量在模二意义下线性表出。

此时，区间的条件发挥了性质。我们可以建出一张 $n + 1$ 个点的图，对于区间 $[l_i, r_i]$，将 $l_i$ 与 $r_{i+1}$ 连边。如果在图上 $u,v(u<v)$ 之间可达，说明通过向量模二意义下的线性运算，可以产生一个 $[u,v-1]$ 的区间。

这样，我们用一个并查集维护可达性，每次加边之前判断：如果 $l_i, r_{i+1}$ 已经可达，说明区间  $[l_i,r_i]$ 已经可以被线性表出，那么答案是 0。如果所有区间都不可被表出，那么答案是 1。

```cpp
#include <bits/stdc++.h>
using namespace std;

const int MAXN(1e6 + 5);

int n;
int f[MAXN];

int find(int x) { return x == f[x] ? x : f[x] = find(f[x]); }

void solve() {
    scanf("%d", &n);
    for (int i = 1; i <= n + 1; i++) {
        f[i] = i;
    }
    int ans = 1;
    for (int i = 1; i <= n; i++) {
        int l, r; scanf("%d %d", &l, &r);
        l = find(l); r = find(r + 1);
        if (l != r) f[r] = l;
        else ans = 0;
    }
    printf("%d\n", ans);
}

int main() {
    int _;
    scanf("%d", &_);
    while (_--) {
        solve();
    }
    return 0;
}
```
