mffreq=function(name,texts){
  library(stringr)
  library(psych)
  
  #도덕기반 이름 리스트 활용해 파일에서 불러와 변수로 할당
  MFname=c('HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice')
  #MFname=paste0(MFname,'ext')
  for(i in MFname){
    assign(i,read.csv(paste0(i,'.csv'),sep="", stringsAsFactors=FALSE)[,1])
  }

  name<-deparse(substitute(name))
  mffreq=data.frame(matrix(nrow=10),row.names=MFname)
  n=1
  length=length(texts)
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
    for(m in 1:10){
      mffreq[m, n]<-freq(token, eval(parse(text=MFname[m])))
    }
    n=n+1
    if(n%%500==0){
      print(n/length)
    }
  }
  
  colnames(mffreq)=as.character(seq(1:length))
  mffreq=data.frame(t(mffreq))
  write.csv(mffreq,paste0(name,'mffreq.csv'),row.names=F)
  return(describe(mffreq))
}

