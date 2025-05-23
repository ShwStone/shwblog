#!/bin/bash

function prepare() {
    cd $BLOG
    yarn

    cp copy/spoiler.css             node_modules/hexo-sliding-spoiler/assets/spoiler.css
    cp copy/zh-CN.yml               node_modules/hexo-theme-next/languages/zh-CN.yml
    cp copy/darkmode.njk            node_modules/hexo-next-darkmode/darkmode.njk
    cp copy/darkmode.css            node_modules/hexo-next-darkmode/lib/darkmode.css
    cp copy/index.styl              node_modules/hexo-theme-next/source/css/_common/outline/footer/index.styl
    cp copy/busuanzi-counter.njk    node_modules/hexo-theme-next/layout/_third-party/statistics/busuanzi-counter.njk
}

function build() {
    echo "building" > $BLOG_STATIC/$THEME-status.txt

    cp _config.next.$THEME.yml _config.next.yml
    cp _config.$THEME.yml _config.yml
    
    yarn clean
    yarn build

    if [ -d "$BLOG/public" ]; then
        rm -rf $BLOG_PUBLIC
        cp $BLOG/public $BLOG_PUBLIC -r
    fi
    
    rm _config.next.yml
    rm _config.yml

    echo "success" > $BLOG_STATIC/$THEME-status.txt
}

BLOG='/var/shwblog'
BLOG_STATIC='/var/blog/static'
prepare

BLOG_PUBLIC='/var/blog/public'
THEME=gemini
build

BLOG_PUBLIC='/var/blog/mist'
THEME=mist
build