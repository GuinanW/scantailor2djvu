#!/bin/sh

#сборка чистых картинок (png) для FineReader или pdf
#с пробелами не работает :(

#out_dir="/dev/shm/merge/"
out_dir="../merge/"
mkdir -p "${out_dir}"

for text_file in *.tif;do
    cmd=""
    #подложка с номером
    [ -f "../2.pics/${text_file}" ] && cmd="${cmd} -page +0+0 ../2.pics/${text_file} " #pic_file

    #картинки
    [ -f "../img_clean/${text_file}" ] && cmd="${cmd} -page +0+0 ../img_clean/${text_file} " #pic_file

    #подложка заголовков таблиц
    [ -f "../tbl/${text_file}.png" ] && cmd="${cmd} -page +0+0 ../tbl/${text_file}.png " #tbl_file

    #метки
    [ -f "../mark/${text_file}.png" ] && cmd="${cmd} -page +0+0 ../mark/${text_file}.png " #mark_file

    #текст
    [ -f "${text_file}" ] && cmd="${cmd} -page +0+0 ( ${text_file} -transparent #ffffff ) "

    echo "${cmd}"
    convert ${cmd} -background "#ffffff" -layers merge +repage "${out_dir}/${text_file}.png"
done

#convert \( "${pic_file}" "${tbl_file}" -composite "${mark_file}" -composite \) \
#        \( "${text_file}" -transparent "#ffffff" \) -composite \
#        /dev/shm/tmp.png
