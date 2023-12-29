---
title: 警位安排-树形DP题解
date: 2023-08-16 16:23:27
tags:
categories:
- 信奥
- 题解
comments: true
sticky: 2
---
原题链接：[Link](https://xoj.red/problem/5232)

<!-- more -->
## 题目描述

树形 DP 的典型例题，是**状态与父亲有关**的 DP。

## 思路分析

这类 DP 最重要的是状态设计，可以有两种思路：

1. 设计时只考虑自己和子树，此时自己这个点可以不满足，让父亲来满足，但是子树要全部满足。
2. 设计时同时考虑自己和父亲，相当于预判父亲的状态，此时父亲的转移要根据儿子的预判来。

网络上一般都是第二种思路，写的比较好的是[这篇](https://blog.csdn.net/dreaming__ldx/article/details/82470046)，就不再重复了。

第一种思路如下：定义 $f_{i,a,b}(a,b\in \{0,1\})$ 表示第 $i$ 个点是否放了警卫（$a$），是否被监视（$b$）。那么有：

$$
\begin{aligned}
    f_{u,0,0}&=\sum_{v \in \operatorname{son}(u)}{f_{v,0,1}}\\
    f_{u,0,1}&=\sum_{v \in \operatorname{son}(u)}{\min(f_{v,1,1},f_{v,0,1})}\text{(至少有一个}f_{v,1,1}\text{)}\\
    f_{u,1,1}&=\sum_{v \in \operatorname{son}(u)}{\min(f_{v,1,1},f_{v,0,1},f_{v,0,0})}
\end{aligned}
$$

按照这样写会 WA，是因为边界有小问题：对于叶子节点 $u$，它没有儿子，所以 $f_{u,0,1}$ 是不可能出现的，应该赋值成无穷大。注意无穷大的取值不能累加后爆 `int`。

## AC代码

{% spoiler code %}

```cpp
#include <bits/stdc++.h>
using namespace std;
// #define FILE_IO
namespace io {...};
using namespace io;
const int maxn = 720 + 5;

int n, xors;
long long r[maxn], dp[maxn][2][2];
vector<int> son[maxn];

void dfs(int u) {
	dp[u][1][1] = r[u];
    if (son[u].empty()) dp[u][0][1] = 0x3f3f3f3f;
	for (int v : son[u]) {
		dfs(v);
		dp[u][0][1] += min(dp[v][0][1], dp[v][1][1]);
        dp[u][0][0] += dp[v][0][1];
		dp[u][1][1] += min(dp[v][1][1], min(dp[v][0][0], dp[v][0][1]));
	}
    long long tmp = 0x3f3f3f3f;
    for (int v : son[u]) {
        tmp = min(tmp, dp[u][0][1] - min(dp[v][0][1], dp[v][1][1]) + dp[v][1][1]);
    }
    dp[u][0][1] = tmp;
}

int main() {
	read(n);
	for (int i = 1; i <= n; i++) {
		int id; read(id); read(r[id]);
        int m; read(m);
        for (int j = 1; j <= m; j++) {
            int v; read(v); son[id].emplace_back(v);
            xors ^= v;
        }
		xors ^= i;
	}
	dfs(xors);
	write(min(dp[xors][0][1], dp[xors][1][1]));
	return 0;
}

```

{% endspoiler %}
