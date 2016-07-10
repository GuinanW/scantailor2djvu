#!/bin/bash

#конвертируем почищенные картинки в djvu

#уменьшаем картинку, чтоб размер был меньше
#важно чтоб размер картинки с учётом dpi был больше картинки с текстом
scale="-geometry 50%x"
out_dpi=300

mkdir djvu
for f in *.tif;do
    echo "${f}"
    tmp_ppm=`mktemp --suffix '.ppm'`

    cmd=""
    #подложка с номером
    #[ -f "../2.pics/${f}" ] && cmd="${cmd} -page +0+0 ../2.pics/${f} " #pic_file

    #картинки
    [ -f "${f}" ] && cmd="${cmd} -page +0+0 ${f} " #pic_file

    #подложка заголовков таблиц
    #[ -f "../tbl/${f}.png" ] && cmd="${cmd} -page +0+0 ../tbl/${f}.png " #tbl_file

    #метки
    [ -f "../mark/${f}.png" ] && cmd="${cmd} -page +0+0 ../mark/${f}.png " #mark_file

    #текст
    #[ -f "${f}" ] && cmd="${cmd} -page +0+0 ( ${f} -transparent #ffffff )"

    echo "${cmd}"
    convert ${cmd} -background "#ffffff" -layers merge +repage ${scale} "${tmp_ppm}"

    c44 -dpi ${out_dpi} -slice 72+11+10+10 "${tmp_ppm}" "djvu/${f//.tif/.djvu}"
    rm -f "${tmp_ppm}"
done
