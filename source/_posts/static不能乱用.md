---
title: static不能乱用
date: 2022-08-11 11:04:31
tags: null
categories: null
comments: true
top: 2
updateDate: 2022-08-11 11:04:31
---

---

<!--more-->

我以前只知道 `static` 关键字可以让变量读取变快，但是实际上对 `static` 的滥用会导致极为严重的后果。

我们来看一个案例：

```cpp
//读入失败返回true
template <class T> bool read(T &r) {
    r = 0; static char ch = getchar(); static bool f = false;
    while (ch < 48 || ch > 57) { if (ch == EOF) return true; if (ch == 45) f ^= 1; ch = getchar(); }
    while (ch >= 48 && ch <= 57) { r = r * 10 + ch - 48; ch = getchar(); }
    if (f) r = -r; return false;
}
template <class T> void write(T w, char end = '\n') {
    static char write_buf[55], *pos = write_buf;
    if (w == 0) { putchar('0'); putchar(end); return; }
    if (w < 0) { putchar('-'); w = -w; }
    while (w) {
        *(pos++) = w % 10 + '0';
        w /= 10;
    }
    while (pos != write_buf) putchar(*(--pos));
    putchar(end);
}
```

这是我先前版本的[模板](/2022/07/14/模板/)中的快读快写的板子。可以看到一些局部变量使用了 `static` 。原指望可以加快速度，但是使用一段时间后就发现了输入正数变成负数，输出含有前导0的情况。什么原因呢？

`static` 设计之初的意图使用来保存函数上一次调用时的值，他的初始化是只会执行一次的。比如 `static bool f = false;` ，f变量只有在程序开始时会被复制为 `false` ，之后一但有一次变成了 `true` ，下一次调用是仍然会是 `true` ，就会导致接下来的输入都会变成负数。同样的，输出有前导0也是因为 `pos` 指针没有归0。

怎么解决呢？一种方法是弃用 `static` ，另一种方法是将复制和初始化分开，使用 `static bool f; f = false` ，但这样就没什么意思了。所以现在新版本的快读快写弃用了小变量的 `static` ，只保留了 `buf` 数组的 `static` 来避免每次调用重新申请的时间。

所以，特别是OIers一定要注意，不要只为了快而使用 `static` ，要理解这个关键字的真正用途。
