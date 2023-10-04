---
title: xay-loves-tree题解
date: 2023-10-04 16:23:33
updateDate: 2023-10-04 16:23:33
tags:
categories:
- 信奥
- 题解
comments: true
top: 2
---

---
<!--more-->

首先考虑第二棵树的判定：如果两个点是祖孙关系，那么他们的子树一定有交集，而且其中一个是另一个的真子集。（显然爸爸的子树包含儿子的子树）我们先 DFS 一次，得到欧拉序，则一个子树就变成了欧拉序上的一段连续区间，我们的限制条件就变成了所选集合中的点对应的欧拉序区间没有交集。

然后我们来考虑如何处理第一棵树。

从题目可以知道，我们选的集合一定是从上往下的一段链。我们 DFS 枚举链的底部，只要能求出链的顶部就好。

怎么求呢？

假设当前枚举到了 $u$，则从 1 到 $u$ 的整条链上会有一些点与 $u$ 产生冲突，我们需要知道产生冲突的最深点。

这个最深点怎么求呢？将除了 $u$ 之外所有点的欧拉序区间在线段树上赋值为这个点的深度（比如路径上有 1、2、4，那么将 $[dfn_1,dfn_1 + siz_1 - 1],[dfn_2,dfn_2 + siz_2 - 1],[dfn_4,dfn_4 + siz_4 - 1]$ 在线段树上分别推平成 $dep_1,dep_2,dep_4$）。如此一来，在 $u$ 对应的欧拉序区间在线段树上的最大值就是会产生冲突的最大深度。

但是答案并不就是 $dep_u$ - 最大冲突深度，因为 $u$ 的祖先内部也有可能产生冲突。但是既然我们是 DFS 下来的，祖先之间的最低冲突深度可以直接继承下来，最后取个最小值。

最后的最后，回溯的时候要把 $u$ 的区间推平给删除。但是区间推平没有逆运算，所以我们要使用可持久化线段树，正好能用标记永久化维护推平（就是标记不下传，查询时经过一个点就取一次 $\max$）。

代码：

```cpp
#include <bits/stdc++.h>
using namespace std;

const int maxn = 3e5 + 5;

template <class T>
void read(T &r) {
    r = 0; char ch; bool f = false;
    while (!isdigit(ch = getchar())) if (ch == '-') f ^= 1;
    while (isdigit(ch)) r = r * 10 + ch - '0', ch = getchar();
    if (f) r = -r;
}

struct node;
typedef node* pos;
struct node {
    pos ls, rs; int l, r, val;
    node() { ls = rs = this; val = 0; }
} buf[maxn << 5], *buf_pos;
pos root[maxn];
pos new_node(int l = 0, int r = 0) { pos p = ++buf_pos; p -> l = l, p -> r = r, p -> ls = p -> rs = buf, p -> val = 0; return p; }
void build(pos p) { if (p -> l == p -> r) return; int mid = (p -> l + p -> r) >> 1; build(p -> ls = new_node(p -> l, mid)), build(p -> rs = new_node(mid + 1, p -> r)); }
pos update(pos p, int l, int r, int v) {
    if (l > p -> r || r < p -> l) return p;
    pos q = new_node(); *q = *p;
    return (l <= q -> l && q -> r <= r) ? (q -> val = max(q -> val, v), q) : (q -> ls = update(q -> ls, l, r, v), q -> rs = update(q -> rs, l, r, v), q);
}
int ask(pos p, int l, int r) { return (l > p -> r || r < p -> l) ? 0 : ((l <= p -> l && p -> r <= r) ? p -> val : max(p -> val, max(ask(p -> ls, l, r), ask(p -> rs, l, r)))); }

int t, n, ans, leaf_cnt, l[maxn], r[maxn];
vector<int> tree1[maxn], tree2[maxn];

void dfs_tree2(int u, int f) {
    int cnt = 0; l[u] = 0x3f3f3f3f, r[u] = 0;
    for (int v : tree2[u]) if (v != f) dfs_tree2(v, u), cnt++, l[u] = min(l[u], l[v]), r[u] = max(l[u], r[v]);
    if (!cnt) l[u] = r[u] = ++leaf_cnt;
}
void dfs_tree1(int u, int f, int d, int top) {
    root[u] = update(root[f], l[u], r[u], d), top = max(top, ask(root[f], l[u], r[u])), ans = max(ans, d - top);
    for (int v : tree1[u]) if (v != f) dfs_tree1(v, u, d + 1, top);
}

int main() {
    read(t);
    while (t--) {
        read(n);
        buf_pos = buf, root[0] = new_node(1, n), build(root[0]);
        for (int i = 1; i <= n; i++) tree1[i].clear(), tree2[i].clear();
        for (int i = 1; i < n; i++) {
            int u, v; scanf("%d %d", &u, &v);
            tree1[u].emplace_back(v), tree1[v].emplace_back(u);
        }
        for (int i = 1; i < n; i++) {
            int u, v; scanf("%d %d", &u, &v);
            tree2[u].emplace_back(v), tree2[v].emplace_back(u);
        }
        leaf_cnt = 0, dfs_tree2(1, 0);
        ans = 0, dfs_tree1(1, 0, 1, 0);
        printf("%d\n", ans);
    }
    return 0;
}
```