source("Script/Functions.R", encoding="UTF-8")

MFcomparing<-function(year){

  library(wordVectors)
  
  tokenizeforw2v(partydata(sae, year),paste0('w2vsae',year))
  print('새누리 토큰화 완료')
  tokenizeforw2v(partydata(min, year),paste0('w2vmin',year))
  print('민주 토큰화 완료')
  train_word2vec(paste0("Data/Word2Vec/w2vsae",year,".txt"),output=paste0("Data/Word2Vec/w2vmodel_sae",year,'.bin'),threads = 8,force=T, vectors = 300,min_count=20,window=10,iter=18)
  saemodel=read.vectors(paste0("Data/Word2Vec/w2vmodel_sae",year,'.bin'))
  print('새누리 벡터모델 생성 완료')
  train_word2vec(paste0("Data/Word2Vec/w2vmin",year,".txt"),output=paste0("Data/Word2Vec/w2vmodel_min",year,'.bin'),threads = 8, force=T,vectors = 300,min_count=20,window=10,iter=18)
  minmodel=read.vectors(paste0("Data/Word2Vec/w2vmodel_min",year,'.bin'))
  print('민주 벡터모델 생성 완료')
  
  #도덕기반 이름 리스트 활용해 파일에서 불러와 변수로 할당
  MFname=c('HarmVirtue','HarmVice','FairnessVirtue','FairnessVice','IngroupVirtue','IngroupVice','AuthorityVirtue','AuthorityVice','PurityVirtue','PurityVice')
  #MFname=paste0(MFname,'ext')
  for(i in MFname){
    assign(i,unique(read.csv(paste0('Data/Moral_Foundations_Dictionary/', i,'.csv'),sep="", stringsAsFactors=FALSE)[,1]))
  }
  
  vcalculationeach<-function(model, party){
    result=data.frame(Harm=numeric(3),Fairness=numeric(3),Ingroup=numeric(3),Authority=numeric(3),Purity=numeric(3),
               row.names=c('Saenuri', 'Minjoo', 'Cleavage'))
    for(i in MFname){
      for(j in get(i)){
        result[[i]]
      }
    }
    
  }
  
  
  #도덕기반과 정당별 계산하는 함수
  vcalculation<-function(model, party){
    Harm=model[[HarmVirtue]]-model[[HarmVice]]
    Fairness=model[[FairnessVirtue]]-model[[FairnessVice]]
    Ingroup=model[[IngroupVirtue]]-model[[IngroupVice]]
    Authority=model[[AuthorityVirtue]]-model[[AuthorityVice]]
    Purity=model[[PurityVirtue]]-model[[PurityVice]]
    min=model[['민주당/NC']]
    sae=model[['새누리당/NC']]
    if(party==0){
      cleavage=sae-min
    } else {
      cleavage=min-sae 
    }
    
    result=data.frame(Harm=numeric(3),Fairness=numeric(3),Ingroup=numeric(3),Authority=numeric(3),Purity=numeric(3),
                      row.names=c('Saenuri', 'Minjoo', 'Cleavage'))
    MF=c('Harm','Fairness','Ingroup','Authority','Purity')
    for(i in MF){
      result[,i]=c(cosineSimilarity(get(i),sae),cosineSimilarity(get(i),min),cosineSimilarity(get(i),cleavage))
    }
    result %>% return()
  }

  
  Saeresult<<-vcalculation(saemodel,0)
  Minresult<<-vcalculation(minmodel,1)
  
  write.csv(Saeresult,paste0('Result/Word2Vec/','Sae',year,'result.csv'))
  write.csv(Minresult,paste0('Result/Word2Vec/','Min',year,'result.csv'))
}

yearbyyear=vector('list',9)
names(yearbyyear)=paste0('year',c(2008:2016))
for(i in 2008:2016){
  MFcomparing(i)
 # yearbyyear[[paste0('year',i)]]$Min=Minresult
 # yearbyyear[[paste0('year',i)]]$Sae=Saeresult
}

