library(KoNLP)
library(stringr)
library(tm)
library(slam)
library(topicmodels)
library(lda)

source("읽어오기.R", encoding="UTF-8")
source("형태소분리.R", encoding="UTF-8")
source("불용어.R", encoding="UTF-8")
stopwords<-c(stopwords,"문재인nc","박근혜nc","민주당nc","새누리당nc")

cps <- Corpus(VectorSource(texts))

#TDM

tdmt1<-Sys.time()
tdm=TermDocumentMatrix(cps,
                       control=list(tokenize=ko.words,
                                    removeNumbers=T,
                                    removePunctuation=T,
                                    wordLengths=c(3, 15),
                                    stopwords = stopwords,
                                    weightiing=weightTfIdf
                       ))


tdmt2<-Sys.time()
tdmt<-tdmt2-tdmt1
tdmt


#내림차순 정리
word.count = as.array(rollup(tdm, 2))
word.order = order(word.count, decreasing = T)
freq.word = word.order[1:4000]
#dtm = as.DocumentTermMatrix(tdm[freq.word,])
dtm = as.DocumentTermMatrix(tdm)




ldaform = dtm2ldaformat(dtm, omit_empty = T)

alpha=0.02
eta=0.02

t1 <- Sys.time()
result.lda=lda.collapsed.gibbs.sampler(documents=ldaform$documents, 
                                       K=25, vocab=ldaform$vocab, 
                                       num.iterations=5000, 
                                       burnin=1000, 
                                       alpha=alpha, 
                                       eta=eta)

t2 <- Sys.time()
ldat<-t2 - t1
ldat

summary(result.lda)
View(top.topic.words(result.lda$topics))
topicsandwords<-top.topic.words(result.lda$topics,num.words=50,by.score=T)
topicnum<-result.lda$topic_sums[,1]
topicnum=topicnum*100/sum(topicnum)
topicsandwords<-rbind(topicnum, topicsandwords)
write.csv(result.lda$topics,'saetopicwords.csv',row.names=F)
write.csv(topicsandwords, "새누리토픽.csv", row.names=F)
#View(top.topic.documents(result.lda$document_sums))
#토픽별 문서 분포 체크


#LDAvis

documents<-ldaform$documents
vocab<-ldaform$vocab

get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}

doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
term.frequency<-word.count[ldaform$vocab]


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

serVis(json, out.dir = 'sae', open.browser = T)

