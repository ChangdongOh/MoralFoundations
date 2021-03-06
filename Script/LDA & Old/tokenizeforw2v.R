library(KoNLP)
library(stringr)


source("Script/Functions.R", encoding="UTF-8")


sae<-partydata(sae,2011)
min<-partydata(min,2011)

texts=c(min,sae)

tokenized<-as.data.frame(matrix(nrow=1))
n=1
for(i in texts){
  token<-tolower(str_replace_all(ko.words(i),"/",""))
  l=1
  for(j in token){
    for(k in stopwords){
      if(identical(k, j)){
        token<-token[-l]
      }
    }
    l=l+1
  }
  token<-paste0(token,collapse=",")
  tokenized[n,]<-token
  n=n+1
}
i=1
for(j in tokenized[,1]){
  tokenized[i,1]<-str_replace_all(j,","," ")
  i=i+1
}

write.csv(tokenized,'tokenized.csv',row.names=F)
