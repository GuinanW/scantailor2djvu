#!/bin/bash
#отделяем чб файлы

mkdir text

for f in ../../img_clean/*.tif;do
    echo -n "${f} "
    num_color=`identify -format '%k' "${f}"`
    echo $num_color
    [ $num_color -eq 2 ] && mv -vf "${f}" text/
done
