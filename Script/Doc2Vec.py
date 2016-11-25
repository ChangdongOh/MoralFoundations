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
        
MFDictionary=['HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice']
for i in MFDictionary:
    wordlist=[]
    for j in read_mfd('MoralFoundations\PData\Moral_Foundations_Dictionary\{0}.csv'.format(i))[1:]:
        Morp=tokenize(re.sub('[A-Za-z]','', re.sub('"','',j)))[0]
        if len(re.sub('[^가-힣+]','',Morp))>1:
            wordlist.append(Morp)
    exec("%s=%s" % (i, unique_list(wordlist)))
        


    
from gensim.models.doc2vec import TaggedDocument

def Tagged(year, party):
    total_docs=[]
    def read_data(filename): 
        with open(filename, 'r', encoding='UTF8') as f:
            data = [line.split(',') for line in f.read().splitlines()] 
    
        return data
        
    data=[i[1] for i in read_data('MoralFoundations\\PData\\'+party+'{0}.csv'.format(str(year)))]
    i=0
    for doc in data:
        total_docs.append(TaggedDocument(doc.split(' '), [party+'-'+str(year)+'-'+str(i)]))
        i+=1
        
    return total_docs

total_docs=[]
for year in range(2008,2017):
    total_docs+=Tagged(year, '새누리')+Tagged(year, '민주')
 
from gensim.models import doc2vec   
model = doc2vec.Doc2Vec(size=300, alpha=0.025, min_alpha=0.025, window=10, min_count=20, workers=8) 
model.build_vocab(total_docs)

for epoch in range(10): 
    model.train(total_docs) 
    model.alpha -= 0.002 # decrease the learning rate 
    model.min_alpha = model.alpha # fix the learning rate, no decay
#model.init_sims(replace=True)    
#메모리 세이브용이나 infer_vector를 위해서는 쓰면 안 됨
model.save('doc2vec.model')

from sklearn.metrics.pairwise import cosine_similarity
cosine_similarity(model['평등/Noun'],model['공평/Noun'])

for i in range(2008, 2017):
    for j in 
    
    
        
        