---
title: CSP-RP++
date: 2022-07-13 16:21:06
tags:
categories:
- 信奥
---

# 赛前总结

## 心态决定状态
考前、考中、考后都以一颗平常心对待，备在平时，战在赛场，问心无愧，加油，少年！

<!-- more -->

## 缺省源
```cpp
#include <bits/stdc++.h>
using namespace std;

#define uns unsigned
#define ll long long
#define use_cin_cout ios::sync_with_stdio(false)
#define endl '\n'

const ll inf_ll = 0x3f3f3f3f3f3f3f3f;
const int inf = 0x3f3f3f3f, mod = 1e9 + 7;
const int maxn = 1e6 + 5;

int main() {
    use_cin_cout;
    freopen("*.in", "r", stdin);
    freopen("*.out", "w", stdout);

    return 0;
}
```

## 文件操作
```cpp
freopen("*.in", "r", stdin);
freopen("*.out", "w", stdout);
```

## 模拟
仔细读题，注意细节，注意 `long long` 。

## 贪心
仔细读题，注意细节，注意 `long long` 。  

排序相关：
```cpp
bool compare(your_own_node a, your_own_node b) {
    return a.v < b.v;
}
sort(* + 1, * + len + 1, compare);
//不加compare默认从小到大

bool operator < (your_own_node a, your_own_node b) {
    return a.v < b.v;
}
//重载运算符也可以用于sort，但是不能重载int这样的系统数据结构。
```

## 递推 & 递归
仔细读题，注意细节，注意 `long long` 。  
递归注意边界。

## 二分
```cpp
bool check(int x) {
    return x > 0;
}

int l, r, mid;
while (l < r) {
    mid = (l + r) >> 1;
    if (check(mid)) r = mid;
    else l = mid + 1;
} 
//找到符合check的最小。

while (l < r) {
    mid = (l + r + 1) >> 1;
    if (check(mid)) l = mid;
    else r = mid - 1;
}
//找到符合check的最大。

double l, r, mid, eps;
while (l + eps < r) {
    mid = (l + r) >> 1;
    if (check(mid)) r = mid;
    else l = mid + eps;
}
```
- ### 二分答案
- ### 二分查找

## 搜索
- ### 暴力枚举
- ### DFS
注意边界，注意 `bool` 数组的标记， 不要重复搜索。
- ### BFS
注意边界，注意 `bool` 数组的标记， 不要重复搜索。
- ### 记忆化搜索
  - #### 可行性剪枝
  - #### 最优化剪枝
  - #### 记忆化

## 前缀和及二维前缀和
```cpp
for (int i = 1; i <= n; i++) {
    sum[i] = sum[i - 1] + num[i];
}
//查找区间和：i...j = sum[j] - sum[i - 1];

for (int i = 1; i <= n; i++) {
    for (int j = 1; j <= n; j++) {
        sum[i][j] = sum[i - 1][j] + sum[i][j - 1] - sum[i - 1][j - 1] + num[i][j];
    }
}
//查找矩阵和：(x,y),(i,j) = sum[i][j] - sum[i][y - 1] - sum[x][j - 1] + sum[x - 1][y - 1];
```

## 差分
```cpp
for (int i = 1; i <= n; i++) {
    f[i] = num[i] - num[i - 1];
}
//区间更改：i...j + d -> f[i] += d; f[j + 1] -= d;
```

## 尺取法
拿草稿纸画一画。

## 数据结构
- ### 单调栈（含悬线法）
    悬线法我不会啊。
    单调栈一般维护当前节点往前找到的第一个小于/大于它的点，分别对应递增栈/递减栈。
    ```cpp
    //递增栈
    stack<int> s;
    for (int i = 1; i <= n; i++) {
        while (!s.empty() && num[s.top()] >= num[i]) s.pop();
        min_left[i] = s.top();
        s.push(i);
    }
    //min_left中存储向左第一个小于它的节点的下标。
    ```

- ### 单调队列
    单调队列一般维护当前节点往前找m个点的最大/小值，分别对应递增队列/递减队列。一般用 `deque` 实现。
    ```cpp
    //递增队列
    while (!q.empty()) q.pop_back();
    num[0] = num[n + 1] = inf;
    q.push_back(0);
    for (int i = 1; i < k; i++) {
        while (!q.empty() && num[q.back()] >= num[i]) q.pop_back();
        q.push_back(i);
    }
    for (int i = k; i <= n; i++) {
        while (!q.empty() && num[q.back()] >= num[i]) q.pop_back();
        q.push_back(i);
        while (!q.empty() && q.front() < i - k + 1) q.pop_front();
        minium[i - k + 1] = num[q.front()];
    }
    ```

- ### 优先队列（堆）
    ```cpp
    bool operator < (your_own_node a, your_own_node b) {
        return a.v < b.v;
    }
    //重载运算符不能重载int这样的系统数据结构。

    priority_queue<your_own_node> p_q;
    //注意优先队列与运算符重载相反，这样写是大根堆。
    
    template<class T>
    class compare {
    public:
        bool operator () (T a, T b) {
            return abs(a) < abs(b);
        }
    };
    priority_queue<int, vector<int>, compare<int> > p_q;
    //用仿函数就可以支持系统类型，不过仍然相反，这样写是按绝对值的大根堆。
    //less和greater其实也是这个原理。
    ```
- ### 树状数组*
## RMQ问题
- ### ST表
- ### 树状数组*
- ### 线段树*
## 位运算
## 动态规划
- ### 线性动规
- ### 背包
- ### 区间动规
- ### 树型动规*
## 图论
- ### 图的存储
- ### 拓扑排序
- ### 最短路算法
- ### 最小生成树算法
## STL
- ### pair
- ### map
- ### set
- ### bitset
- ### stack
- ### queue
- ### deque
- ### priority_queue
- ### vector
