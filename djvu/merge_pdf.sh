pdftk pdf_fr.pdf dump_data_utf8 output pdf_meta.txt
sed -r 's/^\s*\("(.*?)" "#([0-9]+)"\)?/BookmarkBegin\nBookmarkTitle: \1\nBookmarkLevel: 2\nBookmarkPageNumber: \2\n/;s#\(bookmarks##;s#^\s*\)##' bookmark.txt >> pdf_meta.txt
#доработать напильником

#собираем обратно
pdftk pdf_fr.pdf update_info_utf8 pdf_meta.txt output book.pdf
