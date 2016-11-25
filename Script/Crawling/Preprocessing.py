# -*- coding: utf-8 -*-
"""
Created on Fri Nov 25 19:50:07 2016

@author: Changdong Oh
"""

                
def read_data(filename): 
    with open(filename, 'r', encoding='UTF8') as f: 
        data = [line.split(',') for line in f.read().splitlines()] 
    
    return data

import re
from konlpy.tag import Twitter 
pos_tagger = Twitter()
def tokenize(doc): 
    return ['/'.join(t) for t in pos_tagger.pos(doc, norm=True, stem=True)]


def unique_list(l):
    x = []
    for a in l:
        if a not in x:
            x.append(a)
    return x

for year in range(2008, 2017):
    import csv
    data=unique_list([i[1:] for i in read_data('MoralFoundations\\Data\\민주{0}.csv'.format(str(year)))])
    with open('MoralFoundations\\PData\\민주{0}.csv'.format(str(year)),'w', encoding='UTF8', newline='') as f:
        w=csv.writer(f)
        for line in data:
            if len(line[1])>200:
                newline=[line[0],' '.join(tokenize(re.sub('통합민주당|통민당|통합 민주당|열린우리당|대통합민주신당 \
                |통합신당|민주통합당|민통당|열린우리당'," 민주당 ", re.sub('한나라당', '새누리당', \
                re.sub("[가-힣]{2,4} 대변인|([가-힣]\s{1,3}){3}대변인","",line[1])))))]
                w.writerow(newline)
            else: continue
            
        