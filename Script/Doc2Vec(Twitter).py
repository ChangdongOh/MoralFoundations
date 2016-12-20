# -*- coding: utf-8 -*-
"""
Created on Fri Nov 25 21:33:24 2016

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
    
from gensim.models.doc2vec import TaggedDocument

def Tagged(year, party):
    total_docs=[]
    def read_data(filename): 
        with open(filename, 'r', encoding='UTF8') as f:
            data = [line.split(',')[2] for line in f.read().splitlines()] 

        return data
        
    data=unique_list([i for i in read_data('MoralFoundations\\Data\\Raw Data\\'+party+'{0}.csv'.format(str(year)))])
    #i=0
    #for doc in data:
     #   total_docs.append(TaggedDocument(doc.split(' '), [party+'-'+str(year)+'-'+str(i)]))
      #  i+=1
    if party=='새누리': party='sae' 
    else:
        party='min'
    for doc in data:
        doc=[i for i in tokenize(doc) if bool(re.search("Adjective|Noun|Adverb|Verb",i))==True]
        total_docs.append(TaggedDocument(doc, [str(year)+party]))
        
    return total_docs

total_docs=[]
for year in range(2008,2017):
    total_docs+=Tagged(year, '새누리')+Tagged(year, '민주')
 
MFDictionary=['HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice']
for i in MFDictionary:
    wordlist=[]
    for j in read_mfd('MoralFoundations\Data\Moral_Foundations_Dictionary\{0}.csv'.format(i))[1:]:
        Morp=tokenize(re.sub('[/|A-Za-z]','', re.sub('"','',j)))[0]
        if len(re.sub('[^가-힣+]','',Morp))>1:
            wordlist.append(Morp)
    exec("%s=%s" % (i, unique_list(wordlist)))
    total_docs+=[TaggedDocument(wordlist,[i])]   

from gensim.models import doc2vec   

model = doc2vec.Doc2Vec(size=300, alpha=0.025, min_alpha=0.025, window=10, min_count=20, workers=8) 
model.build_vocab(total_docs)

for epoch in range(10): 
    model.train(total_docs) 
    model.alpha -= 0.002 # decrease the learning rate 
    model.min_alpha = model.alpha # fix the learning rate, no decay
#model.init_sims(replace=True)    
#메모리 세이브용이나 infer_vector를 위해서는 쓰면 안 됨
model.save('MoralFoundations/Data/Word2Vec/twitter.doc2vec') #vector space 저장
#model=doc2vec.Doc2Vec.load('MoralFoundations/Data/Word2Vec/twitteryear.doc2vec')


from pandas import Series, DataFrame
import pandas as pd

resultDic={}
for i in range(2008,2017):
    resultDic['{0}sae'.format(i)]=[]
    resultDic['{0}min'.format(i)]=[] 
    
for i in range(2008,2017):    
    for j in MFDictionary:
        resultDic['{0}sae'.format(i)].append(model.docvecs.similarity(j,str(year)+'sae'))
        resultDic['{0}min'.format(i)].append(model.docvecs.similarity(j,str(year)+'min'))
    
df=DataFrame(resultDic,index=MFDictionary)
df.to_csv('MoralFoundations/Result/tweachresult.csv')

resultDic={}
for i in range(2008, 2017):
    resultDic['{0}sae'.format(i)]=[]
    resultDic['{0}min'.format(i)]=[]        
    
for j in range(0,5):
    result=model.docvecs.most_similar(positive=[MFDictionary[2*j]], negative=[MFDictionary[2*j+1]], topn=30, clip_start=0, clip_end=None, indexer=None)
    result={i[0]:i[1] for i in result if bool(re.search('[0-9]',i[0]))==True}
    for k in resultDic:
        resultDic[k].append(result[k])
    
df=DataFrame(resultDic, index=['Harm','Fairness','Ingroup','Authority','Purity'])
df.to_csv('MoralFoundations/Result/twtotalresult.csv')

resultDic={}
for i in MFDictionary:
    resultDic[i]=[]     
    
for i in range(2008, 2017):
    result=model.docvecs.most_similar(positive=[str(i)+'sae'], negative=[str(i)+'min'], topn=30, clip_start=0, clip_end=None, indexer=None)
    result={i[0]:i[1] for i in result if bool(re.search('[0-9]',i[0]))==False}
    for k in resultDic:
        resultDic[k].append(result[k])
    
df=DataFrame(resultDic, index=[i for i in range(2008, 2017)])
df.to_csv('MoralFoundations/Result/twsubtract.csv')

total={}
for i in range(2008, 2017):
    total[i]=model.docvecs.similarity(str(i)+'sae',str(i)+'min')
