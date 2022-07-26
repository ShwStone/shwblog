---
title: hexo+next搭建博客（github转netlify）
date: 2022-07-26 08:49:54
tags: 博客
categories:
- hexo
comments: true
top: 2
---

本站的搭建经历了很多的步骤，现记录如下，写一个备忘，也是帮助其他人。

<!--more-->

## hexo+github

首先是hexo的使用。先前我了解过github pages的使用，原理很简单：github对每一个项目都可以建立一个page，前提是代码仓库的根目录上至少要有一个 `index.html` 。生成的page放在域名 `username.github.io/repositoryname` 上。当 `repositoryname` 和 `username` 相同的时候，域名简化成 `username.github.io` ，很适合建立个人博客。这样的博客都是静态的，也就是说，网站的所有文件都是生成好的，直接上传到github即可。

那么怎么生成网站的静态文件呢？使用hexo、 `hugo` 等静态网站生成器就可以完成。生成完的网站文件在 `public` 目录下，将 `public` 目录上传到github即可。

### hexo

首先来看[hexo](https://hexo.io/zh-cn/)。

参考官方教程就可以完成基础配置。这里简单归纳一下：

#### 安装

hexo要由node.js的软件包管理器npm安装。此外hexo依赖于git,所以要现安装node.js和git。

```sh
yay -S nodejs git
# sudo pacman -S nodejs git
# sudo apt install nodejs git-core 
# sudo yum install nodejs git-core
```

对于其他用户：

- [git](https://git-scm.com/downloads)
- [nodejs](https://nodejs.org/zh-cn/)

然后使用npm安装hexo：

```sh
sudo npm install -g hexo-cli
```

#### 建站

选择你想要建立blog的路径。假设想要建立在 `~/Blog` 文件夹：

```sh
cd ~; hexo init Blog; cd Blog; npm install
```

ok。现在hexo已经可以使用。默认有一篇文章 `helloworld` 。注意：如果hexo一篇文章都没有，则无法生成网站。

此时网站的目录如下：

```txt
.
├── _config.yml
├── package.json
├── scaffolds
├── source
|   ├── _drafts
|   └── _posts
└── themes
```

`_config.yml` 是配置网站的地方， `source` 里面存储的都是网站的文章，其中 `_posts` 的内容会被编译成html, `_drafts` 目录会被忽略，而其他文件会原样复制到网站的根目录。 `themes` 文件夹里存储了主题文件。下文说的next主题就要放在这里。

在开始配置之前，先来试一试吧！你将看到默认主题landscape下的helloworld文章。

```sh
hexo clean && hexo s
```

这将会在你的计算机上运行一个网站实例，一般来说会在 `localhost:4000` 。这意味着跟你在同一局域网的人就可以访问这个网站。如果4000端口被占用，你也可以选择其他端口：

```sh
hexo clean && hexo s -p 1234
```

这将会在 `localhost:1234` 上运行一个网站实例。

无论在哪个端口，它看上去应该像这样：

![](/images/helloworld.png)

#### 配置

`_config.yml` 文件包括了站点的基础属性。

其中的大部分内容我们不用改。我们只要改基本信息：

```yaml
# Site
title: Hexo
subtitle: ''
description: ''
keywords:
author: John Doe
language: en
timezone: ''

# URL
## Set your site url here. For example, if you use GitHub Page, set url as 'https://username.github.io/project'
url: http://example.com
permalink: :year/:month/:day/:title/
permalink_defaults:
pretty_urls:
  trailing_index: true # Set to false to remove trailing 'index.html' from permalinks
  trailing_html: true # Set to false to remove trailing '.html' from permalinks
```

这里是网站的基本信息。 `title` 是主标题， `subtitle` 是副标题。 `description` 可以是你的一句座右铭， `keywords` 越多越好，用逗号隔开。 `author` 写你的名字， `language` 选 `zh-CN` ， `timezone` 选 `Asia/Shanghai` 。 `url` 就填写你的网址（ `username.github.io` ）。

再试一下 `hexo s` ，就可以发现网站标题等改变了。

### github

好。现在我们考虑怎么把网站放到github上：

首先我们要知道怎么生成 `public` 文件夹：

```sh
hexo clean && hexo g
```

现在 `Blog` 目录中就有了 `public` 目录。我们可以手动把它push到git仓库上。

```sh
git push git@github.com:username/username.github.io --set-upstream main -f
```

这里前提是要配置好ssh-key。操作也很简单：

```sh
ssh-keygen -t rsa -b 4096
# 一路回车，直到出现如下字样：
# Your identification has been saved in ~/.ssh/id_rsa
# Your public key has been saved in ~/.ssh/id_rsa.pub
# The key fingerprint is:
# SHA256: ###############################
# The key's randomart image is:
# +---[RSA ####]----+
# |##########       |
# |##########       |
# |##########       |
# |##########       |
# |##########       |
# |##########       |
# |##########       |
# |##########       |
# |##########       |
# +----[SHA256]-----+
# #号部分是你的SHA256信息。
```

然后将公钥上传github：

```sh
cat ~/.ssh/id_rsa.pub
```

将文件内容复制后，打开github个人settings-ssh，添加公钥，将复制内容粘贴进去。

那么打开username.github.io的仓库配置，settings-pages,选择打开pages（默认应该是打开的），再打开网站 `username.github.io` 就可以看到刚刚生成的网址了。

#### 自动化

但是这么做还是太low了。hexo有一个功能deploy，可以将已经生成好的 `public` 文件夹自动上传，不过需要我们配置一下。

安装插件 `hexo-deployer-git`

```sh
npm install hexo-deployer-git --save
```

然后打开之前提到的 `_config.yml` ，找到deploy字段，更改如下：

```yaml
# Deployment
## Docs: https://hexo.io/docs/one-command-deployment
deploy:
  type: git
  repo: git@github.com:username/userame.github.io
  branch: main
```

现在只要一行命令，就可以直接编译并部署了。

```sh
hexo clean && hexo d -g # or hexo g -d
```

### 新建文章

hexo新建文章最好使用命令：

```sh
hexo new #postname
```

文章无需后缀名，自动使用markdown后缀。如果题目中有空格或特殊字符，加上双引号：

```sh
hexo new "postname"
```

hexo的文章开头存储了一些yaml信息，用 `---` 表示开头结尾。这些信息被称为 `font-matter` ，记录了文章的标题、日期等，文章的属性都在 `font-matter` 上。

### 新建页面

hexo支持建立一些页面，同时也支持对文章进行分类和标签，分类和标签信息都存储在 `font-matter` 中。

#### 分类和标签

在hexo中，分类和标签不是一个东西。他们的形式很像：

```yaml
categories: #分类
-category1
-category2
#...
tags: #标签
-tag1
-tag2
#...
```

但是他们的含义不一样。categories表示文章属于category1类别中的category2类别，而tags表示文章既是tag1标签，又是tag2标签。可以看到categories是有严格父子关系的，而tags是并列的。

如果希望读者能够通过分类和标签索引文章，需要新建categories页面和tags页面：

```sh
hexo new page categories && hexo new page tags
```

此时在 `source` 文件夹下就会多出categories文件夹和tags文件夹。文件夹中有一个 `index.md` 。打开markdown，在 `font-matter` 中分别加入 `type: "categories"` 和 `type: "tags"` 。正文留空。就完成了构建。

#### 关于

同理，新建about页面。

```sh
hexo new page about
```

编辑 `source/about/index.md` ，加入 `type: "about"` ，然后在正文部分编辑自我介绍内容。

#### 404

腾讯公益404接入方法如下：

```html
<script type="text/javascript" src="//qzonestyle.gtimg.cn/qzone/hybrid/app/404/search_children.js" charset="utf-8" homePageUrl="http://yoursite.com/yourPage.html" homePageName="回到我的主页"></script>
```

直接在 `source` 目录下新建一个 `404.md` （手动新建），加入上面一段就好。

### 其他插件

#### 文章排序

hexo默认的排序是根据发布日期。有时我们会希望将文章置顶或按照update日期排序，可以利用一个插件实现：

```sh
npm uninstall hexo-generator-index --save
npm install hexo-generator-index-plus --save
```

然后将 `_config.yml` 中的 `index-generator` 字段删除，添加如下配置：

```yaml
index_generator_plus:
  path: ''
  per_page: 10
```

无需其他改动，只要在 `font-matter` 中加入 `top: #你的值` 就可以排序。top越大越靠前。

#### spoiler

编程向的Blog难免会有大量代码，这时如果直接放着就很丑。可以利用 `hexo-sliding-spoiler` 实现折叠代码，而且js效果还算不错。

用法如下：

```txt
{% spoiler /*想折叠内容的概述，如 Code*/ %}
//...折叠内容
//...内部仍然支持markdown语法
{% endspoiler %}
```

示例：

{% spoiler code %}
```cpp
#include <iostream>

int main() {
    std::cout << "Hello world!" << std::endl;
    return 0;
}
```
{% endspoiler %}

安装：

```sh
npm install hexo-sliding-spoiler --save
```

bug修复：
spoiler内容默认超过一定长度就会隐藏。打开 `node_modules/hexo-sliding-spoiler/assets/spoiler.css` 编辑 `.spoiler.expanded .spoiler-content` 中的 `overflow` 选项，改为 `auto` ，就会出现滚轮滑动来查看。

#### mathjax

这与主题next相关，因此放到next中去讲。

#### sitemap

sitemap可以用来向百度和谷歌等搜索引擎推荐自己的站点。使用方法也简单：

```sh
npm install hexo-generator-sitemap hexo-generator-baidusitemap --save
```

这样网站的根目录下就有 `sitemap.txt` 、 `sitemap.xml` 和 `baidusitemap.xml` 可供提交。

更多插件在next中讲解。

## next

next是一个~~我觉得~~挺好看并且插件多，社区活跃的主题。

### 安装

安装如下：

```sh
git clone git@github.com:hexo-next/hexo-next-theme.git themes/next
```

这样做的好处是要更新时可以直接

```sh
cd themes/next
git pull
```

但是为了能这样做，我们就需要把next的配置文件迁出来。next也有一个配置文件 `themes/next/_config.yml` ，将里面的内容复制出来，粘贴到站点的 `_config.yml` ，然后将所有复制的文本前面加上两个空格的缩进（选中之后调整缩进长度为2,按下tab键），再在开头顶格输入 `theme_config:` 。接下来所有操作都在 `theme_config:` 中进行，不修改 `themes/next/_config.yml` 。

### 配置

接下来我们看一看next的配置：

PS：以下配置内容如没有就新建。

#### 主题

next默认有4中主题可选。找到 `Schemes` ：

```yaml
# Schemes
scheme: Muse
#scheme: Mist
#scheme: Pisces
#scheme: Gemini
```

默认主题是Muse，可以逐个试一试。

#### 页面

在 `menu` 选项中取消你想要的页面的注释：

```yaml
  menu:
    home: / || fa fa-home
    about: /about/ || fa fa-user
    tags: /tags/ || fa fa-tags
    categories: /categories/ || fa fa-th
    archives: /archives/ || fa fa-archive
    #schedule: /schedule/ || fa fa-calendar
    # sitemap: /sitemap.xml || fa fa-sitemap
    #commonweal: /404.html || fa fa-heartbeat
```

#### 头像

找到 `avatar` 字段：

```yaml
  avatar:
    # Replace the default image and set the url here.
    url: /images/head.jpg
    # If true, the avatar will be dispalyed in circle.
    rounded: true
    # If true, the avatar will be rotated with the cursor.
    rotated: true
```

在 `source` 中新建 `images` 文件夹，里面放入你的图片。 `rounded` 设置圆形， `rotated` 设置鼠标放上去就旋转。

#### 社交账号和友链

找到 `social` 字段：

```yaml
  social:
    #GitHub: https://github.com/yourname || fab fa-github
    #E-Mail: youremail || fa fa-envelope
    #Weibo: https://weibo.com/yourname || fab fa-weibo
    #Google: https://plus.google.com/yourname || fab fa-google
    #Twitter: https://twitter.com/yourname || fab fa-twitter
    #FB Page: https://www.facebook.com/yourname || fab fa-facebook
    #StackOverflow: https://stackoverflow.com/yourname || fab fa-stack-overflow
    #YouTube: https://youtube.com/yourname || fab fa-youtube
    #Instagram: https://instagram.com/yourname || fab fa-instagram
    #Skype: skype:yourname?call|chat || fab fa-skype

  social_icons:
    enable: true
    icons_only: false
    transition: false

  # Blog rolls
  links_settings:
    icon: fa fa-link
    title: Links
    # Available values: block | inline
    layout: block

  links:
```

`social` 中添加你的社交账号，不局限于给出选项，也可以自己添加。

`social_icons` 控制显示时是否有图标。

`links` 设置友链。

#### 打赏

~~说不定有好心人呢？~~找到 `reward` 字段：

```yaml
  reward_settings:
    # If true, reward will be displayed in every article by default.
    enable: true
    animation: false
    comment: "如果阅读本篇文章需要付费，你愿意为此支付1块钱吗？"

  reward:
    wechatpay: /images/weixin.jpg
    #alipay: /images/alipay.png
    #paypal: /images/paypal.png
    #bitcoin: /images/bitcoin.png
```

在 `reward` 中设置你的收款码。方法同头像。

#### 代码块设置

找到字段 `codeblock` ：

```yaml
  codeblock:
    # Code Highlight theme
    # Available values: normal | night | night eighties | night blue | night bright | solarized | solarized dark | galactic
    # See: https://github.com/chriskempson/tomorrow-theme
    highlight_theme: normal
    # Add copy button on codeblock
    copy_button:
      enable: true
      # Show text copy result.
      show_result: true
      # Available values: default | flat | mac
      style:
```

`highlight_theme` 配置风格，可以自行尝试。

`copy_button` 配置复制按钮

#### 一键回到顶部

找到字段 `back2top` ：

```yaml
  back2top:
    enable: true
    # Back to top in sidebar.
    sidebar: true
    # Scroll percent label in b2t button.
    scrollpercent: true
```

#### 阅读进度

找到字段 `reading_progres` ：

```yaml
  reading_progress:
    enable: true
    # Available values: top | bottom
    position: top
    color: "#37c6c0"
    height: 3px
```

`position` 中 `top` 在顶部， `bottom` 浮动在按钮上。

#### 你的Github

找到字段 `github_banner`：

```yaml
  github_banner:
    enable: true
    permalink: https://github.com/yourname
    title: Fork me on GitHub
```

`title` 可修改

#### mathjax

找到字段 `math` ：

next支持mathjax和katex。一般来说katex渲染快，而且next也支持了复制katex源码，但是在mathjax3之后，katex和mathjax速度差不多，而mathjax支持更多样的复制和多种渲染选项，而且支持更多语法，再加之化学方程式的支持，我最终选择了mathjax。

```yaml
  math:
    # Default (true) will load mathjax / katex script on demand.
    # That is it only render those page which has `mathjax: true` in Front-matter.
    # If you set it to false, it will load mathjax / katex srcipt EVERY PAGE.
    per_page: false

    # hexo-renderer-pandoc (or hexo-renderer-kramed) required for full MathJax support.
    mathjax:
      enable: true
      # See: https://mhchem.github.io/MathJax-mhchem/
      mhchem: true

    # hexo-renderer-markdown-it-plus (or hexo-renderer-markdown-it with markdown-it-katex plugin) required for full Katex support.
    katex:
      enable: false
      # See: https://github.com/KaTeX/KaTeX/tree/master/contrib/copy-tex
      copy_tex: false
```

`per_page` 配置是否对每篇文章开启渲染。逻辑比较奇怪， `false` 反而是开启渲染（网上好多文章都说是 `true` ,害得我踩了好几遍坑）。建议开启，不然每篇文章开头都要加上 `font-matter` ： `mathjax: true` 。

想要启用mathjax,还需：

```sh
npm uninstall hexo-renderer-marked --save
npm install hexo-renderer-pandoc hexo-math --save
```

同时安装[pandoc](https://pandoc.org/installing.html)：

```sh
yay -S pandoc
# sudo pacman -S pandoc
# sudo apt install pandoc
# sudo rpm install pandoc
```

#### 评论

使用[utteranc](https://utteranc.es/)。去官网注册一个账号，绑定一个空的github仓库（比如叫comments），然后在配置文件里新建字段如下：

```yaml
  # Demo: https://utteranc.es/  http://trumandu.github.io/about/
  utteranc:
    enable: true
    repo: yourname/comments #Github repo such as :TrumanDu/comments
    pathname: pathname
    # theme: github-light,github-dark,github-dark-orange
    theme: github-light
    cdn: https://utteranc.es/client.js
```

只需改动 `repo` 即可。

#### 访问量统计

找到字段 `busuanzi_count` ：

```yaml
  # Show Views / Visitors of the website / page with busuanzi.
  # Get more information on http://ibruce.info/2015/04/04/busuanzi
  busuanzi_count:
    enable: true
    total_visitors: true
    total_visitors_icon: fa fa-user
    total_views: true
    total_views_icon: fa fa-eye
    post_views: true
    post_views_icon: fa fa-eye
```

全部为 `true` 即可。

#### 站内搜索

找到字段 `localsearch` ：
  
```yaml
  # Local Search
  # Dependencies: https://github.com/theme-next/hexo-generator-searchdb
  local_search:
    enable: true
    # If auto, trigger search by changing input.
    # If manual, trigger search by pressing enter key or search button.
    trigger: auto
    # Show top n results per article, show all results by setting to -1
    top_n_per_article: 1
    # Unescape html strings to the readable one.
    unescape: false
    # Preload the search data when the page loads.
    preload: false
```

同时安装 `hexo-generator-searchdb` ：

```sh
npm install hexo-generator-searchdb --save
```

#### 分享文章

找到字段 `needmoreshare` ：

```yaml
  # NeedMoreShare2
  # Dependencies: https://github.com/theme-next/theme-next-needmoreshare2
  # For more information: https://github.com/revir/need-more-share2
  # iconStyle: default | box
  # boxForm: horizontal | vertical
  # position: top / middle / bottom + Left / Center / Right
  # networks:
  # Weibo | Wechat | Douban | QQZone | Twitter | Facebook | Linkedin | Mailto | Reddit | Delicious | StumbleUpon | Pinterest
  # GooglePlus | Tumblr | GoogleBookmarks | Newsvine | Evernote | Friendfeed | Vkontakte | Odnoklassniki | Mailru
  needmoreshare:
    enable: true
    cdn:
      js: //cdn.jsdelivr.net/gh/theme-next/theme-next-needmoreshare2@1/needsharebutton.min.js
      css: //cdn.jsdelivr.net/gh/theme-next/theme-next-needmoreshare2@1/needsharebutton.min.css
    postbottom:
      enable: true
      options:
        iconStyle: box
        boxForm: horizontal
        position: bottomCenter
        networks: Weibo,Wechat,Douban,QQZone,Twitter,Facebook，
    float:
      enable: false
      options:
        iconStyle: box
        boxForm: horizontal
        position: middleRight
        networks: Weibo,Wechat,Douban,QQZone,Twitter,Facebook
```

同时安装 `hexo-next-share` ：

```sh
npm install hexo-next-share
```

### 效果

就像你现在看到的这样。

## netlify

github站虽好，但是一来访问慢，二来不能被百度爬到。所以我决定迁移到netlify。

这是一个提供免费的（基础服务免费）网页托管，持续部署的网站，CDN也很快，非常适合我们使用。而且netlify还有CMS（后台）系统，可以在线修改你的文章，原来必须要服务器+域名才能完成的事，被我们免费做到，岂不是爽歪歪？

### 建站

netlify提供自动部署服务，如果想要用他的CMS,就不能只把 `public` 文件夹传上去了，我们要把整个Blog文件夹都传上去。

在github上新建一个代码仓库Blog，然后把本地文件夹传上去：

```sh
git init && git add -A && git commit -a -m "init" && git push git@github.com:username/Blog.git
```

随后在[netlify](https://netlify.app/)中选择用github登陆。新建一个站点，选择绑定到github仓库，选择刚刚新建的Blog仓库。在站点的构建命令中填写 `npm install && npm build` ，发布目录填 `public` 。

然后netlify会自动帮你运行部署，相当与我们在本地运行 `hexo g` ，然后通过 `public` 文件夹访问站点。不过这一切都是由netlify的机器来做的。在站点配置中你可以更改自己网站的名字，任意选取吧！

这个东西他有个好处，就是对于小型博客部署时间短。因为netlify会将你部署所需的环境、插件作为缓存存起来，不需要每次都安装，而不像github的CI，每次都要装依赖，甚至pandoc都要重装一遍。所以虽然netlify只有300分钟一个月的构建时间，但是绝对够用。

如果不够用了可以考虑关闭netlify的自动部署，然后在Blog仓库中启用Action，配置构建指令并部署到netlify。这样子就会有2000分钟的构建时间，但每次部署都要多花1分多钟。不过这样还是可以使用CMS的。

既然已经迁移到了netlify，我们可以让原来的github page重定向到netlify，避免流量流失。将github page的仓库的内容全部删除，添加 `index.html` ：

```html
<html>
<head>
    <title>ShwBlog</title>
    <meta http-equiv="refresh" content="1;url= https://shwstone.netlify.app/ ">
</head>
<body>
    <script> alert("本站迁移至https://yoursitename.netlify.app/，请您记住新网址，将为您自动跳转。"); </script>
</body>
</html>
```

### debug

如果你按照上文配置了 `hexo-sliding-spoiler` ，你就会发现长的内容又被隐藏了，这是因为 `node_modules` 作为插件的安装位置，并不会被push到github上，netlify重新安装了插件，采用了默认配置。

解决办法如下：

新建一个文件夹 `prebuild` ，将更改后的文件复制到其中。 `prebuild` 里面添加一个文件 `file` ， `file` 中每一行存储需要更改的文件路径和更改后的文件路径，如下：

```txt
prebuild/spoiler.css node_modules/hexo-sliding-spoiler/assets/spoiler.css
```

然后在网站根目录下新建 `prebuild.sh` 并 `chmod +x prebuild.sh` ，编辑如下：

```sh
#!/bin/sh
while read line
do
    cp $line -f
done < prebuild/file
```

push到github上。

最后在netlify的构建指令中加上一条，改为 `npm install && ./prebuild.sh && npm run build` 。

PS：如果windows无法执行chmod的话，把构建指令改为 `npm install && /bin/sh ./prebuild.sh && npm run build`

如果还有别的文件要更改，复制到 `prebuild` 文件夹并且在 `file` 中添加就行了。

### CMS

接下来我们来看后台的使用。

#### 安装

```sh
npm install netlify-CMS-app --save
```

#### 配置

在根目录新建 `netlify.yaml` ：

```yaml
backend:
  name: git-gateway
  branch: main

media_folder: source/images
public_folder: /images
publish_mode: editorial_workflow

# pages auto generate
pages: 
  enabled: true
  # over page collection config
  # if fields not set, would use posts fields config
  config:
    label: "Page"
    delete: false
    editor:
      preview: true
    # fields: 
# through hexo config over fields
over_format: true
scripts:
  - js/CMS/youtube.js
  - js/CMS/img.js

# A list of collections the CMS should be able to edit
collections:
  # Used in routes, ie.: /admin/collections/:slug/edit
  - name: "posts"
    # Used in the UI, ie.: "New Post"
    label: "Post"
    folder: "source/_posts" # The path to the folder where the documents are stored
    sort: "date:desc"
    create: true # Allow users to create new documents in this collection
    editor:
      preview: true
    fields: # The fields each document in this collection have
      - {label: "Title", name: "title", widget: "string"}
      - {label: "Publish Date", name: "date", widget: "datetime", format: "YYYY-MM-DD HH:mm:ss", dateFormat: "YYYY-MM-DD", timeFormat: "HH:mm:ss", required: false}
      - {label: "Updeted Date", name: "updated", widget: "datetime", format: "YYYY-MM-DD HH:mm:ss", required: false}
      - {label: "Tags", name: "tags", widget: "list", required: false}
      - {label: "Categories", name: "categories", widget: "list", required: false}
      - {label: "Body", name: "body", widget: "markdown", required: false}
      - {label: "Comments", name: "comments", widget: "boolean", default: true, required: false}
      - {label: "Top", name: "top", widget: "number", value_type: "int", default: 2, required: false}
```

注意 `backend` 中的 `branch` 要与你的实际分支相匹配。

然后在netlify中找到site-settings-identity，找到git-gateway，点击启用，选择Blog仓库。

这样你就可以在 `你的网址/admin` 中看到登陆界面了。

自己注册一个admin账户，然后在identity中关闭注册，只允许邀请，保证安全。

ok。尽情享受netlify CMS吧！
