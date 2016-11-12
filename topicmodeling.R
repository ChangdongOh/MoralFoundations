library(KoNLP)
library(stringr)
library(tm)
library(slam)

comments <- read.csv("~/TM/새누리당.csv", fileEncoding="UTF-8", header=TRUE, quote="\"",stringsAsFactors = FALSE)


#각종 특수문자의 경우 미리 제거해주지 않으면 형태소 분석기가 분리해내지 못하므로 미리 처리해야
texts<-comments[,3]
texts <- gsub("‘"," ", gsub("’"," ",gsub("·"," ",gsub("」"," ",gsub("「"," ", gsub("[ㄱ-ㅎ]"," ",gsub("[A-Za-z]", " ", gsub("\\+", " ", gsub("<", " ", gsub(">", " ", gsub("\\)", " ", gsub("\\(", " ", gsub("\\d+", " ", texts))))))))))))) 

#사실 위처럼 복잡하게 할 필요 없이 아래 코드 한 줄로만 처리하면 한글만 남길 수 있으나, 이상하게도 에러가 발생. 임시변통으로 위의 코드 활용.
#texts<-str_replace_all(texts,"[^가-힣]+"," ")


#세종사전업데이트
useSejongDic()
mergeUserDic(data.frame(c("문재인","이정희","황천모","안철수","노무현",
                          "이명박","신경민","정성호","김진표",
                          "심상정","박지원","이해찬","강기정","김회선",
                          "박인숙","서병수","심재철","반기문","김수한",
                          "노수희","강수진","김현희","김광진","김성용",
                          "국가정보원","민주당","새누리당","한나라당",
                          "참여정부","이명박정부","국민의정부","통진당","정의당",
                          "대한민국","일본","북한","러시아","쿠릴열도",
                          "TV토론","경제민주화","선대위원장","경기동부",
                          "선대위","양자 대결","단일화","비대위",
                          "비대위원회","선관위","선관위원장","최고위원회의",
                          "비상대책위원장","고착화","종북","주사파",
                          "먹튀방지법","건보료","거제도","건보공단",
                          "당헌","당규","당헌당규","국회법","서포터즈",
                          "당원","트렌드","소상공인",
                          "떠벌림","북남선언","아연실책","수행부단장",
                          "국정원","투표시간","프라이머리"),c("ncn")))

#겹치는 단어들 대체
texts<- gsub("야권 단일화", "단일화", texts)
texts<- gsub("국정원", "국가정보원", texts)
texts<- gsub("국민경선제", "프라이머리", texts)
texts<- gsub("완전국민경선제", "프라이머리", texts)
texts<- gsub("오픈프라이머리", "프라이머리", texts)
texts<- gsub("이명박근혜", "이명박 박근혜", texts)
texts<- gsub("투표 시간", "투표시간", texts)
texts<- gsub("이명박 정부", "이명박", texts)
texts<- gsub("이명박 정권", "이명박", texts)
texts<- gsub("국민의 정부", "김대중", texts)
texts<- gsub("문 후보", "문재인", texts)
texts<- gsub("문 의원", "문재인", texts)
texts<- gsub("민주통합당", "민주당", texts)
texts<- gsub("안 후보", "안철수", texts)
texts<- gsub("안 교수", "안철수", texts)
texts<- gsub("안 원장", "안철수", texts)
texts<- gsub("안 전 후보", "안철수", texts)
texts<- gsub("박 후보", "박근혜", texts)
texts<- gsub("통합진보당", "통진당", texts)
texts<- gsub("진보정의당", "정의당", texts)
texts<- gsub("진보당", "통진당", texts)
texts<- gsub("중앙선관위", "선관위", texts)
texts<- gsub("일본의", "일본", texts)
texts<- gsub("대통령의", "대통령", texts)

#불용어사전
stopwordsmain=c("가","오전","대해","가서","저희들이","나아","가운데","당초","해지","있다고","이외", "갈", "갑", "걔", "거", "건","걸", "것","게", "겨", "겸", "겹", "경", "곁", "계", "고", "곱", "곳","곳곳", "저런","과", "곽", "굄", "구", "권", "그", "그간", "그것","그곳", "그녀", "그달", "그당시", "그대", "그대신","그동안", "그들", "그들대로", "그때", "그런고","그런", "그런날", "그런데서", "그런줄", "그럴수록", "그로", "그무렵", "그외","그이", "그전", "그전날", "그쪽", "근", "급", "깁", "깡", "꽝", "끗", "낌", "나", "낙", "낟", "낱", "내게", "내년초","내달", "내부", "냥", "너", "너나마", "너로", "너와", "너희", "너희대로", "너희들", "네", "네번", "네째", "네탓", "넷", "넷째", "년", "년간", "년도", "녘", "노", "놉", "누가", "누구", "누구누구", "누군가", "뉘", "닢", "다섯째", "다음달", "다음주", "닥", "답", "당분간", "대다수", "댁", "덤", "덧", "데", "돗", "되", "두", "둔", "둘", "둘째", "둥", "뒤", "뒷받침", "듯", "등", "따름", "따위", "딴", "때", "때문", "땡", "떼", "뜀", "런", "룰", "룸", "리", "릴", "마", "마련", "마리", "마지막", "마찬가지", "막", "만", "만원", "만원씩", "만큼", "맏", "맘", "맴", "메", "멸", "몇", "무엇", "묶음", "물론", "뭇", "뭣", "밑", "바", "밖", "백", "백만", "백만원", "밸", "번", "번째", "볏", "본", "봉", "분", "빈", "빔", "빽", "뻥", "뼘", "뿐", "사", "삭", "삵", "샅", "서", "서로", "석", "섟", "섶", "세", "세째", "셈", "셋", "셋째", "송", "수", "수십", "수십개", "숱", "쉬", "스스로", "승", "쌈", "쌍", "씀", "씹", "안", "앎", "압", "앵", "야", "얘", "어느편", "어디", "어디론지", "어떤때", "억원", "여", "여러가지", "여럿", "여섯째", "열째", "예", "예년때", "오", "온", "올", "올해", "옴", "옹", "왜", "요즘", "우", "우리", "우리들", "우선",  "운운", "움", "움직임", "위해서", "유", "육", "율", "으뜸", "을", "음", "이것", "이곳", "이기", "이날", "이달", "이달초", "이듬", "이듬달", "이때", "이런","이런저런","이런줄", "이번", "이번분", "일곱째", "임", "잇", "작",  "잔", "잘", "잭", "잽", "쟁", "쟤", "저것", "저곳",  "저기", "저기대", "저긴", "저도", "저런날", "저런줄","저렴", "저마", "저쪽", "저하", "저희", "적극적", "전날", "전년", "전부", "전부문", "전일", "전체적", "절절", "접", "제", "제나름", "존", "좆", "좌", "죄", "줄곳", "줌", "중점적", "쥔", "증", "지", "지난해", "직", "짓", "쪽",  "찬", "채", "챙", "척", "천만", "천명", "천원", "첫날", "첫째", "촉", "최", "최근", "충", "취", "층", "치", "칭", "칸", "캡", "컷", "켜", "콕", "쾌", "쿡", "크기", "큰폭","킥", "타", "탓", "태", "토", "톡", "톤", "톨", "톳", "퇴", "투", "퉁", "판", "패", "팽", "편", "평", "평상", "폼", "푸르름", "푼", "필", "하", "하나", "하나둘", "한", "한가운데", "한가지", "한곳", "한마디", "한번", "한쪽", "한편", "할", "합", "항", "행", "향후", "허", "혁", "현", "호", "홉", "홍", "홑", "화", "확", "환", "황", "홰", "획", "횡", "후", "훅", "휘", "흑", "힐","하게","하기","들이","관련","해서","이번","때문","금일","가지","비롯","아래","오후","이것","그것","어제","이후","동안","일정","정도","불구","하시","하자","라고","여기","저기","당시","결과")

#직접 돌려보며 찾아낸 정치 분야에 해당하는 불용어들(주로 직위 중심)
stopwordspoli = c("후보","다음","하게","들이","하기","대통령",
                  "오늘","관련","자리","의원","의원님","생각","말씀","해서","브리핑",
                  "중앙","선거대책","대변인","위원회","문제","대변인실",
                  "수석","대표","선거","우리","이번","때문","이상","대선",
                  "국민","주요내용","금일","나라","가지","캠프","비롯",
                  "이야기","원내","위원장","아래","오후","최고위원","지도",
                  "얘기","수석부대변인","내용","이것","그것","무엇","모습",
                  "여러분","경우","황천모","과정","어제","이후","동안",
                  "일정","정도","이유","대표최고위원","의미","불구",
                  "모두","하시","부대변인","하자","당의","확인","라고",
                  "여기","조윤선","당시","필요","부분","결과","입장",
                  "발표","국회의원","시장","수행부단장","비상대책위",
                  "비대위","비대","위원","원회","굴림","최고위원회의",
                  "대통령후보자","당선인","대통","박용진","서면","제차",
                  "정성호","추가","제대","김현","단장","진선미")


ko.words <- function(texts){
  texts <- as.character(texts)
  extractNoun(texts)
}


cps <- Corpus(VectorSource(texts))


tdmt1<-Sys.time()
#tdm생성
tdm=TermDocumentMatrix(cps,
                       control=list(tokenize=ko.words,
                                    removeNumbers=T,
                                    removePunctuation=T,
                                    wordLengths=c(2, 15),
                                    stopwords = c(stopwordsmain, stopwordspoli)))
tdmt2<-Sys.time()
tdmt<-tdmt2-tdmt1


#dtm

dtm=DocumentTermMatrix(cps,
                       control=list(tokenize=ko.words,
                                    removeNumbers=T,
                                    removePunctuation=T,
                                    wordLengths=c(2, 15),
                                    stopwords = c(stopwordsmain, stopwordspoli),
                                    weighting = weightTfIdf))


#사용횟수구하기
word.count = as.array(rollup(tdm, 2))


#내림차순 정리
word.order = order(word.count, decreasing = T)
freq.word = word.order[1:30]
row.names(tdm[freq.word,])

#LSA준비작업

word.count = as.array(rollup(tdm, 2))
word.order = order(word.count, decreasing = T)
freq.word = word.order[1:4000]

write.csv(row.names(tdm[freq.word,]), "새누리단어목록.csv")

#Latent Semantic Analysis

library(lsa)
library(GPArotation)

#모든 데이터를 30개 차원으로 축소

news.lsa = lsa(tdm[freq.word,], 30)
news.lsa$tk[,1]

#회전시키기
tk = varimax(news.lsa$tk)$loadings


for(i in 1:30){
  print(i)
  importance = order(abs(tk[,i]), decreasing = T)
  print(tk[importance[1:10], i])
}

row.names(tdm[freq.word[1:100],])



#가중치 줘서 살펴보기

tdm.mat = as.matrix(tdm[freq.word,])
tdm.w = lw_logtf(tdm.mat) * gw_idf(tdm.mat)

weightedlsa = lsa(tdm.w, 30)


#회전시키기
library(GPArotation)
tk = varimax(weightedlsa$tk)$loadings


for(i in 1:30){
  print(i)
  importance = order(abs(tk[,i]), decreasing = T)
  print(tk[importance[1:10], i])
}

row.names(tdm[freq.word[1:100],])


#코사인유사도
doc.space=t(tk) %*% tdm.mat
norm = sqrt(colSums(doc.space ^ 2))
norm.space<-sweep(doc.space, 2, norm, '/')


#Latent Dirichlet Allocation


library(topicmodels)
library(lda)


dtm = as.DocumentTermMatrix(tdm[freq.word,])


ldaform = dtm2ldaformat(dtm, omit_empty = T)

alpha=0.02
eta=0.02


t1 <- Sys.time()
result.lda=lda.collapsed.gibbs.sampler(documents=ldaform$documents, 
                                       K=20, vocab=ldaform$vocab, 
                                       num.iterations=3000, 
                                       burnin=1000, 
                                       alpha=alpha, 
                                       eta=eta)
t2 <- Sys.time()
ldat<-t2 - t1
ldat

summary(result.lda)
View(top.topic.words(result.lda$topics))
topicsandwords<-top.topic.words(result.lda$topics)
write.csv(topicsandwords, "새누리토픽.csv", row.names=F,fileEncoding="UTF-8")


#LDAvis

documents<-ldaform$documents
vocab<-ldaform$vocab

get.terms <- function(x) {
  index <- match(x, vocab)
  index <- index[!is.na(index)]
  rbind(as.integer(index - 1), as.integer(rep(1, length(index))))
}

doc.length <- sapply(documents, function(x) sum(x[2, ]))  # number of tokens per document [312, 288, 170, 436, 291, ...]
term.frequency<-word.count[ldaform$vocab[1:5000]]



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

serVis(json, out.dir = '새누리당', open.browser = T)


