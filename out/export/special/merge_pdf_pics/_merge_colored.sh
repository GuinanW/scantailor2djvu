#!/bin/bash
#объединение наложенных изображений с оригинальными в многостраничный(многослойный) tif

tmp_file='/tmp/__merge.tif'
mkdir -p "../../img_clean/colored/"

for f in ../../img_clean/gray/*.tif;do
#for f in ../../img_clean/*.tif;do
    echo "${f}"
    bf=`basename "${f}"`
    
    convert "${f}" fix_pages/${bf}* "../../1/${bf}" -depth 8 -type TrueColorMatte "${tmp_file}" #со слоем текста
    #convert "${f}" fix_pages/${bf}* -depth 8 -type TrueColorMatte "${tmp_file}" #без текста
    mv -vf "${tmp_file}" "../../img_clean/colored/${bf}"
done
