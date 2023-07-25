# !/bin/bash

yarn global add hexo-cli
yarn

cp copy/spoiler.css node_modules/hexo-sliding-spoiler/assets/spoiler.css -f
cp copy/renderer.js node_modules/hexo-renderer-kramed/lib/renderer.js -f
cp copy/inline.js node_modules/kramed/lib/rules/inline.js -f

yarn build