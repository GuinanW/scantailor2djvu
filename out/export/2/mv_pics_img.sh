#!/bin/bash
# перемещаем файлы с нормальной графикой, а не номером страницы

#если пустой, то медленно отделяем страницы всего с одним цветом
null_hash=""

#значение хеша для пустой страницы
#null_hash="49912f8d859fddff6ce8aafe94de3b07"

mkdir imgs
for f in *.tif;do
    echo "${f}"
    #hash=`convert "${f}" -crop 3660x5047+0+300 - | identify -format '%#' -` #обрезаем часть страницы с номером или ещё чем
    #hash=`convert "${f}" - | identify -format '%#' -`
    if [ -z "${null_hash}" ];then
        #если цвет только один, то считаем что страница пустая
        num_color=`identify -format '%k' "${f}"`
        [ $num_color -eq 1 ] && continue
    else
        hash=`md5sum "${f}" | cut -f1 -d ' '`
        [ "$hash" == "$null_hash" ] && continue
    fi
    #если пустые файлы имеют разные хеши
    #[ "$hash" == "49912f8d859fddff6ce8aafe94de3b07" ] && continue

    mv -v "${f}" imgs/
done
