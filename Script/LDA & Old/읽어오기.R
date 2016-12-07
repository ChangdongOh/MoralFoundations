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
