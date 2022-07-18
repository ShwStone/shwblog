---
title: PATULJCI
date: 2022-07-13 16:21:39
tags:
categories:
- 信奥
- 题解
---
Update on 2022/02/19 ：卡常大师的题解已被兔爷撤下，希望大家杜绝学术造假的不正之风；添加了部分思路。

## 一种无需回滚的莫队写法

<!-- more -->

首先看到题就可以想到莫队。最朴素的写法就是维护莫队区间中每一种颜色的出现次数，同时维护莫队区间中的最大值。然后你会发现：莫队区间缩小的时候没法维护。  
考试的时候就卡在这里了，然后写了一个线段树维护的带 $\log$ 莫队，不出意外地 $T$ 了。考完才知道是随机化二分，教练说回滚莫队也可以做，不过本蒟蒻不会，只好仔细端详了数据范围，然后发现 $O(mc)$ 的方法是可以过的，所以很容易想到暴力的莫队——用一个数组维护区间中每一种颜色的出现次数，但是不同步维护最大值，每次移动到目标区间之后再暴力扫一下每一种颜色，求出最大值。  
理论上1e8比较悬，但是常数小，跑得也挺快。啥优化都没加，[一个点300ms](https://www.luogu.com.cn/record/69607228) 。试了一下吸氧，总时间跑到了700ms。  
代码：
```cpp
#include <bits/stdc++.h>
using namespace std;

const int maxc = 1e4 + 5, maxn = 3e5 + 5, maxm = 1e4 + 5;

struct node {
	int l, r;
	int id;
};

node quary[maxm];
int book[maxc], color[maxn], belong[maxn], anss[maxm];
int n, m, c, sqrtn;

bool compare(node a, node b) {
	return belong[a.l] != belong[b.l] ? belong[a.l] < belong[b.l] : (belong[a.l] & 1 ? a.r < b.r : a.r > b.r);
}

int main() {
	scanf("%d %d", &n, &c);
	sqrtn = pow(n, 0.5);
	for (int i = 1; i <= n; i++) {
		scanf("%d", color + i);
		belong[i] = i / sqrtn;
	}
	scanf("%d", &m);
	for (int i = 1; i <= m; i++) {
		scanf("%d %d", &quary[i].l, &quary[i].r);
		quary[i].id = i;
	}
	sort(quary + 1, quary + m + 1, compare);
	int l = 1, r = 0, maxi;
	for (int i = 1; i <= m; i++) {
		node q = quary[i];
		while (r < q.r) {
			r++;
			book[color[r]]++;
		}
		while (l > q.l) {
			l--;
			book[color[l]]++;
		}
		while (r > q.r) {
			book[color[r]]--;
			r--;
		}
		while (l < q.l) {
			book[color[l]]--;
			l++;
		}
		int maxid = 0;
		for (int j = 1; j <= c; j++) {
			if (book[j] > book[maxid]) maxid = j;
		}
		if (book[maxid] > (r - l + 1) >> 1) {
			anss[q.id] = maxid;
		}
		else anss[q.id] = -1;
	}
	for (int i = 1; i <= m; i++) {
		if (anss[i] == -1) printf("no\n");
		else printf("yes %d\n", anss[i]);
	}
	return 0;
}
```