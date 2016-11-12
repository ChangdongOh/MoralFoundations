library(KoNLP)
library(stringr)
library(tm)
library(slam)
library(topicmodels)
library(lda)


sae <- read.csv("~/TM/새누리당.csv", fileEncoding="UTF-8", header=TRUE, quote="\"",stringsAsFactors = FALSE)
min <- read.csv("~/TM/민주당.csv", fileEncoding="UTF-8", header=TRUE, quote="\"",stringsAsFactors = FALSE)
sae<-sae[,3]
min<-min[,3]
min<-unique(str_replace_all(min,"[^가-힣]+"," "))
minjoo<-as.character()
for(i in min){
  if(nchar(i)>=400){
    minjoo=c(minjoo,i)
  }
}

sae<-unique(str_replace_all(sae,"[^가-힣]+"," "))
saenuri<-as.character()
for(i in sae){
  if(nchar(i)>=400){
    saenuri=c(saenuri,i)
  }
}


texts<-minjoo



#개별 문서로 분리해서 처리하려다 문제 생겨서 개별 단어로 분리하는 전략 채택
#전체 문서를 단어로 분리해서 처리하는 방법 가능한지 찾아봐야. 시간 더 줄어들 가능성 있음.
#정규식 파트 추가적으로 고려해 볼 필요 있음. 특히 의존명사(NB)의 경우 '해를 주다'와 같은
#명사들을 포괄하기 위해서는 반드시 들어가야 함.

ko.words <- function(texts){
  token<-as.character()
  for(i in texts){
    d <- as.character(i)
    splited<-unlist(str_split(d," "))
    for(j in splited){
      j<-as.character(j)
      pos <- paste(SimplePos22(j))
      extracted <- str_match(pos, '([가-힣]+)/([PMF][CQVAMAf])')
      keyword <- extracted[,2]
      token<-c(token, keyword[!is.na(keyword)])
    }
  }
  token
}


cps <- Corpus(VectorSource(texts))


#TDM

tdmt1<-Sys.time()
tdm=TermDocumentMatrix(cps,
                       control=list(tokenize=ko.words,
                                    removeNumbers=T,
                                    removePunctuation=T,
                                    wordLengths=c(2, 15),
                                    stopwords = c(stopwordsmain, stopwordspoli, stopwordsPM),
                                    weighting=weightTfIdf
                       ))


tdmt2<-Sys.time()
tdmt<-tdmt2-tdmt1
tdmt


#내림차순 정리
word.count = as.array(rollup(tdm, 2))
word.order = order(word.count, decreasing = T)
freq.word = word.order[1:2000]
dtm = as.DocumentTermMatrix(tdm[freq.word,])
save(dtm, file="dtm.RData")



ldaform = dtm2ldaformat(dtm, omit_empty = T)

alpha=0.01
eta=0.01

t1 <- Sys.time()
result.lda=lda.collapsed.gibbs.sampler(documents=ldaform$documents, 
                                       K=20, vocab=ldaform$vocab, 
                                       num.iterations=5000, 
                                       burnin=1000, 
                                       alpha=alpha, 
                                       eta=eta)

t2 <- Sys.time()
ldat<-t2 - t1
ldat

summary(result.lda)
View(top.topic.words(result.lda$topics))
topicsandwords<-top.topic.words(result.lda$topics)
write.csv(topicsandwords, "민주토픽명사제외.csv", row.names=F,fileEncoding="UTF-8")




#LDAvis

documents<-ldaform$documents
vocab<-ldaform$vocab

get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}

doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
term.frequency<-word.count[ldaform$vocab[1:2000]]


theta <- t(apply(result.lda$document_sums + alpha, 2, function(x) x/sum(x)))
phi <- t(apply(t(result.lda$topics) + eta, 2, function(x) x/sum(x)))

library(LDAvis)
library(servr)

options(encoding = 'UTF-8')

json <- createJSON(phi = phi, 
                   theta = theta, 
                   doc.length = doc.length, 
                   vocab = vocab, 
                   term.frequency = term.frequency
)

serVis(json, out.dir = 'minwithoutnoun', open.browser = T)


