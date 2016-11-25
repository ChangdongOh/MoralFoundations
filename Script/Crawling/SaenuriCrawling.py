# -*- coding: utf-8 -*-
"""
Created on Fri Nov 25 00:53:47 2016

@author: Changdong Oh
"""


import requests
import re
import time
from bs4 import BeautifulSoup


def urlparser(year, page):
    headers={'Content-Type':'application/x-www-form-urlencoded',
    'Host':'www.saenuriparty.kr',
    'Origin':'http://www.saenuriparty.kr',
    'Referer':'http://www.saenuriparty.kr/web/news/briefing/delegateBriefing/mainDelegateBriefingView.do',
    'Upgrade-Insecure-Requests':'1',
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.59 Safari/537.36'}
    payload={'srchYear':str(year),
             'searchCondition':'1',
             'viewType':'L',
             'pageIndex':str(page)}
    url='http://www.saenuriparty.kr/web/news/briefing/delegateBriefing/mainDelegateBriefingView.do'
    soup=BeautifulSoup(requests.post(url, headers=headers,data=payload).text,'lxml')
    pageurl_list= ['http://www.saenuriparty.kr/web/news/briefing/delegateBriefing/readDelegateBriefingView.do?bbsId='+i.find('a')['onclick'][10:-3] for i in soup.find_all('td',class_='subject')]
    if soup.find('div',class_='board_paging').find('a',attrs={'onclick':"_getList({0});return false; ".format(str(page+1))})==None:
        more=False
    else: more=True
    return pageurl_list, more
    
    
def article(url):
    #print(url)
    soup=BeautifulSoup(requests.get(url).text,'lxml')
    date=soup.find('td',class_='date').find('span').text
    article=soup.find('div',class_='editor_cont').text
    article=re.sub("(\d+)[.]\s+(\d+)[.]\s+(\d+)",r"\1년 \2월 \3일", article)
    article=re.sub('[^가-힣]+',' ',article)
    if '년 월 일' in article:
        if len(re.split('년 월 일', article))>2:
            article_new=''
            for i in re.split('년 월 일', article)[0:-1]:
                article_new+=i
            article=article_new
            #print(article)
        else: article=re.split('년 월 일', article)[-2]
    #print([date,article])
    return [url, date,article]
    
for year in range(2008, 2017):
    import csv
    with open('새누리{0}.csv'.format(str(year)),'w', encoding='UTF8', newline='') as f:
        w=csv.writer(f)
        more=True
        page=1
        while more==True:
            url_list, more=urlparser(year, page)
            for url in url_list:
                w.writerow(article(url))
                time.sleep(1)
            page+=1
    
    