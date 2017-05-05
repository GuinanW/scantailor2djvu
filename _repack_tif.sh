#!/bin/bash
#перепаковываем tif в lzw

for f in *.tif;do
    tiff_comp=`identify -format '%C' "${f}"`
    [ "${tiff_comp}" == 'LZW' ] && continue
    tiffcp "${f}" -c lzw "/tmp/${f}" && mv -v "/tmp/${f}" "${f}"
done
