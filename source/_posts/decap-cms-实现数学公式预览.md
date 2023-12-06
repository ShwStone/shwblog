---
title: decap-cms 实现数学公式预览
date: 2023-12-06 18:44:52
tags:
  - hexo
categories:
  - hexo
comments: true
sticky: 2
---

---

<!--more-->

decap-cms 免费，但是后端着实有些简陋。

不过 docs 里开放了 `CMS.registerPreviewTemplate`，我们可以自己实现一个。

方法：在 `admin/index.html` 的 `<body>` 标签中加入以下代码：

```html
<script type="module">
    import Markdown from 'https://esm.sh/react-markdown@9?bundle' // 替换内置 markdown
    import remarkMath from 'https://esm.sh/remark-math@6.0.0?bundle' // 数学公式
    import rehypeMathjax from 'https://esm.sh/rehype-mathjax@5.0.0?bundle' // 数学公式
    
    import remarkGfm from 'https://esm.sh/remark-gfm@4.0.0?bundle' // github 风格的 markdown 扩展
    import rehypeRaw from 'https://esm.sh/rehype-raw@7.0.0?bundle' // 内嵌 html 支持
    
    var PostPreview = createClass({
      render: function() {
        // return ReactMarkdownMath({markdown: this.props.widgetFor('body').props.value});
        return Markdown({
          children: this.props.widgetFor('body').props.value, 
          rehypePlugins: [rehypeMathjax, rehypeRaw],
          remarkPlugins: [remarkMath, remarkGfm]
        });
      }
    });
    CMS.registerPreviewTemplate("posts", PostPreview); // posts是你的 collections 的 name 字段
  </script>
```