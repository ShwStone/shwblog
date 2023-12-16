---
abbrlink: ''
categories:
- 信奥
comments: false
date: '2023-08-16T16:21:39+08:00'
sticky: 0
tags: []
title: note
updated: '2023-12-10T15:49:40.954+08:00'
---
## 碎碎念

- 感觉和图论有关的时候先考虑匈牙利再考虑网络流
- 区间 DP 不要死脑筋，答案可以不在 `dp[1][n]` 里，比如 [P3146](https://www.luogu.com.cn/problem/P3146)。
- 区间 DP 注意有负数的时候分类讨论取最大最小。[P4342](https://www.luogu.com.cn/problem/P4342)。
- 当看到跟点有关的连通性问题时可以考虑拆点建图，一个点负责入边，另一个点负责出边。[P1345](https://www.luogu.com.cn/problem/P1345)
- ISAP 注意两个优化：
  1. 当有一个 gap 为 0（也就是某个深度没有点）时，直接结束算法（将 dep[s] 设为 n）
  2. 当前弧优化
- ISAP 考虑清楚 dep 如何初始化以及更改。
- ISAP 注意边界条件 `u == t`
- `ex_gcd` 其实没有必要写返回值。
- 内存太多怎么办？使用 `mysql`。
