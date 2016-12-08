Окончательная сборка djvu и pdf

== Обработка djvu ==

1. Заполняем metadata.txt в соответствии с реквизитами книги
1. Копируем распознанное содержание из FineReader в виде текста в content.txt
1. Преобразуем в djvu-подобный вид `sed -r 's#^(.*?)\t+([0-9]+)\s*$#("\1" "\#\2")#' content.txt > bookmark.txt` и корректируем вложенность, не забывая про корневой (bookmarks)
1. `./fix_bookmark.py bookmark.txt` - исправляет номера страниц вида "#13", для порядкового номера относительно djvu (где они обычно сдвинуты на +1, из-за первой обложки),
    созданные bookmark.txt.new проверить и переименовать в bookmark.txt
1. собираем `./merge_djvu.sh`

== Обработка pdf ==

1. Извлекаем метаинформацию о pdf
    `pdftk pdf_fr.pdf dump_data_utf8 output pdf_meta.txt`

1. Корректируем bookmak.txt для вида пригодного для pdf:
    `sed -r 's/^\s*\("(.*?)" "#([0-9]+)"\)?/BookmarkBegin\nBookmarkTitle: \1\nBookmarkLevel: 2\nBookmarkPageNumber: \2\n/;s#\(bookmarks##;s#^\s*\)##' bookmark.txt >> pdf_meta.txt`

1. Собираем обратно
    `pdftk pdf_fr.pdf update_info_utf8 pdf_meta.txt output book.pdf`
