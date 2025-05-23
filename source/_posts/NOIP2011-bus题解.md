---
title: NOIP2011-bus-题解
date: 2022-07-13 16:23:27
tags:
categories:
- 信奥
- 题解
comments: true
sticky: 2
---
原题链接：[Link](https://www.luogu.com.cn/problem/P1315)

<!-- more -->
## 题目描述

$n$ 个站点， $n - 1$ 段路。$m$ 个人在时刻 $t_i$ 到达 $a_i$ 点，要去 $b_i$ 点。只有一辆车，所以车会等所有人。现在有 $k$ 次魔法能让任意一段路变短一点，求乘客等车+坐车的总时间的最小值。 

## 思路分析

考场上写挂的最大原因：

如果车不用等人，将前面的一段路变短，**对后面的人也会有贡献**（等车时间变短）。贡献区间可以无限延长，直到在某一站变成人等车。

所以要先求出每一段路可以贡献几站，从后往前 DP 即可。

正确求出贡献之后就简单了，每次选取贡献最大的一段路变短。

## AC代码

{% spoiler code %}

```cpp
#include <bits/stdc++.h>
using namespace std;

// #define FILE_IO
namespace io {...};
using namespace io;

const int maxn = 1e3 + 5, maxm = 1e4 + 5;

int n, m, k;
int d[maxn], t[maxn], s[maxn], arr[maxn], ss[maxn];
int tt[maxm], bb[maxm], aa[maxm];
vector<int> turn;

bool compare(int a, int b) {
    return s[a] > s[b];
}

long long ans;

int main() {
    // freopen("bus.in", "r", stdin);
    // freopen("bus.out", "w", stdout);
    read(n); read(m); read(k);
    for (int i = 1; i < n; i++) {
        read(d[i]);
    }
    for (int i = 1; i <= m; i++) {
        read(tt[i]); read(aa[i]); read(bb[i]);
        t[aa[i]] = max(t[aa[i]], tt[i]);
        s[bb[i]]++;
    }
    for (int i = 1; i <= n; i++) {
        arr[i] = max(t[i - 1], arr[i - 1]) + d[i - 1];//此时表示到达时间
    }
    for (int i = 1; i <= m; i++) {
        ans += arr[bb[i]] - tt[i];
    }
    for (int i = 1; i <= n; i++) s[i] += s[i - 1];
    while (k--) {
        ss[n] = ss[n - 1] = n;
        for (int i = n - 2; i >= 1; i--) {
            if (arr[i + 1] <= t[i + 1]) ss[i] = i + 1;
            else ss[i] = ss[i + 1];
        }
        int ma = -1, mad = -1;
        for (int i = 1; i < n; i++) {
            if (d[i] && arr[i + 1] > t[i + 1] && s[ss[i]] - s[i] > ma) {
                mad = i;
                ma = s[ss[i]] - s[i];
            }
        }
        if (mad == -1) break;
        d[mad]--;
        ans -= ma;
        for (int i = 1; i <= n; i++) {
            arr[i] = max(t[i - 1], arr[i - 1]) + d[i - 1];//此时表示到达时间
        }
    }
    write(ans);
    return 0;
}
```

{% endspoiler %}
