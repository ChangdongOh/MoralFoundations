freq=function(texts,checklist){
  count=0
  for(i in texts){
    for(j in checklist){
      if(identical(i,j)){
        count=count+1
      }
    }
  }
  count
}

#a<-str_extract(texts, checklist)
#length(a[!is.na(a)])로 대체 가능