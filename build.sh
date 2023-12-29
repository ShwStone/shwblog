#!/bin/bash

BLOG='/var/shwblog'
BLOG_PUBLIC='/var/blog-public'

cd $BLOG

# report building
echo "building" > $BLOG_PUBLIC/status.txt

yarn

cp copy/spoiler.css node_modules/hexo-sliding-spoiler/assets/spoiler.css
cp copy/zh-CN.yml node_modules/hexo-theme-next/languages/zh-CN.yml
cp copy/darkmode.njk node_modules/hexo-next-darkmode/darkmode.njk
cp copy/darkmode.css node_modules/hexo-next-darkmode/lib/darkmode.css
cp copy/index.styl node_modules/hexo-theme-next/source/css/_common/outline/footer/index.styl

# yarn clean
yarn build

mv $BLOG_PUBLIC/images/welcome.svg $BLOG
rm -rf $BLOG_PUBLIC
cp $BLOG/public $BLOG_PUBLIC -r
mv $BLOG/welcome.svg $BLOG_PUBLIC/images

# report success

echo "success" > $BLOG_PUBLIC/status.txt
