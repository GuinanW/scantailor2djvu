#!/bin/bash
#вытаскивание txt слоя из djvu от FR

#djvu от FR
in_djvu="fr.djvu"

mkdir txtz txt
pages=`djvused "${in_djvu}" -e 'n'`

for pn in `seq -w 1 ${pages}`;do
    djvuextract "${in_djvu}" -page=${pn} TXTz="txtz/${pn}.txtz"
    djvused "${in_djvu}" -u -e "select ${pn};print-txt" > "txt/${pn}.txt"
done
