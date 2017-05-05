#!/usr/bin/python
# -*- coding: utf8 -*-
#преобразование bookmarks.txt для djvu в формат pdf

import re

bookmarks = open('bookmark.txt').read()

from pyparsing import *
from base64 import b64decode
import pprint

def verifyLen(s,l,t):
    t = t[0]
    if t.len is not None:
        t1len = len(t[1])
        if t1len != t.len:
            raise ParseFatalException(s,l,\
                    "invalid data of length %d, expected %s" % (t1len, t.len))
    return t[1]

# define punctuation literals
LPAR, RPAR, LBRK, RBRK, LBRC, RBRC, VBAR = map(Suppress, "()[]{}|")

decimal = Regex(r'0|[1-9]\d*').setParseAction(lambda t: int(t[0]))
hexadecimal = ("#" + OneOrMore(Word(hexnums)) + "#")\
                .setParseAction(lambda t: int("".join(t[1:-1]),16))
bytes = Word(printables)
raw = Group(decimal("len") + Suppress(":") + bytes).setParseAction(verifyLen)
token = Word(alphanums + "-./_:*+=")
base64_ = Group(Optional(decimal|hexadecimal,default=None)("len") + VBAR 
    + OneOrMore(Word( alphanums +"+/=" )).setParseAction(lambda t: b64decode("".join(t)))
    + VBAR).setParseAction(verifyLen)
    
qString = Group(Optional(decimal,default=None)("len") + 
                        dblQuotedString.setParseAction(removeQuotes)).setParseAction(verifyLen)
simpleString = base64_ | raw | decimal | token | hexadecimal | qString

# extended definitions
decimal = Regex(r'-?0|[1-9]\d*').setParseAction(lambda t: int(t[0]))
real = Regex(r"[+-]?\d+\.\d*([eE][+-]?\d+)?").setParseAction(lambda tokens: float(tokens[0]))
token = Word(alphanums + "-./_:*+=!<>")

simpleString = real | base64_ | raw | decimal | token | hexadecimal | qString

display = LBRK + simpleString + RBRK
string_ = Optional(display) + simpleString

sexp = Forward()
sexpList = Group(LPAR + ZeroOrMore(sexp) + RPAR)
sexp << ( string_ | sexpList )

def print_pdf_bookmark(bookmark, level=0):
    if type(bookmark[1]) == type(''):
        print """
BookmarkBegin
BookmarkTitle: %s
BookmarkLevel: %i
BookmarkPageNumber: %i
""" % (bookmark[0], level, int(bookmark[1].replace('#','')))

    if len(bookmark) > 2:
        for b in bookmark[1:]:
            if type(b) == type([]):
                print_pdf_bookmark(b, level+1)
    #pprint.pprint(bookmark)

def main():
    sexpr = sexp.parseString(bookmarks, parseAll=True)
    print_pdf_bookmark(sexpr.asList()[0])

if __name__ == "__main__":
    main()
