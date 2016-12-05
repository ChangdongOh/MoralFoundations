MFcomparing<-function(year){

  library(wordVectors)
  
  source("Script/Functions.R", encoding="UTF-8")
  
  tokenizeforw2v(partydata(sae, year),paste0('w2vsae',year))
  print('새누리 토큰화 완료')
  tokenizeforw2v(partydata(min, year),paste0('w2vmin',year))
  print('민주 토큰화 완료')
  saemodel=train_word2vec(paste0("Data/Word2Vec/w2vsae",year,".txt"),output=paste0("w2vmodelsae",year,'.bin'),threads = 4,vectors = 300,min_count=20,window=10,iter=18)
  print('새누리 벡터모델 생성 완료')
  class(saemodel)<-'saemodel'
  minmodel=train_word2vec(paste0("Data/Word2Vec/w2vmin",year,".txt"),output=paste0("w2vmodelmin",year,'.bin'),threads = 4,vectors = 300,min_count=20,window=10,iter=18)
  print('민주 벡터모델 생성 완료')
  class(minmodel)<-'minmodel'
  
  #도덕기반 이름 리스트 활용해 파일에서 불러와 변수로 할당
  MFname=c('HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice')
  #MFname=paste0(MFname,'ext')
  for(i in MFname){
    assign(i,read.csv(paste0('Data/Moral_Foundations_Dictionary/', i,'.csv'),sep="", stringsAsFactors=FALSE)[,1])
  }
  

  
  #새누리당 부분
  vcalculation<-function(model){
    harm=model[[HarmVirtue]]-model[[HarmVice]]
    fairness=model[[FairnessVirtue]]-model[[FairnessVice]]
    ingroup=model[[IngroupVirtue]]-model[[IngroupVice]]
    authority=model[[AuthorityVirtue]]-model[[AuthorityVice]]
    purity=model[[PurityVirtue]]-model[[PurityVice]]
    min=model[['민주당/NC']]
    sae=model[['새누리당/NC']]
    if(class(model)=='saemodel'){
      cleavage=sae-min
    }
    else{
      cleavage=min-sae
    }
    
    result=data.frame(Harm=numeric(3),Fairness=numeric(3),Ingroup=numeric(3),Authority=numeric(3),Purity=numeric(3),
                      row.names=c('Saenuri', 'Minjoo', 'Cleavage'))
  }
  MF=c(harm,fairness,ingroup,authority,purity)
  for(i in MF){
    result[,as.character(i)]=c(cosineSimilarity(i,sae),cosineSimilarity(i,min),cosineSimilarity(i,cleavage))
  }
  
  Saeresult=vcalculation(saemodel)
  Minresult=vcalculation(minmodel)
  
  write.csv(Saeresult,paste0('Result/Word2Vec/','Sae',year,'result.csv'))
  write.csv(Minresult,paste0('Result/Word2Vec/','Min',year,'result.csv'))
  
    
}

