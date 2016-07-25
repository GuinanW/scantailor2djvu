#!/bin/bash

#объединение черно-белых картинок с текстом

out_dir="tif/"
mkdir -p "${out_dir}"

for f in *.tif;do
    cmd=""
    #картинки
    [ -f "${f}" ] && cmd="${cmd} -page +0+0 ${f} " #pic_file

    #текст
    [ -f "../../1/${f}" ] && cmd="${cmd} -page +0+0 ( ../1/${f} -transparent #ffffff )"

    echo "${cmd}"
    convert ${cmd} -background "#ffffff" -layers merge +repage -monochrome -compress lzw "${out_dir}/${f}"
done
