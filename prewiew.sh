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

function preview() {
    cp _config.next.$THEME.yml _config.next.yml
    cp _config.$THEME.yml _config.yml
    
    yarn clean
    yarn server -p 3746
    
    rm _config.next.yml
    rm _config.yml
}

BLOG='/var/shwblog'
prepare

if [ ! -v THEME ]; then
    THEME=gemini
fi
preview