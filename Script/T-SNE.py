# -*- coding: utf-8 -*-
"""
Created on Mon Dec 19 15:47:31 2016

@author: Changdong Oh
"""


import matplotlib.pyplot as plt
%matplotlib inline
import matplotlib

#matplotlib의 글자가 꺠지지 않게 하기 위해 matplotlib의 폰트를 바꾸어줌
from matplotlib import font_manager, rc
font_name = font_manager.FontProperties(fname="C:\\Windows\\Fonts\\malgun.ttf").get_name()
rc('font', family=font_name)
flist = matplotlib.font_manager.get_fontconfig_fonts()

from sklearn.manifold import TSNE
tsne = TSNE(perplexity=5, n_components=2, init='pca', n_iter=5000)
from sklearn.cluster import KMeans

index=[i for i in range(28)]
names=[model.docvecs.index_to_doctag(i) for i in index]

textplot = tsne.fit_transform(model.docvecs[names])
kmeans = KMeans()
kmeans.fit(textplot)
cluster = kmeans.predict(textplot)

xlist = []
ylist = []
for x, y  in textplot:
    xlist.append(x)
    ylist.append(y)
plt.figure(figsize=(20,20))
plt.scatter(xlist,ylist, c=cluster)
rc('font',family=font_name, size=14)
for k, v, s in zip(xlist,ylist,names):
    plt.text(k,v,s)
    
plt.savefig('plot2.png')
