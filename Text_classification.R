#### 스팸/햄 분류 ####
library(tidyverse)
# 스팸/햄 메시지가 구분되어 있는 텍스트파일 불러오기
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/00228/smsspamcollection.zip"

# R에서 작업할 임시파일 생성
# 작업 후엔 unlink()함수로 삭제할거임
local.copy <- tempfile()

download.file(url, local.copy, mode="wb")

# 파일을 데이터프레임 형식으로 저장할 떄 필요한 패키지와 함수는
# readr::read_delim
unzip(zipfil=local.copy, files="SMSSpamCollection") %>% # 압축해제하고, 경로를 리턴
read_delim(delim="\t",   # 타입과 텍스트는 탭으로 구분
           quote="",     # ???
           col_types=cols("f", "c"),     # 첫번째 열은 메시지의 유형이니까 factor로 읽어라
                                         # 두번째 열은 메시지니까 charactor로 읽어라
           col_names=c("type", "text")) -> sms  # 열이름

?read_delim # 임의의 구분자로 된 파일을 읽는다
sms

table(sms$type)

table(sms$type) %>% 
  prop.table


# 텍스트분석을 통해 스팸문자와 정상문자 사이의 차이를 탐색해보자
# 텍스트분석을 위해 코퍼스객체로 변환
library(tm)
?DataframeSource

library(dplyr)
library(tibble)
?select
sms <- sms %>% 
  dplyr::select(text, type) %>% # 위치조정
  add_column(doc_id=1:nrow(.), .before=1) %>%  # 열 새로 만들고, 기존데이터의 맨 앞으로 
  mutate(text=iconv(text, to="ascii", sub="")) # 모든 텍스트를 아스키 코드로 바꿈으로써 혹시 있을 문자깨짐현상을 방지
                                               # sub="" : 아스키코드로 안바뀌는 문자는 삭제해라
sms

# 다이아몬드 연산자! 할당까지 한번에 
library(magrittr)
sms %<>%  
  dplyr::select(text, type) %>% # 위치조정
  add_column(doc_id=1:nrow(.), .before=1) %>%  # 열 새로 만들고, 기존데이터의 맨 앞으로 
  mutate(text=iconv(text, to="ascii", sub="")) # 모든 텍스트를 아스키 코드로 바꿈으로써 혹시 있을 문자깨짐현상을 방지
# sub="" : 아스키코드로 안바뀌는 문자는 삭제해라
sms


sms.copus <- VCorpus(DataframeSource(sms))
sms.copus

lapply(docs, content)
lapply(docs, content)[c(13,16,20)]
meta(docs)$type[c(13,16,20)]


# 없애주는 함수
myRemove <- content_transformer(function(x, pattern)
  {return(gsub(pattern, "", x))})
mystopwords <- c(stopwords("en"),
                 c("can", "cant", "don", "dont", "get", "got", "just", "one", "will"))

# 공백으로 바꿔주는 함수
toSpace <- content_transformer(function(x, pattern)
  {return(gsub(pattern, " ", x))})

docs %<>%
  tm_map(content_transformer(tolower)) %>% 
  tm_map(myRemove, "(f|ht)tp\\S+\\s*") %>% 
  tm_map(myRemove, "www\\.+\\S+") %>% 
  tm_map(removeWords, mystopwords) %>% 
  tm_map(removePunctuation) %>% 
  tm_map(toSpace, ":") %>% 
  tm_map(toSpace, ";") %>% 
  tm_map(toSpace, "/") %>%
  tm_map(removePunctuation) %>% 
  tm_map(removeNumbers) %>% 
  tm_map(stripWhitespace) %>% 
  tm_map(content_transformer(trimws)) %>% 
  tm_map(stemDocument)
lapply(docs, content)[1:5] 
  

# 코퍼스로 dtm만들기
dtm <- DocumentTermMatrix(docs)
dtm

inspect(dtm)
# 너무 짧거나 긴 단어, 너무 많이 등장하거나 적게 등장하는 단어 없애주기
dtm <- DocumentTermMatrix(docs,
                          control=list(wordLengths=c(4,10),
                                       bounds=list(global=c(5,5300))))
dtm 

# 각 단어별 출현빈도
as.matrix(dtm) %>% 
  colSums -> termFreq

termFreq
str(termFreq)

order(termFreq, decreasing=T)[1:5]

findFreqTerms(dtm, lowfreq=200) # 200번 이상 출현 단어

# findAssocs() # 인수로 주어진 단어와 일정 수준 이상의 상관관계를 갖는 단어를 리턴
findAssocs(dtm, c("call", "free"), 0.2) # 상관계수 0.2 이상


# 워드클라우드
library(wordcloud)
library(RColorBrewer) # 팔레트

set.seed(123)
# 새로운 창에 워드클라우드 그려봐야지
windows(width=7, height=7)

wordcloud(words=names(termFreq), freq=termFreq,
          scales=c(4,0.5), 
          min.freq=30,
          max.words=200,
          rot.per=0,
          random.order = F,
          random.color = F,
          colors=brewer.pal(6, "Set2"))

# 스팸과 정상메시지의 워드클라우드를 비교해보자
# 왜? 빈번하게 출현하는 단어가 다르면, 이거를 분류에 이용할 수 있으니까
# 비교를 위한 워드클라우드 : comparison.cloud()
??comparison.cloud
# 행에는 단어, 열에는 범주(문서), 셀값은 출현빈도를 나타내는 매트릭스가 필요함
dtm
as.matrix(dtm) -> hamspam
hamspam
# 행은 문서, 열은 단어인 행렬
# 우선 행이름에 문서대신 범주를 부여
rownames(hamspam) <- sms$type
hamspam[1:5, 1:5]
# 단어별로 햄이 몇개, 스팸이 몇개인지 합을 계산
# 행합계함수 : rowsum()
hamspam <- rowsum(hamspam, group=rownames(hamspam))
hamspam[, 1:5]
# 이 행렬을 전치시키면 행에는 단어, 열에는 범주, 셀값은 출현빈도인 매트릭스가 만들어진다
t(hamspam)

set.seed(123)
windows(width=7, height=7)

t(hamspam) %>% 
  comparison.cloud(colors=c("cornflowerblue", "tomato"),# 햄은 파란색, 스팸은 빨간색
                   title.size = 2,
                   title.colors = c("blue", "red"),
                   title.bg.colors = "wheat",
                   rot.per = 0,
                   scale = c(5, 0.4),
                   max.words = 200) 




#### 예측모델 개발 - 나이브베이즈 ####
# 예측변수는 문서로부터 추출한 단어(범주형으로 변환 필요)
# 결과변수는 스팸/햄(범주형)
?naiveBayes
# 나이브베이즈 분석을 수행하기 위해서는 예측변수가 범주형 행렬이나 데이터프레임형식이어야 하고
# 결과변수도 범주형 벡터여야 함.

inspect(dtm) # 지금 예측변수는 문서-용어 행렬에 저장되어 있다.
sms # 결과변수는 sms$type에 저장되어 있음

# 문서용어행렬에 저장된 예측변수와, 데이터프레임에 저장된 결과변수를 이용해서 나이브베이즈분석을 수행

# 먼저 결과변수(팩터) 데이터셋을 훈련/테스트데이터로 분할
set.seed(123)
train <- sample(nrow(sms), 0.7*nrow(sms))
y.train <- sms[train,]$type
y.test <- sms[-train,]$type

table(y.train) %>% prop.table
table(y.test) %>% prop.table


# 예측변수 데이터셋을 훈련/테스트데이터로 분할하기 전에 나이브베이즈에 적합한 형태로 변환
# 나이브베이즈는 일반적으로 범주형 예측변수를 바탕으로 예측모델을 개발
# 현재 예측변수의 값은 출현빈도이기 때문에 이를 범주형 값으로 변환할 필요
# 단어가 등장하면 1, 안하면 0으로 바꿔줄 필요가 있음
# 팩터로 바꿔주는 함수
toFactor <- function(x) {
  x <- ifelse(x > 0, 1, 0)
  x <- factor(x, level=c(0,1), labels=c("no", "yes"))
  return(x)
}

sms.dtm <- dtm %>% 
  apply(MARGIN=2, toFactor) #MARGIN=1 행방향 적용, 2 열방향 적용

str(sms.dtm)
sms.dtm[1:5, 1:5]

# 이제 훈련데이터와 테스트데이터로 분할
x.train <- sms.dtm[train, ]
x.test <- sms.dtm[-train, ]



# 나이브 베이즈 분석 시행
# 
library(e1071)
sms.nb <- naiveBayes(x=x.train,
                     y=y.train)

sms.nb.pred <- sms.nb %>% 
  predict(newdata=x.test)

table(y.test, sms.nb.pred, dnn=c("Actual", "Predicted"))






#### ttf로 ####
library(tidytext)

sms.tt <- sms %>% 
  unnest_tokens(word, text)

# 전처리 
# 1.불용어 없애주기 
# 2.특수문자 없애기
# 3.숫자없애기
# 4.어간추출 대신 형태소분석
# 너무 짧거나 긴 단어, 너무 많이 등장하거나 적게 등장하는 단어 없애주기
# 4글자~10글자
# 5번~1000번
mystopwords <- c(stopwords("en"),
                 c("can", "cant", "don", "dont", "get", "got", "just", "one", "will"))
st <- tibble(mystopwords)
colnames(st) <- "word"


sms.tt %<>%
  filter(word != "\\d+") %>%      # 숫자 없애줘
  filter(word != "[:pucnt:]") %>% # 특수문자 없애줘
  anti_join(st) %>%               # 마이 불용어 제거
  filter(n >= 5 & n <= 1000) %>%  # 너무 많이 또는 적게 등장하는 단어 없애줘
  filter(nchar(.$word) >= 4 & nchar(.$word) <= 10)  # 글자수 조정
sms.tt

