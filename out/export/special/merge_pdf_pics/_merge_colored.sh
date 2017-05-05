#!/bin/bash
#объединение наложенных изображений с оригинальными в многостраничный(многослойный) tif

tmp_file='/tmp/__merge.tif'
mkdir -p "../../img_clean/colored/"

#поиск в пределах +- n (50) страниц для изображений
#python fix_pages.py -n 50 --round-homo="homo,resize" -d ../../img_clean/pic/ images/*.png

#поиск для разбитых по главам изображений
#for i in `seq -w 01 13`;do 
#    python fix_pages.py --all --round-homo="homo,resize" -d ../../img_clean/by_ch/${i}/ images/${i}*.png;
#done

#exit 0

#собираем в многослойные tif для проверки
for f in ../../img_clean/*.tif;do
    echo "${f}"
    bf=`basename "${f}"`
    
    convert "${f}" fix_pages/${bf%%.tif}* "../../1/${bf}" -depth 8 -type TrueColorMatte -compress lzw "${tmp_file}" #со слоем текста
    #convert "${f}" fix_pages/${bf%%.tif}* -depth 8 -type TrueColorMatte -compress lzw "${tmp_file}" #без текста
    mv -vf "${tmp_file}" "../../img_clean/colored/${bf}"
done
