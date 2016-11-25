# -*- coding: utf-8 -*-
"""
Created on Thu Nov 24 17:50:05 2016

@author: Changdong Oh
"""

import requests
import re
import time
from bs4 import BeautifulSoup


def urlparser(year, page):
    headers={'Content-Type':'application/x-www-form-urlencoded',
    'Origin':'http://theminjoo.kr',
    'Referer':'http://theminjoo.kr/briefingList.do',
    'Upgrade-Insecure-Requests':'1',
    'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/55.0.2883.59 Safari/537.36'}
    payload={'date_1':str(year),
             'searchCondition':'0',
             'pageIndex':str(page)}
    url='http://theminjoo.kr/briefingList.do'
    soup=BeautifulSoup(requests.post(url, headers=headers,data=payload).text,'lxml')
    pageurl_list= [i.find('a')['href'] for i in soup.find_all('td',class_='tal')][1:]
    if soup.find('div',class_='paging').find('a',attrs={'onclick':"fn_egov_link_page({0}); return false;".format(str(page+1))})==None:
        more=False
    else: more=True
    return pageurl_list, more
    
def article(url):
    url='http://theminjoo.kr'+url
    soup=BeautifulSoup(requests.get(url).text,'lxml')
    date=soup.find('span',class_='txt').text
    article=soup.find('div',class_='cont').text
    article=re.sub("(\d+)[.]\s+(\d+)[.]\s+(\d+)",r"\1년 \2월 \3일", article)
    article=re.sub('[^가-힣]+',' ',article)
    if '년 월 일' in article:
        if len(re.split('년 월 일', article))>2:
            article_new=''
            for i in re.split('년 월 일', article)[0:-1]:
                article_new+=i
            article=article_new
            print(article)
        else: article=re.split('년 월 일', article)[-2]    
    print([url, date,article])
    return [url, date,article]
    
for year in range(2012, 2017):
    import csv
    with open('MoralFoundations\Data\민주{0}.csv'.format(str(year)),'w', encoding='UTF8', newline='') as f:
        w=csv.writer(f)
        more=True
        page=1
        while more==True:
            url_list, more=urlparser(year, page)
            for url in url_list:
                w.writerow(article(url))
                time.sleep(1)
            page+=1
            
            
#'4대강 사업' 등을 재처리할 필요 있음
            
        
    