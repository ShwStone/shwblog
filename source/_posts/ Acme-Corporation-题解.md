---
abbrlink: ''
categories:
- - 信奥
- - 题解
comments: true
date: '2024-02-21T11:21:02.578864+08:00'
sticky: 3
tags:
- 信奥
- 题解
title: ' Acme Corporation 题解'
updated: '2024-02-21T13:32:03.769+08:00'
---
[$\mathcal{Link}$](https://www.luogu.com.cn/problem/UVA11613)

<!--more-->

## 思路分析

注意到题目中“价格”、“容量”的定义和费用流中的相同。考虑费用流的方法。

建图的方式比较平凡。只需要将每个月份拆成“生产”和“售卖”两个点，从源点向生产点根据生产限制连边，从售卖点向汇点根据售卖限制连边。而在内部，我们将第 $i$ 月的“生产”与它之后保质期内月份的“售卖”连边。这样，从源点到汇点就能表示原题的限制。

但如果你这样跑一次，样例就会输出 `-5` ——居然亏钱了。

仔细一想就会知道，费用流要先满足最大流，但其实，我们不需要卖那么多，只要让利润最大就好。怎么办呢？

既然费用流要先满足最大流，能不能对图的结构做一些修改，使得无论卖多少矿物，流的大小都一样呢？

设原先的源点汇点是 $s$、$t$，我们新建两个点 $s'$、$t'$，从 $s' \to s$，$s \to t$，$t \to t'$ 各连一条容量无穷大，费用为 0 的边。这样计算 $s'$ 到 $t'$ 的费用流，无论月份结点流了多少流量，由于 $s \to t$ 边的存在，总流量都是无穷大，而费用就是月份结点的费用。这样就实现了最小费用任意流。

其它的题解都是在费用流中提前终止实现的，正确性不显然，这个方法会更无脑一点。

## AC 代码

由于 RMJ 问题，在洛谷没有 AC 记录。

```cpp
#include <bits/stdc++.h>
using namespace std;

template <class T> void read(T &r) {
    r = 0; int ch = getchar(), f = 0;
    while (!isdigit(ch)) f ^= (ch == '-'), ch = getchar();
    while (isdigit(ch)) (r *= 10) += ch - 48, ch = getchar();
    if (f) r = -r;
}
template <class T, class... Ts> void read(T &r, Ts &...rs) { read(r); read(rs...); }

#define in(u) u
#define out(u) u + n

const int maxm = 5e2 + 5, maxn = 1e3 + 5;
const long long inf = 0x3f3f3f3f3f3f3f3f;

int n, cnt = 1, s, t, ss, tt;
struct Edge {
    int v, nxt;
    long long w, c;
} e[maxm];
int head[maxn], cur[maxn], ti[maxn];
long long dis[maxn], c1[maxn], w1[maxn], c2[maxn], w2[maxn], cost, k;
bool vis[maxn];

void add(int u, int v, long long w, long long c) {
    e[++cnt].nxt = head[u]; head[u] = cnt;
    e[cnt].v = v, e[cnt].w = w, e[cnt].c = c;
}
bool spfa() {
    deque<int> dq; dq.emplace_back(t);
    memset(dis, 0x3f, sizeof dis); memset(vis, 0, sizeof vis);
    vis[t] = true; dis[t] = 0; while (!dq.empty()) {
        int u = dq.front(); dq.pop_front(); vis[u] = false;
        for (int i = head[u]; i; i = e[i].nxt) {
            if (e[i ^ 1].w && dis[e[i].v] > dis[u] - e[i].c) {
                dis[e[i].v] = dis[u] - e[i].c;
                if (!vis[e[i].v]) {
                    if (!dq.empty() && dis[e[i].v] < dis[dq.front()]) dq.emplace_front(e[i].v);
                    else dq.emplace_back(e[i].v);
                    vis[e[i].v] = true;
                }
            }
        }
    } return dis[s] != inf;
}
long long dfs(int u = s, long long flow = inf) {
    vis[u] = true; if (!flow || u == t) return flow;
    long long rest = flow; for (int i = cur[u]; i; i = e[i].nxt) {
        cur[u] = i; if (!vis[e[i].v] && dis[e[i].v] == dis[u] - e[i].c && e[i].w) {
            long long tmp = dfs(e[i].v, min(rest, e[i].w)); 
            e[i].w -= tmp, e[i ^ 1].w += tmp;
            if (!(rest -= tmp)) break;
        }
    } return flow - rest;
}
void mcmf() {
    cost = 0; while (spfa()) do {
        memcpy(cur, head, sizeof cur); memset(vis, 0, sizeof vis); 
        cost += dis[s] * dfs();
    } while (vis[t]);
}

int main() {
    int _; read(_);
    for (int __ = 1; __ <= _; __++) {
        read(n, k); cnt = 1; memset(head, 0, sizeof head); s = 0, t = 2 * n + 1, ss = 2 * n + 2, tt = 2 * n + 3;
        for (int i = 1; i <= n; i++) read(c1[i], w1[i], c2[i], w2[i], ti[i]);
        for (int i = 1; i <= n; i++) {
            add(ss, in(i), w1[i], c1[i]);
            add(in(i), ss, 0, -c1[i]);
            add(out(i), tt, w2[i], -c2[i]);
            add(tt, out(i), 0, c2[i]);
            for (int j = i; j <= min(n, i + ti[i]); j++) {
                add(in(i), out(j), inf, k * (j - i));
                add(out(j), in(i), 0, -k * (j - i));
            }
        }
        add(ss, tt, inf, 0); add(tt, ss, 0, 0);
        add(s, ss, inf, 0); add(ss, s, 0, 0);
        add(tt, t, inf, 0); add(t, tt, 0, 0);
        mcmf();printf("Case %d: %lld\n", __, -cost);
    }
    return 0;
}
```
