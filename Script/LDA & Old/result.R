library(psych)

sae=read.csv('saefreq.csv',row.names=1)*1.856212/1.510149
min=read.csv('minfreq.csv',row.names=1)
logmin=log(min+0.01)
logsae=log(sae+0.01)
View(describe(min)-describe(sae))
View(describe(logmin)-describe(logsae))

write.csv((describe(min)-describe(sae)),'freqresult.csv')
write.csv((describe(logmin)-describe(logsae)),'loggedfreqresult.csv')

b=1
for(i in min){
  a=1
  for(j in i){
    if(j>0){
      min[a,b]<-1
    }
    a=a+1
  }
  b=b+1
}
