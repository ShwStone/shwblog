---
title: 编译指令-Linux
date: 2022-07-13 16:25:07
tags:
categories:
- 信奥
---
注意 `~/.run` 文件夹可能需要手动新建。  
`mkdir ~/.run`

<!-- more -->

```sh
#!/bin/sh
name=""
for i in "$@"
do
        name="$name$i"
done
name=${name////_}
name=${name// /_}
if [ ! -e ~/.run/md5_$name ] 
then
        touch ~/.run/md5_$name
fi
md5sum $@ > ~/.run/new_md5_$name
diff ~/.run/new_md5_$name ~/.run/md5_$name > ~/.run/diff_tmp
if [ $? == 0 ]
then
        echo "Run your code here:"
        rm ~/.run/new_md5_$name
        ~/.run/run_$name
else
        cp ~/.run/new_md5_$name ~/.run/md5_$name
        rm ~/.run/new_md5_$name
        g++ -O2 -lm -Wall -std=c++17 -fsanitize=address,undefined -o ~/.run/run_$name $@
        if [ $? == 0 ]
        then
                echo "Compiled successfully!"
                echo "Run your code here:"
                ~/.run/run_$name
        else
                echo "Compiled error!"
        fi
fi
```
