#!/bin/bash
#разборка вывода scantailor на отдельные файлы с текстом (export/1) и картинки (export/2), если он сам не умеет

mkdir -p "export/1" "export/2"

i=1 #счётчик номера страницы

for f in *.tif;do
    #of="${f}" #с оригинальными именами
    of=`printf "%04d.tif" ${i}` #перенумеровываем файлы по порядку в вид "0000.tif"
    convert "${f}" -threshold 1 -monochrome -compress lzw "export/1/${of}"
    convert "${f}" -mask "export/1/${of}" -fill white -opaque black +mask -compress lzw "export/2/${of}"
    i=`expr ${i} + 1`
done
