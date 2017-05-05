#!/bin/bash
#подчищаем картинки из pdf/jpeg и соразмерно увеличиваем, чтобы проще вклеивать было
# ./get_pdf_img.sh <pdf файл>

scale_factor=2 #увеличиваем в n раз
img_dir="images" #куда складывать

#convert -shave 3x3 - обрезание по 3 пикселя с краёв

mkdir pages images

#Простое извлечение картинок из pdf (только растровые вклейки)
#pdfimages -p *.pdf "${img_dir}/"


#извлечение внедрённых картинок из нескольких pdf, в том числе векторных рисунков
#for i in `seq -w 01 16`;do
#    pdftk figures${i}.pdf  burst output "images/${i}_%02d.pdf"
#done

#exit 0

pushd "${img_dir}"

#преобразование одностраничных pdf, в том числе с векторной графикой
for f in *.pdf;do
    echo "${f}"
    [ -f "${f}" ] && convert -density 600 "${f}" -trim +repage "${f}.png"
done

#подчистка картинок
for f in *.ppm;do
    echo "${f}"
    scale=`identify -format "-distort Resize %[fx:ceil(w*${scale_factor})]x%[fx:ceil(h*${scale_factor})]" "${f}"`
    [ -f "${f}" ] && convert ${f} -despeckle -background "#ffffff" -filter Lanczos ${scale} -level '2%,98%,1.0' "${f}.png"
done
popd
