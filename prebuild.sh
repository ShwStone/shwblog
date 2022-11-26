#!/bin/bash
#npm install hexo-cli -g
while read line
do
    cp $line -f
done < prebuild/copy_file
