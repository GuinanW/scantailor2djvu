#!/bin/bash
#конвертируем почищенные картинки в djvu

#во сколько раз уменьшить картинку, чтоб размер был меньше
scale_factor=3
#соразмерно уменьшаем dpi
out_dpi=`expr 600 / ${scale_factor}`

mkdir djvu

#подтягиваем пустые страницы для меток
for f in ../mark/*.png;do
    bf=`basename "${f%%.png}"`
    [ -f "../2/${bf}" -a ! -f "${bf}" ] && cp -vf "../2/${bf}" ${bf}
done

for f in *.tif;do
    echo "${f}"
    tmp_ppm=`mktemp --suffix '.ppm'`

    cmd=""
    scale=`identify -format "-geometry %[fx:ceil(w/${scale_factor})]x%[fx:ceil(h/${scale_factor})]! " "${f}"`
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
