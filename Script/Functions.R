#파일 읽어오기

partydata=function(partyname){
  partyname<-deparse(substitute(partyname))
  samewords=function(texts){
    texts<- gsub("야권 단일화", "단일화", texts)
    texts<- gsub("국정원", "국가정보원", texts)
    texts<- gsub("국민경선제", "프라이머리", texts)
    texts<- gsub("완전국민경선제", "프라이머리", texts)
    texts<- gsub("오픈프라이머리", "프라이머리", texts)
    texts<- gsub("남북정상회담", "정상회담", texts)
    texts<- gsub("한나라당", "새누리당", texts)
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
    texts<- gsub("여성의", "여성", texts)
    texts<- gsub("상인들", "상인", texts)
    texts<- gsub("어르신들", "어르신", texts)
    texts<- gsub("다음과 같이","", texts)
    texts<- gsub("한국의","한국", texts)
    texts<- gsub("제주해군기지","해군기지", texts)
    texts<- gsub("제주 해군기지","해군기지", texts)
    texts<- gsub("쌍용자동차","쌍용차", texts)
    texts<- gsub("수행단장","", texts)
    texts<- gsub("박대출","", texts)
    texts<- gsub("민통당","민주당", texts)
    texts<- gsub("들이","", texts)
    texts<- gsub("따르면","", texts)
    texts<- gsub("드린다","", texts)
    texts<- gsub("필요한","필요", texts)
    texts<- gsub("국민적","국민 ", texts)
    texts<- gsub("결과적","결과 ", texts)
    texts<- gsub("안철수씨","안철수", texts)
    texts<- gsub("민주캠프","민주당", texts)
    texts<- gsub("문재인캠프","민주당", texts)
    texts<- gsub("시민캠프","민주당", texts)
    texts<- gsub("논문표절","논문 표절", texts)
    texts<- gsub("굴림","", texts)
    return(texts)
  }
  
  if(partyname=='min'){
    min <- read.csv("민주당.csv", fileEncoding="UTF-8", header=TRUE, quote="\"",stringsAsFactors = FALSE)
    min<-min[,3]
    min<-unique(str_replace_all(min,"[^가-힣]+"," "))
    minjoo<-as.character()
    for(i in min){
      if(nchar(i)>=200){
        minjoo=c(minjoo,i)
      }
    }
    texts<-minjoo
    texts<-samewords(texts)
  }
  if(partyname=='sae'){
    sae <- read.csv("새누리당.csv", fileEncoding="UTF-8", header=TRUE, quote="\"",stringsAsFactors = FALSE)
    sae<-sae[,3]
    
    sae<-unique(str_replace_all(sae,"[^가-힣]+"," "))
    saenuri<-as.character()
    for(i in sae){
      if(nchar(i)>=200){
        saenuri=c(saenuri,i)
      }
    }
    texts<-saenuri
    texts<-samewords(texts)
  }
  return(texts)
}


#형태소분리

library(KoNLP)
#개별 문서로 분리해서 처리하려다 문제 생겨서 개별 단어로 분리하는 전략 채택
#전체 문서를 단어로 분리해서 처리하는 방법 가능한지 찾아봐야. 시간 더 줄어들 가능성 있음.
#정규식 파트 추가적으로 고려해 볼 필요 있음. 특히 의존명사(NB)의 경우 '해를 주다'와 같은
#명사들을 포괄하기 위해서는 반드시 들어가야 함.
#세종사전업데이트
useSejongDic()
mergeUserDic(data.frame(c("문재인","이정희","황천모","안철수","노무현","김종인",
                          "이명박","신경민","정성호","김진표","황우여","송영길",
                          "심상정","박지원","이해찬","강기정","김회선","모바일",
                          "박인숙","서병수","심재철","반기문","김수한","김영환",
                          "노수희","강수진","김현희","김광진","김성용","김정은",
                          "조윤선","이시형","박용진","정성호","박대출","박선규",
                          "국가정보원","민주당","새누리당","한나라당",
                          "참여정부","이명박정부","국민의정부","통진당","정의당",
                          "대한민국","일본","북한","러시아","쿠릴열도",
                          "TV토론","경제민주화","선대위원장","경기동부",
                          "선대위","양자 대결","단일화","비대위","제주도",
                          "비대위원회","선관위","선관위원장","최고위원회의",
                          "비상대책위원장","고착화","종북","주사파","학생",
                          "먹튀방지법","건보료","거제도","건보공단","강탈",
                          "당헌","당규","당헌당규","국회법","서포터즈",
                          "당원","트렌드","소상공인","이명박근혜","시당",
                          "떠벌림","북남선언","아연실책","수행부단장",
                          "국정원","투표시간","프라이머리","여성",
                          "말바꾸기","친노","국민대통합"),c("ncn")))

options(java.parameters = "-Xmx8g")

stopwords <- tolower(str_replace_all(read.csv("Data/stopwords.csv", quote="\"", stringsAsFactors=FALSE, header=F)[,1],"/",""))
newstopwords=c("조윤선nc","나pv","들pv","총선nc","선대위nc","우리nc","관련해nc","정론관nc","지금까지nc",
               "보이nc","그러하pa","대변인실nc")
stopwords<-c(stopwords,newstopwords)


ko.words <- function(texts){
  token<-as.character()
  for(i in texts){
    d <- as.character(i)
    splited<-unlist(str_split(d," "))
    for(j in splited){
      j<-as.character(j)
      pos <- paste(SimplePos22(j))
      extracted <- str_match(pos, '([가-힣]+)/([NP][ACV])')
      keyword <- extracted[,1]
      if(is.na(keyword)){next}
      if(str_detect(keyword,'[가-힣]/[NC]') & nchar(keyword)==4){next}
      #KoNLP 특성상 ~~들 형태의 명사를 잘 구분해 내지 못하는 한계가 있기 때문에 ~들 제거. 
      #정규식 사용해 한글 2글자 이상과 '들'이 붙어있는 경우를 골라내고
      if(str_detect(keyword,"[가-힣]{2,}들/[NC]")){
        #'들'에 따라서 문자열을 나눠버린 다음 다시 합침(단순히 str_replace를 쓸 경우 문제 발생)
        keyword<-str_replace_all(keyword,"들","")
      }
      token<-c(token, keyword[!is.na(keyword)])
    }
  }
  token
}


tokenizeforw2v<-function(texts, filename){
  i=1
  for(j in texts){
    texts[i]=
    ko.words(j)%>%
    str_replace_all("\\/","")%>%
    tolower()%>%
    paste(collapse=" ")
    i=i+1
  }
  write.csv(texts, paste0(filename,'.txt'), row.names=F)
}

