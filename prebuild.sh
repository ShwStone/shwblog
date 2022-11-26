#!/bin/bash
while read line
do
    cp $line -f
done < prebuild/copy_file
