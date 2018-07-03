#!/bin/bash
#создание черновика djvu - все страницы как картинки

mkdir djvu
scale='-scale 50%' #ресайзим чтоб уменьшить размер - нужно читерить чтоб размер был не меньше исходного :/
#scale='100%'


for f in *.tif;do
    djvu_file="djvu/${f//.tif/.djvu}"
    [ -f "${djvu_file}" ] && continue
    echo "${f}"
    tmp_ppm=`mktemp --suffix '.ppm'`

    convert "${f}" ${scale} -level 20%,80% -gaussian-blur 7 "${tmp_ppm}"
    c44 -dpi 300 "${tmp_ppm}" "${djvu_file}"
    rm -vf "${tmp_ppm}"
done

djvm -c _all.djvu djvu/*.djvu
