---
title: bitset优化Floyd传递闭包
date: 2022-07-16 15:51:40
tags: 
categories:
- 信奥
- 图论
---
### 加速8倍

<!--more-->

正常传递闭包需要三层循环：  
```cpp
for (int k = 1; i <= n; k++) {
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            if (graph[i][k] && graph[k][j]) {
                graph[i][j] = true;
            }
        }
    }
}
```
我们显然可以把第五行变成位运算：
```cpp
for (int k = 1; i <= n; k++) {
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            graph[i][j] |= graph[i][k] & graph[k][j];
        }
    }
}
```
这时候注意：在第四行中， `graph[i][k]` 是保持不变的，而 `graph[i]` 和 `graph[k]` 这两个数组都被 $j$ 全部遍历了。  
所以我们可以把 `bool graph[maxn][maxn]` 换成 `bitset<maxn> graph[maxn]` ，这样就可以把 `graph[i]` 和 `graph[k]` 直接按位或。如下：
```cpp
for (int k = 1; i <= n; k++) {
    for (int i = 1; i <= n; i++) {
        if (graph[i][k]) graph[i] |= graph[k];
    }
}
```
但需要注意的是，虽然循环变成了两层，但 `bitset` 的按位或也是 $O(n)$ 的复杂度。不过可以视为速度快了8倍。（一个 $byte$ 比一个 $bit$ 大8倍）  
实测真的会快。