library(ggplot2)
library(dplyr)

diff<-read.csv('Result/Subtract.csv',row.names=1) %>% select(HarmVirtue,HarmVice,FairnessVirtue,FairnessVice,IngroupVirtue,IngroupVice,AuthorityVirtue,AuthorityVice,PurityVirtue,PurityVice)
diff<-diff %>% cbind('Year'=row.names(diff))

library(reshape2)

dataset=melt(diff,id.vars='Year')
names(dataset)[2]='MoralFoundations'

ggplot(data=dataset, aes(x=Year, y=value, 
                          group=MoralFoundations, color=MoralFoundations))+
  geom_line(stat='identity',
            lwd=2 #선의 굵기 지정
  )+
  scale_y_continuous(name='Cosine Similarity')+
  scale_color_manual(values=(c("#FF6666","#FF3333","#FFFF99","#FFFF00","#99CCFF","#3399FF","#99FFCC","#00FF80","#CC99FF","#330066")))

ggsave('Result/Subtract.png',width=24, height=12, units="cm")