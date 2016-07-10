#!/bin/bash
# сборка djvu из картинок и текстовых слоёв и их раскраски

mkdir ../out

for f in *.djvu;do
    tmpdir=`mktemp -d`
    cmd=""
    bn="${f//.djvu/.tif.bbox}"
    txt_file="../txtz/${f//.djvu/.txtz}"
    pic_file="../pic/${f}"
#    [ -f "${bn}" ] && continue

    echo "${bn}"
    djvuextract "${f}" INCL="${tmpdir}/tmp.incl" Sjbz="${tmpdir}/tmp.sjbz"
    cmd="${cmd} INFO=,,600 INCL=`cat ${tmpdir}/tmp.incl` Sjbz=${tmpdir}/tmp.sjbz"
    if [ -f "${pic_file}" ];then
        djvuextract "${pic_file}" BG44="${tmpdir}/tmp.bg44"
        cmd="${cmd} BG44=${tmpdir}/tmp.bg44"
    fi
    [ -f "${bn}" ] && cmd="${cmd} FGbz=`tr -d '\n' < "${bn}"`"
    [ -f "${txt_file}" ] && cmd="${cmd} TXTz=${txt_file}"
    echo $cmd
    djvumake "../out/${f}" $cmd
    rm -rf "${tmpdir}"
done

cp -vf *.iff _ind.djvu ../out/
djvmcvt -b ../out/_ind.djvu ../out.djvu
