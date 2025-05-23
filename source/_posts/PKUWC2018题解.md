---
abbrlink: ''
categories:
- - 信奥
- - 题解
comments: true
date: '2024-01-09T19:28:53.253716+08:00'
sticky: 3
tags:
- 信奥
- 题解
title: PKUWC2018题解
updated: '2024-01-16T12:44:38.267+08:00'
---
<div></div>

<div></div>

<!--more-->

## Minimax

[$\mathcal{Link}$](https://www.luogu.com.cn/problem/P5298)

非常好题。

思路还是很简单的。我们只要求出每个权值最终的概率 $D_i$ 就行了。考虑怎么在已知两个子节点的情况下求出父节点的答案：

如果节点 $A$ 含有一组权值为 $\{a_i\}$ 的点，对应的概率是 $\{p_{i}\}$；节点 $B$，相应的，是 $\{b_i\}$ 与 $\{q_i\}$。他们的父节点 $F$ 以概率 $P_{max}$ 取较大值。这样，$A$ 中的某个值最终被取到的概率是 $P\{A > B\}P_{max}+P\{A<B\}(1-P_{max})$。也就是说，$a_i$ 对应概率是 $p_i(P_{max}\sum_{b_j < a_i}{q_j}+(1-P_{max})\sum_{b_j > a_i}{q_j})$。注意到这是在原有概率上乘上一个系数的形式。

这个东西当然可以暴力去合并，不过是 T 掉罢了。所以要考虑优化。

我们把 $F$ 的最终节点按权值从小到大排在数轴上，肯定是产生若干段：一段来自 $A$，一段来自 $B$，又一段来自 $A$……考虑同一段内部的权值，容易发现，它们共享了相同的系数，因为对于他们来说，另一点内大于他们的权值与小于他们的权值都是一样的。（$\sum_{b_j < a_i}$ 取到了一样的 $j$）这启发我们一段一段地计算结果。

到这之后，其实只需要拿一个线段树来实现整段乘系数这件事就好了。因为能够分出不同段的断点一共就 $n$ 个，而一个断点一旦被合并就不会再产生新段，所以整个合并过程中只出现了 $n$ 个段。我们用 $\mathcal{O}(\log n)$ 的时间处理一个段肯定绰绰有余。

具体到实现上来说，有一个优雅的写法：用动态开点线段树维护权值的概率，在两棵线段树上同步遍历，如果有一棵树有而另一棵没有，那么新线段树的这一部分就直接继承；否则递归左右子树，新线段树的这一点就由左右两点 $\operatorname{pushUp}$ 得到。递归进入左子树的时候，我们把右子树的和传进去，作为更新左子树的系数；反之就把左子树的和传进去，作为更新右子树的系数。比较类似 CDQ 分治或者说整体二分。

AC 代码：

{% spoiler code %}

```cpp
#include <bits/stdc++.h>
using namespace std;

#define FILE_IO
namespace io {...};
using namespace io;

const long long mod = 998244353;
long long quickPow(long long x, long long p) {
	long long res = 1; while (p) {
		if (p & 1LL) (res *= x) %= mod;
		(x *= x) %= mod;
		p >>= 1;
	} return res;
}
const long long inv = quickPow(10000, mod - 2);

const int maxn = 3e5 + 5;
int n, bcnt;
long long a[maxn], b[maxn];
vector<int> tree[maxn];

struct node;
typedef node* pos;
struct node {
	pos ls, rs;
	int l, r;
	long long val, tag;
	node() { ls = rs = this; l = r = 0, val = 0, tag = 1; }
} buf[maxn << 5], *bufPos = buf;
pos root[maxn];

pos newNode(int l, int r) {
	pos p = ++bufPos;
	p -> ls = p -> rs = buf;
	p -> l = l, p -> r = r;
	p -> val = 0, p -> tag = 1;
	return p;
}

void updateOne(pos p, long long tag) {
	if (p == buf) return;
	(p -> tag *= tag) %= mod;
	(p -> val *= tag) %= mod;
}

void pushUp(pos p) {
	p -> val = (p -> ls -> val + p -> rs -> val) % mod;
}

void pushDown(pos p) {
	if (p != buf && p -> tag != 1) {
		updateOne(p -> ls, p -> tag);
		updateOne(p -> rs, p -> tag);
		p -> tag = 1;
	}
}

void insert(pos p, int x) {
	if (p -> l == p -> r) {
		p -> val = 1;
		return;
	}
	pushDown(p);
	int mid = (p -> l + p -> r) >> 1;
	if (x <= mid) {
		if (p -> ls == buf) p -> ls = newNode(p -> l, mid);
		insert(p -> ls, x);
	} else {
		if (p -> rs == buf) p -> rs = newNode(mid + 1, p -> r);
		insert(p -> rs, x);
	}
	pushUp(p);
}

pos merge(pos p, pos q, long long pPre, long long pSuf, long long qPre, long long qSuf, long long pMax) {
	if (p == buf && q == buf) return buf;
	if (p == buf) {
		updateOne(q, (pMax * pPre + (1 + mod - pMax) * pSuf) % mod);
		return q;
	} else if (q == buf) {
		updateOne(p, (pMax * qPre + (1 + mod - pMax) * qSuf) % mod);
		return p;
	} else {
		pushDown(p), pushDown(q);
		long long pL = p -> ls -> val, pR = p -> rs -> val, qL = q -> ls -> val, qR = q -> rs -> val;
		p -> ls = merge(p -> ls, q -> ls, pPre, (pSuf + pR) % mod, qPre, (qSuf + qR) % mod, pMax);
		p -> rs = merge(p -> rs, q -> rs, (pPre + pL) % mod, pSuf, (qPre + qL) % mod, qSuf, pMax);
		pushUp(p);
		return p;
	}
}

void solve(int u) {
	if (tree[u].empty()) {
		root[u] = newNode(1, bcnt);
		insert(root[u], a[u]);
	} else if (tree[u].size() == 1) {
		solve(tree[u].back());
		root[u] = root[tree[u].back()];
	} else {
		solve(tree[u][0]); solve(tree[u][1]);
		root[u] = merge(root[tree[u][0]], root[tree[u][1]], 0, 0, 0, 0, a[u]);
	}
}

long long ans;
void calc(pos p) {
	if (p == buf) return;
	if (p -> l == p -> r) {
		(ans += b[p -> l] * p -> l % mod * p -> val % mod * p -> val) %= mod;
		return;
	} else {
		pushDown(p);
		calc(p -> ls);
		calc(p -> rs);
	}
}

int main() {
	read(n);
	for (int i = 1; i <= n; i++) {
		int f; read(f);
		if (f) tree[f].emplace_back(i);
	}
	for (int i = 1; i <= n; i++) {
		read(a[i]);
		if (tree[i].empty()) {
			b[++bcnt] = a[i];
		}
	}
	sort(b + 1, b + bcnt + 1);
	for (int i = 1; i <= n; i++) {
		if (tree[i].empty()) {
			a[i] = lower_bound(b + 1, b + bcnt + 1, a[i]) - b;
		} else {
			(a[i] *= inv) %= mod;
		}
	}
	solve(1);
	calc(root[1]);
	write(ans);
	return 0;
}
```

{% endspoiler %}
