# -*- coding: utf-8 -*-
"""
Created on Sat Dec 10 10:31:23 2016

@author: Changdong Oh
"""


def unique_list(l):
    x = []
    for a in l:
        if a not in x:
            x.append(a)
    return x   
    
from gensim.models.doc2vec import TaggedDocument

import re
from konlpy.tag import Twitter 
pos_tagger = Twitter()
def tokenize(doc): 
    return ['/'.join(t) for t in pos_tagger.pos(doc, norm=True, stem=True)]


def Tagged(year, party):
    total_docs=[]
    def read_data(filename): 
        with open(filename, 'r') as f:
            data = [line.split(',') for line in f.read().splitlines()] 
    
        return data
        
    data=[i[0] for i in read_data('MoralFoundations\\Data\\Word2Vec\\w2v'+party+'{0}.txt'.format(str(year)))]
    i=0
    for doc in data:
        total_docs.append(TaggedDocument(doc.split(' '), [party+'-'+str(year)]))
        i+=1
        
    return total_docs

total_docs=[]
for year in range(2008,2017):
    total_docs+=Tagged(year, 'sae')+Tagged(year, 'min')



def read_mfd(filename): 
        with open(filename, 'r') as f:
            data = [line.replace('"','') for line in f.read().splitlines()] 
    
        return data

MFDictionary=['HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice']

for i in MFDictionary:
    wordlist=[j for j in read_mfd('MoralFoundations\Data\Moral_Foundations_Dictionary\{0}.csv'.format(i))[1:]]
    exec("%s=%s" % (i, unique_list(wordlist)))
    total_docs+=[TaggedDocument(wordlist,[i])]
    
    

from gensim.models import doc2vec   

model = doc2vec.Doc2Vec(size=300, alpha=0.025, min_alpha=0.025, window=10, min_count=20, workers=8) 
model.build_vocab(total_docs)

for epoch in range(10): 
    model.train(total_docs) 
    model.alpha -= 0.002 # decrease the learning rate 
    model.min_alpha = model.alpha # fix the learning rate, no decay

model.save('MoralFoundations/Data/Word2Vec/doclabelmodel.doc2vec')
model=doc2vec.Doc2Vec.load('MoralFoundations/Data/Word2Vec/yearlabelmodel.doc2vec')


from pandas import Series, DataFrame
import pandas as pd

resultDic={}
for i in range(2008,2017):
    resultDic['{0}sae'.format(i)]=[]
    resultDic['{0}min'.format(i)]=[] 
    
for i in range(2008,2017):    
    for j in MFDictionary:
        resultDic['{0}sae'.format(i)].append(model.docvecs.similarity(j,'min-'+str(year)))
        resultDic['{0}min'.format(i)].append(model.docvecs.similarity(j,'sae-'+str(year)))
    
df=DataFrame(resultDic,index=MFDictionary)
df.to_csv('MoralFoundations/Result/eachresult.csv')

resultDic={}
for i in range(2008, 2017):
    resultDic['{0}sae'.format(i)]=[]
    resultDic['{0}min'.format(i)]=[]        
    
for j in range(0,5):
    result=model.docvecs.most_similar(positive=[MFDictionary[2*j]], negative=[MFDictionary[2*j+1]], topn=30, clip_start=0, clip_end=None, indexer=None)
    result={re.sub("([a-z]{3})-(\d{4})","\\2\\1",i[0]):i[1] for i in result if bool(re.search('[0-9]',i[0]))==True}
    for k in resultDic:
        resultDic[k].append(result[k])
    
df=DataFrame(resultDic, index=['Harm','Fairness','Ingroup','Authority','Purity'])
df.to_csv('MoralFoundations/Result/totalresult.csv')

resultDic={}
for i in MFDictionary:
    resultDic[i]=[]     
    
for i in range(2008, 2017):
    result=model.docvecs.most_similar(positive=['sae'+'-'+str(i)], negative=['min'+'-'+str(i)], topn=30, clip_start=0, clip_end=None, indexer=None)
    result={i[0]:i[1] for i in result if bool(re.search('[0-9]',i[0]))==False}
    for k in resultDic:
        resultDic[k].append(result[k])
    
df=DataFrame(resultDic, index=[i for i in range(2008, 2017)])
df.to_csv('MoralFoundations/Result/subtract.csv')

total={}
for i in range(2008, 2017):
    total[i]=model.docvecs.similarity('sae-'+str(i),'min-'+str(i))

