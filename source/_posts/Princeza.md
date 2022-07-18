---
title: Princeza
date: 2022-07-13 16:23:41
tags:
categories:
- 信奥
- 题解
---
### 题目描述

Luka（女司机）把卡车停在湖边。Barica，Luka 知道她亲吻Barica，她会变成一个美丽的公主。但是，她需要先抓住她！

<!-- more -->

可以用一对坐标定义湖面上植物的位置。Barica 可以从 $(x, y)$ 植物跳跃到其它植物所在位置，$p$ 为任意正整数，下面给出了4种跳跃方式:

方向 A：$(x + p, y + p)$ 。

方向 B：$(x + p, y - p)$ 。

方向 C：$(x - p, y + p)$ 。

方向 D：$(x - p, y - p)$ 。

Barica选择四个方向之一，然后沿所选方向跳到该方向的第一个植物上。如果在选定的方向上没有植物，Barica将**留在原处**。

Barica跳完这一步之后，原来位置的植物将立马消失了。知道植物的位置和 Barica 选择的方向顺序后，Luka 希望确定Barica 最终将停留的植物的坐标。Luka 将在Barica最终的位置等她，亲吻她。编写一个解决Luka 问题的程序，并帮助她变成美丽的公主。

### 思路分析
显然，Barica只能沿着对角线方向跳。

但直接沿着对角线枚举太慢了，所以，对于每个节点，我们维护四个指针，指向其左上、右上、左下、右下的点，这样就可以在 $\Theta (n)$ 的复杂度模拟。

但为了建立这个图，我们需要 $\Theta (nlogn)$ 进行排序。

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

struct pos {
    int x, y, d1, d2, flag[4];
};

int n, k;
int id[maxn];
char dir[maxn];
pos graph[maxn];

bool d1_compare(int a, int b) {
    return graph[a].d1 < graph[b].d1 || graph[a].d1 == graph[b].d1 && graph[a].d2 < graph[b].d2;
}

bool d2_compare(int a, int b) {
    return graph[a].d2 < graph[b].d2 || graph[a].d2 == graph[b].d2 && graph[a].d1 < graph[b].d1;
}

int main() {
    use_cin_cout;
    // freopen("princeza.in", "r", stdin);
    // freopen("princeza.out", "w", stdout);

    cin >> n >> k;
    cin >> dir + 1;
    for (int i = 1; i <= n; i++) {
        cin >> graph[i].x >> graph[i].y;
        graph[i].d1 = graph[i].x + graph[i].y;
        graph[i].d2 = graph[i].x - graph[i].y;
        for (int j = 0; j < 4; j++) graph[i].flag[j] = -1;
        id[i] = i;
    }

    sort(id + 1, id + n + 1, d1_compare);
    for (int i = 2; i <= n; i++) {
        if (graph[id[i - 1]].d1 == graph[id[i]].d1) {
            graph[id[i - 1]].flag[1] = id[i];
            graph[id[i]].flag[2] = id[i - 1];
        }
    }

    sort(id + 1, id + n + 1, d2_compare);    
    for (int i = 2; i <= n; i++) {
        if (graph[id[i - 1]].d2 == graph[id[i]].d2) {
            graph[id[i - 1]].flag[0] = id[i];
            graph[id[i]].flag[3] = id[i - 1];
        }
    }

    int result = 1;
    for (int i = 1; i <= k; i++) {
        int nxt = graph[result].flag[dir[i] - 'A'];
        if (nxt == -1) continue;
        for (int j = 0; j < 4; j++) {
            if (graph[result].flag[j] != -1){
                graph[graph[result].flag[j]].flag[3 - j] = graph[result].flag[3 - j];
            }
        }
        result = nxt;
    }

    cout << graph[result].x << ' ' << graph[result].y << endl;

    return 0;
}
```