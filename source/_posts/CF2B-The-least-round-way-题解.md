---
title: CF2B-The-least-round-way-题解
date: 2023-07-08 13:02:01
updateDate: 2023-07-08 13:02:01
tags:
categories:
- 信奥
- 题解
comments: true
top: 2
---
原题链接：[Link](https://xoj.red/problem/5216)

## 题目描述

从左上走到右下，让经过数字乘积末尾的 0 个数最少。

<!--more-->

## 思路分析

区间末尾的 0 是由质因数 2 和 5 产生的，容易想到把每个数有多少个 2 和 5 分别存下来。

接下来问题就产生了，我应该选择 2 比较少还是选择 5 比较少呢？

因为最后 10 的个数取决于这两个个数的最小值，所以其实没有必要兼顾，只要极力最小化某一个值就行。

具体的说，我们根据 5 的个数跑一次类似数字三角形， DP 求出最少的 5。（定义 $f_{i,j}$ 表示走到 $(i,j)$ 的最少 5 个数，则 $f_{i,j} = \min(f_{i - 1,j}, f_{i, j - 1}) + a_{i,j}$）

然后再跑一边 DP ，只不过这次是求 2。

最后比一下 5 和 2 谁少就行。（DP 转移的时候记录一下路径）

这样你就华丽丽地 $\text{T}$ 了。

为啥捏？因为有 0。

在统计因数个数的时候，0 会直接死循环。而且，一旦乘了 0，末尾 0 个数一定是 1 个。

所以我们对 0 特判，先不走 0（把 0 的位置设为无穷大），如果答案比 1 小，那就走答案，否则走 0。注意 0 对应的路径也要特殊处理。

## AC代码

{% spoiler code %}
```cpp
#include <bits/stdc++.h>
using namespace std;

// #define FILE_IO
namespace io {...};
using namespace io;

const int maxn = 1e3 + 5;

int n;
int zi, zj;
int a[maxn][maxn], b[maxn][maxn];
char fa[maxn][maxn], fb[maxn][maxn];

int main() {
    read(n);
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            int x; read(x);
            if (x == 0) {
                a[i][j] == b[i][j] == 0x3f3f3f3f;
                zi = i, zj = j;
                continue;
            }
            while (x % 5 == 0) x /= 5, a[i][j]++;
            while ((x & 1) == 0) x >>= 1, b[i][j]++;
        }
    }
    for (int i = 2; i <= n; i++) a[i][0] = a[0][i] = b[i][0] = b[0][i] = 0x3f3f3f3f;
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            if (a[i - 1][j] < a[i][j - 1]) {
                fa[i][j] = 'D';
                a[i][j] += a[i - 1][j];
            } else {
                fa[i][j] = 'R';
                a[i][j] += a[i][j - 1];
            }
            if (b[i - 1][j] < b[i][j - 1]) {
                fb[i][j] = 'D';
                b[i][j] += b[i - 1][j];
            } else {
                fb[i][j] = 'R';
                b[i][j] += b[i][j - 1];
            }
            // write(a[i][j], " \n"[j == n]);
        }
    } 
    if (b[n][n] < a[n][n]) {
        stack<char> s;
        int i = n, j = n;
        while (i != 1 || j != 1) {
            s.emplace(fb[i][j]);
            if (fb[i][j] == 'R') j--;
            else i--;
        }
        if (zi && b[n][n] > 1) {
            write(1);
            for (int i = 2; i <= zi; i++) putchar('D');
            for (int i = 2; i <= zj; i++) putchar('R');
            for (int i = zi + 1; i <= n; i++) putchar('D');
            for (int i = zj + 1; i <= n; i++) putchar('R');
        } 
        else {
            write(b[n][n]);
            while (!s.empty()) {
                putchar(s.top());
                s.pop();
            }
        }
    } else {
        stack<char> s;
        int i = n, j = n;
        while (i != 1 || j != 1) {
            s.emplace(fa[i][j]);
            if (fa[i][j] == 'R') j--;
            else i--;
        }
        if (zi && a[n][n] > 1) {
            write(1);
            for (int i = 2; i <= zi; i++) putchar('D');
            for (int i = 2; i <= zj; i++) putchar('R');
            for (int i = zi + 1; i <= n; i++) putchar('D');
            for (int i = zj + 1; i <= n; i++) putchar('R');
        } 
        else {
            write(a[n][n]);
            while (!s.empty()) {
                putchar(s.top());
                s.pop();
            }
        }
    }
    return 0;
}
```
{% endspoiler %}
