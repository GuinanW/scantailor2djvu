#!/bin/bash
#подчищаем картинки из pdf/jpeg и соразмерно увеличиваем, чтобы проще вклеивать было
# ./get_pdf_img.sh <pdf файл>

scale_factor=2
img_dir="images"


mkdir pages
mkdir "${img_dir}"
pdfimages -p *.pdf "${img_dir}/"

pushd "${img_dir}"
for f in *.ppm;do
    echo "${f}"
    #tmp_ppm=`mktemp --suffix '.ppm'`

    scale=`identify -format "-distort Resize %[fx:ceil(w*${scale_factor})]x%[fx:ceil(h*${scale_factor})]" "${f}"`
    #картинки
    [ -f "${f}" ] && convert ${f} -despeckle -background "#ffffff" -filter Lanczos ${scale} -level '2%,98%,1.0' "${f}.png"
done
popd
