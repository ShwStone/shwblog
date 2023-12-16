#!/bin/bash

#export BLOG='/root/shwblog'
#
#cd $BLOG
#
## report building
#echo "building" > /var/blog/status.txt

yarn

cp copy/spoiler.css node_modules/hexo-sliding-spoiler/assets/spoiler.css
cp copy/zh-CN.yml node_modules/hexo-theme-next/languages/zh-CN.yml

# yarn clean
yarn build

#rm -rf /var/blog
#cp $BLOG/public /var/blog -r
#
## report success
#
#echo "success" > /var/blog/status.txt
#unset BLOG
