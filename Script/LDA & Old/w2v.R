library(wordVectors)

model = train_word2vec("Data/Word2Vec/tokenizedmin.txt",output="minjoo_vectors.bin",threads = 4,vectors = 300,min_count=20,window=10,iter=18)
#model=read.vectors("Data/Word2Vec/minjoo_vectors.bin")

#도덕기반 이름 리스트 활용해 파일에서 불러와 변수로 할당
MFname=c('HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice')
#MFname=paste0(MFname,'ext')
for(i in MFname){
  assign(i,read.csv(paste0('Moral_Foundations_Dictionary/', i,'.csv'),sep="", stringsAsFactors=FALSE)[,1])
}

candandparty=c("박근혜nc","문재인nc","새누리당nc","민주당nc","이명박nc","노무현nc")

cosinedistance=function(a, b){
  frame=data.frame(matrix(ncol=5))[-1,]
  for(i in a){
    len=as.numeric()
    for(j in 1:5){
      len=c(len,cosineSimilarity(model[[i]],model[[eval(parse(text=MFname[2*j-1]))]]-model[[eval(parse(text=MFname[2*j]))]])[,1])
    }
    frame=rbind(frame, len)
  }
  names(frame)=c('Harm','Fairness','Ingroup','Authority','Purity')
  row.names(frame)=a
  return(frame)
}

result<-cosinedistance(candandparty,MFnameext)
write.csv(result,'minjoow2vext.csv')


MFnameext=paste0(MFname,'ext')

frame=data.frame(matrix(ncol=5))[-1,]
for(i in 2:1){
  len=as.numeric()
  for(j in 1:5){
    len=c(len,cosineSimilarity(model[[candandparty[i]]]+model[[candandparty[i+2]]],model[[eval(parse(text=MFnameext[2*j-1]))]]-model[[eval(parse(text=MFnameext[2*j]))]])[,1])
  }
  frame=rbind(frame, len)
}
names(frame)=c('Harm','Fairness','Ingroup','Authority','Purity')
row.names(frame)=c('문재인&민주','박근혜&새누리')
write.csv(frame,'minmergedext.csv')






frame=data.frame(matrix(ncol=5))[-1,]
for(i in 1:4){
  len=as.numeric()
  for(j in 1:5){
    len=c(len,cosineSimilarity(model[[candandparty[i]]],model[[eval(parse(text=MFname[2*j-1]))]]-model[[eval(parse(text=MFname[2*j]))]])[,1])
  }
  frame=rbind(frame, len)
}
names(frame)=c('Harm','Fairness','Ingroup','Authority','Purity')
row.names(frame)=candandparty[1:4]
write.csv(frame,'minmergedext.csv')


#두 후보자 사이의 간격 구하는 작업이고 이게 핵심이었

cleavage=model[['문재인nc']]-model[['박근혜nc']]
harm=model[[HarmVirtue]]-model[[HarmVice]]
fair=model[[FairnessVirtue]]-model[[FairnessVice]]
ingroup=model[[IngroupVirtue]]-model[[IngroupVice]]
autho=model[[AuthorityVirtue]]-model[[AuthorityVice]]
pure=model[[PurityVirtue]]-model[[PurityVice]]
moon=model[['문재인nc']]
park=model[['박근혜nc']]

cosineSimilarity(cleavage, harm)
cosineSimilarity(cleavage, fair)
cosineSimilarity(cleavage, ingroup)
cosineSimilarity(cleavage, autho)
cosineSimilarity(cleavage, pure)



cosineSimilarity(-moon, harm)
cosineSimilarity(-moon, fair)
cosineSimilarity(-moon, ingroup)
cosineSimilarity(-moon, autho)
cosineSimilarity(-moon, pure)