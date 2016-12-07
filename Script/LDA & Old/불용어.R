stopwords <- tolower(str_replace_all(read.csv("~/Git/R/KPTM/stopwords.csv", quote="\"", stringsAsFactors=FALSE, header=F)[,1],"/",""))
newstopwords=c("조윤선nc","나pv","들pv","총선nc","선대위nc","우리nc","관련해nc","정론관nc","지금까지nc",
               "보이nc","그러하pa","대변인실nc")
stopwords<-c(stopwords,newstopwords)
