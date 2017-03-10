#!/bin/bash
#вытаскивание txt слоя из djvu от FR

#djvu от FR
in_djvu="fr.djvu"

mkdir txtz txt
pages=`djvused "${in_djvu}" -e 'n'`

diff_num=1 #разница между номером страницы в FR и необходимым

for out_num in `seq -w 0000 ${pages}`;do #выходные номера
    pn=`expr ${out_num} + ${diff_num}` #номер страницы в документе fr
    djvuextract "${in_djvu}" -page=${pn} TXTz="txtz/${out_num}.txtz"
    djvused "${in_djvu}" -u -e "select ${pn};print-txt" > "txt/${out_num}.txt"
done
