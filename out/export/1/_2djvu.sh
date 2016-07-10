#!/bin/sh
#сборка чб страниц

#перемещаем последнюю страницу (первая обложка)
#mv -vf 0306.tif 0000.tif

mkdir -p djvu/split
minidjvu -c -A -m -p 25 -s -r -d 600 *.tif djvu/_black_tmp.djvu
djvmcvt -i djvu/_black_tmp.djvu djvu/split/ _ind.djvu
