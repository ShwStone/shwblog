---
title: 记一次惨痛的JS开发
comments: true
top: 2
date: 2022-12-29 20:59:39
updateDate: 2022-12-29 20:59:39
tags:
categories:
---

---

<!--more-->

警钟常鸣！

## bug 复现

事情是这样的：这几天一直在做 electron 开发，写一个[网课教师助手](https://github.com/TianYuan-College/online-class-helper)。然后需要在页面即时渲染动态的学生信息，我写了大概类似下面的代码：

```js
const dom = document.getElementById(...);
for (const val of map.values()) {
    // 动态添加元素
    dom.innerHTML += `<div id=${val}>...</div>`;
    // 监听元素事件
    document.getElementById(val).addEventListener('...', (event) => ...);
}
```

然后离谱的事情来了，我用尽无数办法，却只有最后一个元素的 Event 能够被成功触发。

注：这个 bug 浪费了我三个晚上的时间。

## 原因

我们来看 MDN Docs 是怎么说的：

> 当给 `innerHTML` 设置一个值的时候到底发生了什么？用户代理按照以下步骤：
> 1.  给定的值被解析为 HTML 或者 XML（取决于文档类型），结果就是 [`DocumentFragment`](https://developer.mozilla.org/zh-CN/docs/Web/API/DocumentFragment) 对象代表元素新设置的 DOM 节点。
> 2.  如果元素内容被替换成 [`<template>`](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/template) 元素，`<template>` 元素的 [`content`](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLTemplateElement/content "content") 属性会被替换为步骤 1 中创建的新的 `DocumentFragment`。
> 3.  对于其他所有元素，元素的内容都被替换为新的 `DocumentFragment` 节点。

这就意味着 dom 内部的所有元素都被重新解析，导致先前添加的 Event 失效。

如何解决呢？一种方法是将 HTML 的生成与 addEventListener 方法分开，放在两个循环里。另一种方法是 MDN Docs 极力推荐：

> 如果要向一个元素中插入一段 HTML，而不是替换它的内容，那么请使用 [`insertAdjacentHTML()`](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/insertAdjacentHTML "insertAdjacentHTML()") 方法。

appendChild 也是一个道理。

## 总结

innerHTML 虽然快捷，但并不是安全可靠的手段。在网站中动态更改内容，还是不要直接对 HTML 文本进行修改，而是调用 DOM 接口更好。直接修改会造成许多难以预料的副作用。
