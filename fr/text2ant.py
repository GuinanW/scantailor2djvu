#!/usr/bin/python
# -*- coding: utf-8 -*-

#попытки извлечь из текстового слоя ссылки на страницы

import re
import os
import sys
import optparse

#регулярка для текстовых записей
re_hidden_text=re.compile('\((?P<type>.*?) (?P<xmin>[0-9]+) (?P<ymin>[0-9]+) (?P<xmax>[0-9]+) (?P<ymax>[0-9]+) "(?P<text>.*?)"\)')
def parse_word(st):
    ret = re_hidden_text.search(st)
    if not ret: return None

    out = ret.groupdict()
    for k in ('xmin', 'xmax', 'ymin', 'ymax'):
        out[k] = int(out[k])
    out['width'] = out['xmax'] - out['xmin']
    out['height'] = out['ymax'] - out['ymin']
    out['text'] = out['text'].replace('\\n', '')
    return out

def gen_maparea(text):
    #форматирование ссылки
    return '(maparea "#%(pagenum)i" "%(text)s" (rect %(xmin)i %(ymin)i %(width)i %(height)i) (xor ) (hilite #DDDDDD))' % text

def generate_ant(fn, out_fn, diff_page=0):
    re_test_pagenum = re.compile('^\s*(?P<pagenum>[0-9]+)[, ]*$') #если текст подходит, то считаем его номером страницы
    
    infile = open(fn, 'rt')
    outfile = open(out_fn, 'wt')
    while 1:
        data = infile.readline()
        if not data: break
        
        test_text = parse_word(data)
        if not test_text: continue
        
        #print test_text
        ret = re_test_pagenum.match(test_text['text'])
        print repr(test_text['text'])
        if ret:
            test_text['pagenum'] = int(ret.groupdict()['pagenum']) + diff_page
            outfile.write(gen_maparea(test_text)+'\n')

    outfile.close()
    infile.close()

if __name__ == '__main__':
    parser = optparse.OptionParser("usage: %prog <файлы txt>")

    parser.add_option("-n", dest="diff_page", 
                      default=1, help=u'сколько страниц прибавлять для djvu')

    (options, args) = parser.parse_args()


    for f in args:
        generate_ant(f, f.replace('.txt', '.ant'), diff_page=options.diff_page)
