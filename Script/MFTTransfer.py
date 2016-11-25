# -*- coding: utf-8 -*-
"""
Created on Fri Nov 25 23:26:39 2016

@author: Changdong Oh
"""

import re
from konlpy.tag import Twitter 
pos_tagger = Twitter()
def tokenize(doc): 
    return ['/'.join(t) for t in pos_tagger.pos(doc, norm=True, stem=True)]

def read_mfd(filename): 
        with open(filename, 'r') as f:
            data = [line for line in f.read().splitlines()] 
    
        return data
        
def unique_list(l):
    x = []
    for a in l:
        if a not in x:
            x.append(a)
    return x        
        
MFDictionary=['HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice']
for i in MFDictionary:
    exec("%s=%s" % (i,unique_list([tokenize(re.sub('[A-Za-z]','', re.sub('"','',j))) for j in read_mfd('MoralFoundations\PData\Moral_Foundations_Dictionary\{0}.csv'.format(i))[1:]] )))


