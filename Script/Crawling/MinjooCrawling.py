# -*- coding: utf-8 -*-
"""
Created on Thu Nov 24 17:50:05 2016

@author: Changdong Oh
"""

import requests
import re
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
    print(url)
    soup=BeautifulSoup(requests.get(url).text,'lxml')
    date=soup.find('span',class_='txt').text
    article=re.sub('[^가-힣]+',' ',soup.find('div',class_='cont').text)
    if '년 월 일' in article:
        print(re.split('년 월 일', article)[-1])
        article=re.split('년 월 일', article)[-2]
    else: print(article[-10:])
    return [date,article]
    
for year in range(2008, 2017):
    import csv
    with open('MoralFoundations\Data\민주{0}.csv'.format(str(year)),'w', newline='') as f:
        w=csv.writer(f)
        more=True
        page=1
        while more==True:
            url_list, more=urlparser(year, page)
            for url in url_list:
                w.writerow(article(url))
                time.sleep(10)
            page+=1
        
    