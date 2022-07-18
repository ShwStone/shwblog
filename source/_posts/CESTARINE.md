---
title: CESTARINE
date: 2022-07-13 16:23:33
tags:
categories:
- 信奥
- 题解
---
## Luka ~~（开车）~~ 开卡车

### 题面描述

Luka 有 $n$ 辆卡车行驶在一条高速路上。高速路上有许多出入口。我们认为相同编号的出入口在同一位置。开进高速路后，司机会收到一张写着他入口号的单子。驶出时，驾驶员支付的通行费等于出入口号的差的绝对值。例如，如果单子上的入口 $30$ ，然后在出口 $12$ 退出，那么会花费 $|30 - 12| = 18$ 元。

<!-- more -->

Luka 是一个爱贪小便宜的人。他发现即使卡车的路线并不重叠，司机们仍然可以在高速路上交换他们的单子。但是，同一辆卡车不能在同一位置的出入口进行上高速与下高速。

请你编程求出最少的通行费。

### 思路分析

这个题和卡车没什么关系，不要用结构体把入口和出口存在一起。这个题就是让我们把入口与出口配对，让差的绝对值的和最小。

对于入口和出口分别排序后，定义状态 $f(i)$ 表示后 $i$ 个入口和出口的最小的差的绝对值和。那怎么转移 $f(i)$ 呢？我们只需要枚举后三个即可，也就是 $f(i)$ 与 $f(i+1),f(i+2)$ 有关。为什么呢？

四个出入口可以拆分成 $1 + 3$, $2 + 2$, $3 + 1$ ，也就是说，再次计算四个入口是没有意义的。

将 $f(i)$ 初始化为 $inf$ ，然后计算 $i,i - 1,i - 2$ 的全排列中的最小代价 $cost$ ，最后 $f(i) = cost + f(i)$ 。

这个题建议评普及+。

### AC代码

```cpp
#include <bits/stdc++.h>
using namespace std;

#define uns unsigned
#define ll long long
#define use_cin_cout do {ios::sync_with_stdio(false); /*cin.tie();*/} while(false)
#define endl '\n'

const ll inf_ll = 0x3f3f3f3f3f3f3f3f;
const int inf = 0x3f3f3f3f, mod = 1e9 + 7;
const int maxn = 1e5 + 5;

int n;
int in[maxn], out[maxn], num[10];
ll dp[maxn];

ll cal(int a, int b) {
    return (a == b) ? 1ll << 60 : abs(a - b); // 
}

int main() {
    use_cin_cout;
    // freopen("cestarine.in", "r", stdin);
    // freopen("cestarine.out", "w", stdout);

    cin >> n;
    for (int i = 1; i <= n; i++) {
        cin >> in[i] >> out[i];
    }

    sort(in + 1, in + n + 1);
    sort(out + 1, out + n + 1);

    memset(dp, 63, sizeof(dp));
    dp[n + 1] = 0;
    for (int i = n; i >= 1; i--) {
        for (int j = 1; j <= 3 && i + j - 1 <= n; j++) {
            for (int k = 0; k < j; k++) num[k] = k;
            do {
                ll cost = 0;
                for (int k = 0; k < j; k++) cost += cal(in[i + k], out[i + num[k]]);
                dp[i] = min(dp[i], cost + dp[i + j]);
            } while (next_permutation(num, num + j));
        }
    }

    cout << dp[1] << endl;

    return 0;
}
```