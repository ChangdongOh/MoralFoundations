library(KoNLP)
library(tm)
library(stringr)
library(psych)

#도덕기반 이름 리스트 활용해 파일에서 불러와 변수로 할당
MFname=c('HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice')
#MFname=paste0(MFname,'ext')
for(i in MFname){
  assign(i,read.csv(paste0(i,'.csv'),sep="", stringsAsFactors=FALSE)[,1])
}

source("읽어오기.R", encoding="UTF-8")
source("형태소분리.R", encoding="UTF-8")
sae<-partydata(sae)
