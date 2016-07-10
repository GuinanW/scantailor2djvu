#!/bin/bash
#разборка вывода scantailor на отдельные файлы с текстом (export/1) и картинки (export/2), если он сам не умеет

mkdir -p "export/1" "export/2"

for f in *.tif;do
    convert "${f}" -threshold 1 "export/1/${f}"
    convert "${f}" -mask "export/1/${f}" -fill white -opaque black +mask "export/2/${f}"
done
