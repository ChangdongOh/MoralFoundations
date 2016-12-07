library(RSelenium)
library(rvest)
library(httr)
library(stringr)

minjoo<-as.data.frame(matrix(ncol=3),stringsAsFactors=F)
names(minjoo)<-c("title","date","article")
minjoo <- minjoo[-1,]
url_head="http://theminjoo.kr/"


checkForServer()
startServer()
remDr = remoteDriver(browserName = 'chrome')
remDr$open()
remDr$navigate('http://theminjoo.kr/briefingList.do')
Sys.sleep(4)
#search.form = remDr$findElement(using = 'class', 'slt_val')
#page$getElementAttribute('href')
#page$clickElement()
#search.form = remDr$findElement(using = 'link text', '2012')
#page$getElementAttribute('href')
#page$clickElement()
#search.form = remDr$findElement(using = 'name', 'searchKeyword')
#search.form$sendKeysToElement(list(key='enter'))

page = remDr$findElement(using ='link text','2')
page$getElementAttribute('href')
page$clickElement()
Sys.sleep(2)




for(i in 1:336){ 
  j<-as.character(i) 
  page = remDr$findElement(using ='link text',j)
  page$getElementAttribute('href')
  page$clickElement()
  Sys.sleep(1)
  # ´ëº¯ÀÎ ³íÆòÀÌ³ª ¸ðµÎ¹ß¾ð µîÀÇ °æ¿ì ¹ß¾ð Àå¼Ò¿Í ÀÏ½Ã, ½Ã°£ ÀüÃ³¸®ÇØ¾ß ÇÏ°í ¹ß¾ðÀÚ ¿ª½Ã µû·Î Ã³¸®ÇÒ ÇÊ¿ä°¡ ÀÖÀ½. °¡´ÉÇÏ¸é ¹ß¾ðÀÚ ¿ª½Ã ºÐ·ùÇØ¼­ µû·Î ÀúÀåÇØ¾ß.
  link = remDr$getPageSource()
  link = read_html(link[[1]])
  url_number<-html_attr(html_nodes(link,'td.tal a'), 'href')
  url_number<-gsub("'","",url_number) 
  url<-paste(url_head,url_number,sep="")
  for(k in 2:11){
    doc=read_html(GET(url[k]))
    title=str_replace_all(html_text(html_nodes(doc,"h2.title")), "[^°¡-ÆR]+"," ")
    article=gsub("[A-Za-z]", "", gsub("\\+", "", gsub("<", "", gsub(">", " ", gsub("\\)", " ", gsub("\\(", "", gsub("\\d+", "",str_trim(html_text(html_nodes(doc,"div.cont"))))))))))
    date=html_text(html_nodes(doc,"span.txt"))
    new<-data.frame(title, date[1], article,stringsAsFactors=F)
    minjoo<-rbind(minjoo,new,stringsAsFactors=F)
  }
  if(i%%5==0){
    page = remDr$findElement(using ='class','btn_next')
    page$getElementAttribute('href')
    page$clickElement()
    Sys.sleep(1)
  }
}

minjoo<-unique(minjoo)
minjoo<-gsub(",","",minjoo)
minjoo<-gsub("\n","",minjoo)
write.csv(minjoo,file="¹ÎÁÖ´ç2011.csv",quote=T, row.names=FALSE ,fileEncoding="UTF-8")
