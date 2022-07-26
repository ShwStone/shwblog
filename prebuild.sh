#!/bin/sh
while read line
do
    cp $line -f
done < prebuild/file
