Скрипты для преобразования результатов ScanTailor в djvu.

Зависимости: minidjvu, djvulibre, imagemagick

Порядок обработки:
  1. Сделать в ScanTailor все что надо
  1. Произвести экспорт из ScanTailor в виде раздельных сканов (ветка [featured] (https://github.com/scantailor/scantailor/tree/featured)) либо пройти скриптом out/_split.sh
  1. Отобрать файлы с картинками, где есть изображения - скрипт out/export/2/mv_pics_img.sh
  1. Перекинуть картинки из out/export/2/img в out/export/img_clean и почистить gimp или прочим
  1. Сделать png c метками на книге out/export/mark/*.tif.png
  1. Преобразовать картинки out/export/img_clean в djvu скриптом out/export/img_clean/img_to_djvu.sh
  1. Собрать ч/б сканы скриптом out/export/1/_2djvu.sh
  1. Собрать png картинки для FineReader, распознать в нём и сохранить в виде fr/fr.djvu (при сохранении в djvu удобно первую обложку ставить последней страницей) и fr/fr.pdf, 
	сохранить страницы с содержанием в текстовый файл
  1. Достать текст из djvu скриптом fr/get_txt_from_fr_djvu.sh
  1. Собрать книжку скриптом out/export/1/djvu/split/djvu_merge.sh
  1. Прописать метаданные (djvu/metadata.txt) и содержание (djvu/bookmark.txt) и для pdf - pdf_meta.txt
  1. Собрать окончательные версии скриптами djvu/merge_djvu.sh и djvu/merge_pdf.sh

В out/export/special есть набор специфичных скриптов
