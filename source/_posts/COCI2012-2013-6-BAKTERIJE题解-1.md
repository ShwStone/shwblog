---
title: COCI2012-2013#6 BAKTERIJE题解
date: 2022-10-06 07:35:32
updateDate: 2022-10-15 16:56:04
tags:
  - 信奥
  - 题解
categories:
  - 信奥
  - 题解
comments: true
top: 2
---
[Link](https://www.luogu.com.cn/problem/P4621)

<!--more-->

## 题目分析

这个题在 Luogu 居然评了黑，也是比较离谱的。

首先这是一道大模拟。考察每一个细菌的行为，可以发现其状态可以用三元组 $(x, y, d), 1 \le x \le n, 1 \le y \le m, 0 \le d < 4$ 表示。其中 $(x, y)$ 为位置， $d$ 为方向。

显而易见的，细菌的行动最终一定陷入循环，所以我们可以通过模拟求出细菌循环节的长度以及他进入循环之前需要走的步数。

考虑用记录到达位置 $(x, y, d)$ 所需的步数。在模拟的过程中，如果发现重复进入同一个位置说明产生了循环，循环节长度为当前步数 - 第一次步数，记为 $stp$ ，进入循环节之前的步数记为 $st$ 。

由于题目要求所有细菌进入陷阱，所以我们还要统计每一个细菌进入陷阱的时刻。用 $pas_i$ 表示细菌第一次以方向 $i$ 进入陷阱的时刻。可以发现，如果 $pas_i < st$ ，则细菌只可能在进入循环节之前以方向 $i$ 进入陷阱，在循环节中绝对不会（如果也进了说明 $st$ 可以提前到 $pas_i$ ）。同理，在循环节中经过的也不会在循环节之前经过。所以用一个数组就可以记录，互不干扰。

大致代码如下：

```cpp
void calc(int id) {
	memset(book, 0, sizeof book);
	book[a[id].x][a[id].y][a[id].d] = 1;
	while (true) {
		if (a[id].x == xx && a[id].y == yy) a[id].pas[a[id].d] = book[a[id].x][a[id].y][a[id].d];
		int td = ((a[id].d + a[id].mp[a[id].x][a[id].y]) & 3),
			tx = a[id].x + ch_d[td][0],
			ty = a[id].y + ch_d[td][1];
		if (tx < 1 || tx > n || ty < 1 || ty > m) {
			td = ((td + 2) & 3);
			tx = a[id].x + ch_d[td][0];
			ty = a[id].y + ch_d[td][1];
		}
		if (book[tx][ty][td]) {
			a[id].st = book[tx][ty][td];
			a[id].stp = book[a[id].x][a[id].y][a[id].d] + 1 - book[tx][ty][td];
			return;
		}
		book[tx][ty][td] = book[a[id].x][a[id].y][a[id].d] + 1;
		a[id].x = tx;
		a[id].y = ty;
		a[id].d = td;
	}
}
```

接下来对于怎么求答案进行分析：

首先如果有一个细菌没有经过陷阱，那么直接输出 `-1` 。

接下来要把问题分为两部分。求出最晚进入循环的细菌进入循环的时刻，记为 $maxst$ ，则在 $maxst$ 之前的时刻可以暴力枚举，在 $maxst$ 之后的时间可以用数学方法。

在 $maxst$ 之前的时刻枚举如下，注意此时已经有一些细菌进入循环，所以也要考虑进入循环的细菌。

```cpp
for (long long i = 0; i <= mst; i++) {
    bool flag = true;
    for (int j = 1; j <= k; j++) {
        bool f = false;
        for (int l = 0; l < 4; l++) {
            if (a[j].pas[l] == 0) continue;
            if (a[j].pas[l] < a[j].st) {
                if (a[j].pas[l] == i) {
                    f = true;
                    break;
                }
            }
            else if (i >= a[j].pas[l] && i % a[j].stp == a[j].pas[l] % a[j].stp) {
                f = true;
                break;
            }
        }
        if (f == false) {
            flag = false;
            break;
        }
    }
    if (flag) {
        printf("%lld\n", i);
        return 0;
    }
}
```

而在进入循环之后，实际上就是求解这样一个方程组：

$$
\begin{cases}
x \equiv a[1].pas_0\ \ or\ \ a[1].pas_1\ \ or\ \ a[1].pas_2\ \ or\ \ a[1].pas_3 \pmod {a[1].stp}\\
x \equiv a[2].pas_0\ \ or\ \ a[2].pas_1\ \ or\ \ a[2].pas_2\ \ or\ \ a[2].pas_3 \pmod {a[2].stp}\\
x \equiv a[3].pas_0\ \ or\ \ a[3].pas_1\ \ or\ \ a[3].pas_2\ \ or\ \ a[3].pas_3 \pmod {a[3].stp}\\
x \equiv a[4].pas_0\ \ or\ \ a[4].pas_1\ \ or\ \ a[4].pas_2\ \ or\ \ a[4].pas_3 \pmod {a[4].stp}\\
x \equiv a[5].pas_0\ \ or\ \ a[5].pas_1\ \ or\ \ a[5].pas_2\ \ or\ \ a[5].pas_3 \pmod {a[5].stp}
\end{cases}
$$

因为一共就 5 个细菌，每个细菌 4 种选择，所以可以先枚举所有的情况，求解 $4^5$ 次如下方程组：

$$
\begin{cases}
x \equiv pas_1 \pmod {a[1].stp}\\
x \equiv pas_2 \pmod {a[2].stp}\\
x \equiv pas_3 \pmod {a[3].stp}\\
x \equiv pas_4 \pmod {a[4].stp}\\
x \equiv pas_5 \pmod {a[5].stp}
\end{cases}
$$

标准答案大概是现在使用扩展 CRT （中国剩余定理），求解同余方程组。如果这样黑题也就勉勉强强，但有意思的是直接暴力 CRT 就可以 AC 。这黑题就有点水了。

枚举方程组和暴力 CRT 如下：

```cpp
long long cal() {
	long long res = yushu[1];
	long long lllcm = moshu[1];
	for (int i = 2; i <= k; i++) {
		int cnt = 0;
		while (res % moshu[i] != yushu[i]) {
			res += lllcm;
			res %= llcm;
			if (++cnt > moshu[i]) return LLONG_MAX;
		}
		lllcm = lcm(lllcm, moshu[i]);
	}
	while (res < mst) res += llcm; //注意要在循环之内
	return res;
}

void doit(int id) {
	if (id == k + 1) {
		ans = min(ans, cal());
		return;
	}
	for (int i = 0; i < 4; i++) {
		if (a[id].pas[i] < a[id].st) continue;
		moshu[id] = a[id].stp;
		yushu[id] = a[id].pas[i] % a[id].stp;
		doit(id + 1);
	}
}
```

个人觉得降紫还是合理的。

# AC代码

{% spoiler code %}

```cpp
#include <bits/stdc++.h>
using namespace std;

const int maxn = 5e1 + 5, maxk = 7;
const int ch_d[4][2] = {{-1, 0}, {0, 1}, {1, 0}, {0, -1}};

struct node {
	int x, y, d;
	long long st, stp;
	long long pas[4];
	char mp[maxn][maxn];
};

int n, m, k, xx, yy;
node a[maxk];
int book[maxn][maxn][4];
int dir[256];
long long mst, ans = LLONG_MAX, llcm = 1, sum = 1;
long long moshu[maxk], yushu[maxk];

long long lcm(long long a, long long b) {
	return a / __gcd(a, b) * b;
}

void calc(int id) {
	memset(book, 0, sizeof book);
	book[a[id].x][a[id].y][a[id].d] = 1;
	while (true) {
		if (a[id].x == xx && a[id].y == yy) a[id].pas[a[id].d] = book[a[id].x][a[id].y][a[id].d];
		int td = ((a[id].d + a[id].mp[a[id].x][a[id].y]) & 3),
			tx = a[id].x + ch_d[td][0],
			ty = a[id].y + ch_d[td][1];
		if (tx < 1 || tx > n || ty < 1 || ty > m) {
			td = ((td + 2) & 3);
			tx = a[id].x + ch_d[td][0];
			ty = a[id].y + ch_d[td][1];
		}
		if (book[tx][ty][td]) {
			a[id].st = book[tx][ty][td];
			a[id].stp = book[a[id].x][a[id].y][a[id].d] + 1 - book[tx][ty][td];
			return;
		}
		book[tx][ty][td] = book[a[id].x][a[id].y][a[id].d] + 1;
		a[id].x = tx;
		a[id].y = ty;
		a[id].d = td;
	}
}

long long cal() {
	long long res = yushu[1];
	long long lllcm = moshu[1];
	for (int i = 2; i <= k; i++) {
		int cnt = 0;
		while (res % moshu[i] != yushu[i]) {
			res += lllcm;
			res %= llcm;
			if (++cnt > moshu[i]) return LLONG_MAX;
		}
		lllcm = lcm(lllcm, moshu[i]);
	}
	while (res < mst) res += llcm;
	return res;
}

void doit(int id) {
	if (id == k + 1) {
		ans = min(ans, cal());
		return;
	}
	for (int i = 0; i < 4; i++) {
		if (a[id].pas[i] < a[id].st) continue;
		moshu[id] = a[id].stp;
		yushu[id] = a[id].pas[i] % a[id].stp;
		doit(id + 1);
	}
}

int main() {
	dir['U'] = 0; dir['R'] = 1; dir['D'] = 2; dir['L'] = 3;
	scanf("%d %d %d", &n, &m, &k);
	scanf("%d %d", &xx, &yy);
	for (int i = 1; i <= k; i++) {
		char ch; scanf("%d %d %c", &a[i].x, &a[i].y, &ch);
		a[i].d = dir[ch];
		for (int j = 1; j <= n; j++) {
			scanf("%s", a[i].mp[j] + 1);
			for (int l = 1; l <= m; l++) a[i].mp[j][l] -= 48;
		}
		calc(i);
		if (!(a[i].pas[0] || a[i].pas[1] || a[i].pas[2] || a[i].pas[3])) {
			printf("-1\n");
			return 0;
		}
	}
	for (int i = 1; i <= k; i++) {
		mst = max(mst, a[i].st);
		llcm = lcm(llcm, a[i].stp);
	}
	for (long long i = 0; i <= mst; i++) {
		bool flag = true;
		for (int j = 1; j <= k; j++) {
			bool f = false;
			for (int l = 0; l < 4; l++) {
				if (a[j].pas[l] == 0) continue;
				if (a[j].pas[l] < a[j].st) {
					if (a[j].pas[l] == i) {
						f = true;
						break;
					}
				}
				else if (i >= a[j].pas[l] && i % a[j].stp == a[j].pas[l] % a[j].stp) {
					f = true;
					break;
				}
			}
			if (f == false) {
				flag = false;
				break;
			}
		}
		if (flag) {
			printf("%lld\n", i);
			return 0;
		}
	}
	doit(1);
	if (ans == LLONG_MAX) printf("-1\n");
	else printf("%lld\n", ans);
	return 0;
}
```

{% endspoiler %}