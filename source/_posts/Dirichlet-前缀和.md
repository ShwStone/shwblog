---
title: Dirichlet 前缀和
comments: true
top: 2
date: 2022-08-08 15:35:50
updateDate: 2022-08-08 15:35:50
tags:
- 算法
- 题解
- 数学
categories:
- 信奥
- 题解
---

原题链接：[Link](https://www.luogu.com.cn/problem/P5495)

## 问题简介

已知序列 $a_{1...n}$ ，求出序列 $b_{1...n}$ ，其中：

$$
b_i=\sum_{j|i}{a_j}
$$

<!--more-->

## 解决方法

一种显然的写法就是寻找每个 $i$ 的倍数，让 $b_i\text{ += }a_i,b_{ 2i }\text{ += }a_i,b_{3i}\text{ += }a_i...$ 来算贡献。这样的时间复杂度是 $N \ln N$ 的。不够优秀。

我们来考虑这样的一个数： $x=a\cdot p^k$ 。他会受到哪些数的贡献呢？显然，是 $a \cdot p^0,a \cdot p^1,a \cdot p^2...a \cdot p^k-1,a \cdot p^k$ 。那么我们可以这样：让 $a \cdot p^0$ 先给 $a \cdot p^1$ 做贡献，再让 $a \cdot p^1$ 带着自己和 $a \cdot p^0$ 的贡献一起给 $a \cdot p^2$ 做贡献，然后 $a \cdot p^2$ 再带着 $a \cdot p^0$ 与  $a \cdot p^1$ 的贡献一起给 $a \cdot p^3$ 做贡献……依次类推，以 $p$ 为步长的贡献就算完了。在 $O(N)$ 的时间就可以把所有的 $a$ 的贡献算出来，如下：

```cpp
for (int i = 1; i <= n; i++) {
	a[p * i] += a[i];
}
```

结合上面的分析，好好体会一下这三行代码的含义。

但是这只做了 $p$ 的贡献。我们需要让每个质数都做一次贡献，这样才能不重不漏（因为质因数分解是唯一的）。提前筛出质数，枚举 $p$ 即可。

```cpp
for(int i = 1; i <= tot; i++)
	for(int j = 1; pri[i] * j <= n; j++)
		a[pri[i] * j] += a[j];
```

这个时间复杂度和埃氏筛是一样的， $O(N \log \log N)$ 。

## AC代码

{% spoiler code%}
```cpp
#include <bits/stdc++.h>
using namespace std;

#define uint unsigned int
uint seed;
inline uint getnext(){
	seed^=seed<<13;
	seed^=seed>>17;
	seed^=seed<<5;
	return seed;
}

const uint maxn = 2e7 + 5;

uint n, ans;
uint a[maxn];
bool np[maxn];
uint pr[maxn], pcnt;

int main() {
	scanf("%u %u", &n, &seed);
	for (uint i = 1; i <= n; i++) {
		a[i] = getnext();
	}
	for (uint i = 2; i <= n; i++) {
		if (!np[i]) pr[++pcnt] = i;
		for (uint j = 1; j <= pcnt && i * pr[j] <= n; j++) {
			np[i * pr[j]] = true;
			if (i % pr[j] == 0) break;
		}
	}
	for (uint i = 1; i <= pcnt; i++) {
		for (uint j = 1; pr[i] * j <= n; j++) {
			a[pr[i] * j] += a[j];
		}
	}
	for (uint i = 1; i <= n; i++) {
		ans ^= a[i];
	}
	printf("%u\n", ans);
	return 0;
}
```

{% endspoiler %}
