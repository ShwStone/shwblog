---
title: GCD-题解
date: 2023-07-08 13:02:01
tags:
categories:
- 信奥
- 题解
comments: true
sticky: 2
---
原题链接：[Link](https://xoj.red/problem/5216)

## 题目描述

求区间 GCD 等于特定值的区间个数。

<!--more-->

## 思路分析

首先我们解决区间 GCD 的问题。

定义 $gcdRange(l, r)$ 表示区间 $[l, r]$ 所有数的 GCD 。容易发现这个函数是有结合律的，而且哪怕两个区间有部分重叠仍适合结合律，所以可以使用 ST 表维护，只要把原来的 `max` 换成 `gcd` 就行了。

然后考虑计数。区间 GCD 有两个特点：

1. 能取到的值并不多。一个数的因数本来就少，多个数的公因数就更少了。
2. 区间变宽， GCD 只减不增。

这样，如果我们固定区间的左端点，让右端点不断增加，此时 $gcdRange(l, r)$ 会递减，又由于能取的值不多，将会出现大量的重复 GCD 值。运用二分方法求出这些连续 GCD 值的区间，就在较短的时间里完成了统计。

如果设值域为 $W$，可以预料到 GCD 值的取值数量在 $\log W$ 级别，总复杂度是 $n \log W \log n$。

## AC代码

{% spoiler code %}
```cpp
#include <bits/stdc++.h>
using namespace std;

// #define FILE_IO
namespace io {...}
using namespace io;

const int maxn = 1e5 + 5;

int n, t, q;
int a[maxn][18], log_2[maxn];
map<int, long long> ans;

int gcd(int a, int b) {
    while (a ^= b ^= a ^= b %= a);
    return b;
}

int ask(int l, int r) {
    int k = log_2[r - l + 1];
    return gcd(a[l][k], a[r - (1 << k) + 1][k]);
}

int bs(int i, int x) {
    int l = i, r = n, mid;
    while (l < r) {
        mid = (l + r + 1) >> 1;
        if (ask(i, mid) < x) r = mid - 1;
        else l = mid;
    }
    return l;
}

const string tttttmp = "Case #";

int main() {
    read(t);
    for (int tid = 1; tid <= t; tid++) {
        ans.clear();
        read(n);
        for (int i = 1; i <= n; i++) {
            read(a[i][0]);
            if (i != 1) log_2[i] = log_2[i >> 1] + 1;
        }
        for (int j = 1; j < 18; j++) {
            for (int i = 1; i + (1 << j) - 1 <= n; i++) {
                a[i][j] = gcd(a[i][j - 1], a[i + (1 << (j - 1))][j - 1]);
            }
        }
        for (int i = 1; i <= n; i++) {
            int j = bs(i, a[i][0]);
            ans[a[i][0]] += j - i + 1;
            while (j < n) {
                int g = ask(i, j + 1);
                int nj = bs(i, g);
                ans[g] += nj - j;
                j = nj;
            }
        }
        for (char x : tttttmp) putchar(x);
        write(tid, ':');
        putchar('\n');
        read(q);
        while (q--) {
            static int l, r, g;
            read(l); read(r);
            g = ask(l, r);
            write(g, ' ');
            write(ans[g]);
        }
    }
    return 0;
}
```
{% endspoiler %}
