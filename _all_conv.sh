#!/bin/bash

#скрипт не рекомендуется к применению
#лучше использовать части отдельно, т.к. встречаются вручную выполняемые этапы
exit 1

#Проверяем скриптом z_test.sh, что все страницы отсканированы
#Обрабатываем в ScanTailor

#Произвести экспорт из ScanTailor в виде раздельных сканов (ветка [featured] (https://github.com/scantailor/scantailor/tree/featured)) либо пройти скриптом out/_split.sh
pushd "out"
./_split.sh
popd

#Собрать ч/б сканы скриптом out/export/1/_2djvu.sh
pushd "out/export/1"
./_2djvu.sh &
popd

#Отобрать файлы с картинками, где есть изображения - скрипт out/export/2/mv_pics_img.sh
pushd "out/export/2"
./mv_pics_img.sh
#Перекинуть картинки из out/export/2/img в out/export/img_clean и почистить gimp или прочим
mv imgs/*.tif ../img_clean/
popd

pushd "out/export/img_clean/"
gimp -i -b "(scan-pics-gauss \"*.tif\")" -b "(gimp-quit 0)"
popd

#Сделать png c метками на книге out/export/mark/*.tif.png
#Преобразовать картинки out/export/img_clean в djvu скриптом out/export/img_clean/img_to_djvu.sh
pushd "out/export/img_clean"
./img_to_djvu.sh &
popd
wait

# Собрать png картинки для FineReader, распознать в нём и сохранить в виде fr/fr.djvu (при сохранении в djvu удобно первую обложку ставить последней страницей) и fr/fr.pdf, 
#	сохранить страницы с содержанием в текстовый файл
pushd "out/export/1"
./merge_img.sh
popd
#Достать текст из djvu скриптом fr/get_txt_from_fr_djvu.sh

#Собрать книжку скриптом out/export/1/djvu/split/djvu_merge.sh
pushd "out/export/1/djvu/split"
./djvu_merge.sh
popd

#Прописать метаданные (djvu/metadata.txt) и содержание (djvu/bookmark.txt) и для pdf - pdf_meta.txt
#Собрать окончательные версии скриптами djvu/merge_djvu.sh и djvu/merge_pdf.sh
pushd "djvu"
./merge_djvu.sh
popd
