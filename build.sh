# !/bin/bash

yarn

cp copy/spoiler.css node_modules/hexo-sliding-spoiler/assets/spoiler.css
cp copy/zh-CN.yml node_modules/hexo-theme-next/languages/zh-CN.yml

yarn build