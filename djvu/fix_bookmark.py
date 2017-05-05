#!/usr/bin/python
# -*- coding: utf8 -*-
#правим номера страниц в bookmarks

import re
import sys
import optparse

def replace_num_pages(fn, diff_page=1):
    infile = open(fn, 'rt')
    outfile = open(fn+'.new', 'wt')
    
    while 1:
        st = infile.readline()
        if not st: break
        req = re.search('#([0-9]+)', st)
        if req:
            new_page_num = req.group().replace(req.groups()[0], str(int(req.groups()[0])+diff_page))
            st = st.replace(req.group(), new_page_num)
        outfile.write(st)

if __name__ == '__main__':
    parser = optparse.OptionParser("usage: %prog <bookmark.txt>")

    parser.add_option("-n", dest="diff_page", type=int,
                      default=1, help=u'сколько страниц прибавлять для djvu')

    (options, files) = parser.parse_args()

    for f in files:
        replace_num_pages(f, diff_page=options.diff_page)
