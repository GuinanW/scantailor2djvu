#!/bin/bash
# перемещаем файлы с нормальной графикой, а не номером страницы

mkdir imgs
#значение хеша для пустой страницы
null_hash="9ff52caefd9026181cba529c7e9be0a9"

for f in *.tif;do
    echo "${f}"
    #hash=`convert "${f}" -crop 3660x5047+0+300 - | identify -format '%#' -` #обрезаем часть страницы с номером или ещё чем
    #hash=`convert "${f}" - | identify -format '%#' -`
    hash=`md5sum "${f}" | cut -f1 -d ' '`
    [ "$hash" == "$null_hash" ] && continue
    #tmp_ppm=`mktemp --suffix '.ppm'`

    mv -v "${f}" imgs/
done
