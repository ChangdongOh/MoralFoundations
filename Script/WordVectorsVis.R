library(ggplot2)


cleavage=data.frame(matrix(ncol=6, nrow=9))
ownparty=data.frame(matrix(ncol=6, nrow=9))
opposite=data.frame(matrix(ncol=6, nrow=9))
for(year in 2008:2016){
  sae<-read.csv(paste0("Result/Word2Vec/Sae",year,"result.csv"),row.names=1)
  print(sae)
  min<-read.csv(paste0("Result/Word2Vec/Min",year,"result.csv"),row.names=1)
  print(min)
  cleavage[year-2007,]=cbind(sae[3,]-min[3,],year)
  ownparty[year-2007,]=cbind(sae[1,]-min[2,],year)
  opposite[year-2007,]=cbind(sae[2,]-min[1,],year)
}
names(cleavage)=names(ownparty)=names(opposite)=c("Care/Harm","Fairness/Cheating","Loyalty/Betrayal","Authority/Subversion","Purity/Degradation","Year")

plotmaker<-function(dataset){
  
  library(reshape2)
  
  dataset2=melt(dataset,id.vars='Year')
  names(dataset2)[2]="MoralFoundations"
  
  ggplot(data=dataset2, aes(x=Year, y=value, 
                            group=MoralFoundations, color=MoralFoundations))+
    geom_line(stat='identity',
              lwd=2 #선의 굵기 지정
    )+
    scale_y_continuous(name='Cosine Similarity')+
    scale_x_continuous(breaks=c(2008:2016),label=c(2008:2016))+
    scale_color_manual(values=(c("#FF6666","#FFB266","#0072B2","#009E73","#56B4E9")))
}

dataset=c('cleavage','ownparty','opposite')
for(i in dataset){
  plotmaker(get(i))
  ggsave(paste0("Result/Word2Vec/",i,".jpg"),width=24, height=12, units="cm")
}

