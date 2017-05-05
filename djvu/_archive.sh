#!/bin/bash
#упаковываем результаты

#придумываем пароль
if [ \! -f pass ]; then
    echo -n 'book_password' > pass
    if [ -x /usr/bin/pwqgen ]; then
        pwqgen | tr -d '\n' > pass
    fi
fi

pass=`cat pass`
name="book_archive" #название выходных книг
volume_size="-v1600m" #разбивка на тома

pushd ..

out_dir="archives"
mkdir "${out_dir}"

#сырые сканы
7z a -mhe=on -p"${pass}" ${volume_size} "${out_dir}/${name}_raw.7z" *.tif #*.ScanTailor
par2 c "${out_dir}/${name}_raw.par2" "${out_dir}/${name}_raw.7z".* #избыточность для восстановления

#вручную обработанные
#7z a -mhe=on -p"${pass}" ${volume_size} "${out_dir}/${name}_manual.7z" *.ScanTailor out/export/{img_clean,img_black,cover,img_clean/gray}/*.{tif,xcf} out/export/mark/*.png djvu/ fr/ on_black/
7z a -mhe=on -p"${pass}" ${volume_size} "${out_dir}/${name}_manual.7z" *.ScanTailor out/export/ djvu/ fr/

pushd "${out_dir}"
md5sum *.* > md5sums
popd

popd

#результат
pushd "../_out/"
echo
rar a -hp"${pass}" -r "../${out_dir}/${name}.rar" .
popd
