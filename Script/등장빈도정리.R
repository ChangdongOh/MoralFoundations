library(KoNLP)
library(stringr)
library(tm)

min <- read.csv("민주당.csv", fileEncoding="UTF-8", header=TRUE, quote="\"",stringsAsFactors = FALSE)
min<-min[,3]
min<-unique(str_replace_all(min,"[^가-힣]+"," "))
sae <- read.csv("새누리당.csv", fileEncoding="UTF-8", header=TRUE, quote="\"",stringsAsFactors = FALSE)
sae<-sae[,3]
sae<-unique(str_replace_all(sae,"[^가-힣]+"," "))

merge=c(min,sae)

texts<-as.character()
for(i in merge){
  if(nchar(i)>=400){
    texts=c(texts,i)
  }
}


source("전처리2.R", encoding="UTF-8")


#NC항목 계산

ko.wordsNC <- function(texts){
  token<-as.character()
  for(i in texts){
    d <- as.character(i)
    splited<-unlist(str_split(d," "))
    for(j in splited){
      j<-as.character(j)
      pos <- paste(SimplePos22(j))
      extracted <- str_match(pos, '([가-힣]+)/NC')
      keyword <- extracted[,1]
      if(is.na(keyword)){next}
      if(str_detect(keyword,'[가-힣]/[NC]') & nchar(keyword)==4){next}
      token<-c(token, keyword[!is.na(keyword)])
    }  
  }
  token
}



cps <- Corpus(VectorSource(texts))

#TDM

tdmt1<-Sys.time()
tdm=TermDocumentMatrix(cps,
                       control=list(tokenize=ko.wordsNC,
                                    removeNumbers=T,
                                    removePunctuation=T,
                                    wordLengths=c(3, 15),
                                    stopwords = stopwords,
                                    weightiing=weightTfIdf
                       ))


tdmt2<-Sys.time()
tdmt<-tdmt2-tdmt1
tdmt

tdm.matrix <- as.matrix(tdm)
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=T)
write.csv(rownames(tdm.matrix)[word.order[1:200]],"frequencyNC.csv", row.names=F)


#PV

ko.wordsPV <- function(texts){
  token<-as.character()
  for(i in texts){
    d <- as.character(i)
    splited<-unlist(str_split(d," "))
    for(j in splited){
      j<-as.character(j)
      pos <- paste(SimplePos22(j))
      extracted <- str_match(pos, '([가-힣]+)/PV')
      keyword <- extracted[,1]
      token<-c(token, keyword[!is.na(keyword)])
    }
  }
  token
}


cps <- Corpus(VectorSource(texts))

tdmt1<-Sys.time()
tdm=TermDocumentMatrix(cps,
                       control=list(tokenize=ko.wordsPV,
                                    removeNumbers=T,
                                    removePunctuation=T,
                                    wordLengths=c(3, 15),
                                    stopwords = stopwords,
                                    weightiing=weightTfIdf
                       ))


tdmt2<-Sys.time()
tdmt<-tdmt2-tdmt1
tdmt

tdm.matrix <- as.matrix(tdm)
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=T)
write.csv(rownames(tdm.matrix)[word.order[1:200]],"frequencyPV.csv", row.names=F)

#PA 

ko.wordsPA <- function(texts){
  token<-as.character()
  for(i in texts){
    d <- as.character(i)
    splited<-unlist(str_split(d," "))
    for(j in splited){
      j<-as.character(j)
      pos <- paste(SimplePos22(j))
      extracted <- str_match(pos, '([가-힣]+)/PA')
      keyword <- extracted[,1]
      token<-c(token, keyword[!is.na(keyword)])
    }
  }
  token
}


cps <- Corpus(VectorSource(texts))

tdmt1<-Sys.time()
tdm=TermDocumentMatrix(cps,
                       control=list(tokenize=ko.wordsPA,
                                    removeNumbers=T,
                                    removePunctuation=T,
                                    wordLengths=c(3, 15),
                                    stopwords = stopwords,
                                    weightiing=weightTfIdf
                       ))

tdmt2<-Sys.time()
tdmt<-tdmt2-tdmt1
tdmt

tdm.matrix <- as.matrix(tdm)
word.count <- rowSums(tdm.matrix)
word.order <- order(word.count, decreasing=T)
write.csv(rownames(tdm.matrix)[word.order[1:200]],"frequencyPA.csv", row.names=F)
