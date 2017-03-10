#!/bin/bash
#сборка конечного djvu

out_file="book.djvu"
#out_file="/dev/shm/book.djvu"
diff_page=1 #разница нумераций

cp -vf out.djvu "${out_file}"
tmp_file=`mktemp`

#ссылки в тексте и дополнительные элементы, можно сделать в djvusmooth
for i in `seq -w 0001 2000`;do
    txt_ant="txt/${i}.ant" #ссылки и прочее
    page_num=`expr ${i} + ${diff_page}`
    [ -f "${txt_ant}" ]  && echo "select ${page_num}; set-ant ${txt_ant}" >> "${tmp_file}"
    txt_text="txt/${i}.txt" #текст
    [ -f "${txt_text}" ]  && echo "select ${page_num}; set-txt ${txt_text}" >> "${tmp_file}"
done 

echo "set-outline bookmark.txt" >> "${tmp_file}"
echo "create-shared-ant; set-ant metadata.txt" >> "${tmp_file}"
echo "select 17; set-ant metadata_mark.txt" >> "${tmp_file}"
echo "set-thumbnails 64" >> "${tmp_file}"

#cat "${tmp_file}"
cat "${tmp_file}" | djvused -s "${out_file}"

rm "${tmp_file}"
