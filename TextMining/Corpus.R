#### 코퍼스형식의 데이터 살펴보기 ####
library(tidyverse)
# install.packages("tm")
library(tm)
data(crude)

crude
# 원유에 대한 뉴스기사를 코퍼스 형식으로 제공
# <<VCorpus>> : 객체이름
# Metadata
# Content:  documents: 20 # 뉴스기사 20개
# 코퍼스는 각 문서별로 텍스트, 메타데이터를 보관

# 아무것도 안보임
# 내용물 보려면 
crude[[1]] # 첫번째 문서
           # 527개의 문자로 구성된 텍스트
crude[[1]]$content
crude[[1]]$meta



#### 데이터를 코퍼스 형식으로 만들기 ####
text <- c("Crash dieting is not the best way to lose weight. http://bbc.in/1G0J4Agg",
          "A vegetarian diet exclueds all animal flesh(meat, poultry, seafood).",
          "Economists surveyed by Refinitiv expect the economy added 160,000 jobs.")

# 문자벡터 형식으로부터 코퍼스를 만드는 것이 시작

tm::VCorpus()
# 다양한 소스로부터 읽어들인 텍스트를 코퍼스 형식으로 변환해주는 함수
# 텍스트가 저장되어 있는 소스에 대응되어 있는 함수를 사용해야 함
# 소스별 대응 함수는 getSources()를 이용해서 확인
getSources()
# [1] "DataframeSource" 
# [2] "DirSource"  
# [3] "URISource"      
# [4] "VectorSource"   
# [5] "XMLSource"      
# [6] "ZipSource"

corpus.docs <- VCorpus(VectorSource(text))
class(corpus.docs) # 코퍼스 객체로 바귐

# 코퍼스의 요약정보를 얻으려면
corpus.docs
inspect(corpus.docs[1])
inspect(corpus.docs[[1]]) # 좀 더 자세한 정보

# 문서의 텍스트를 보고싶으면 
corpus.docs[[1]] %>% as.character 

# 모든 문서의 텍스트를 한번에 보고싶으면
corpus.docs %>% lapply(as.character)

# 코퍼스는 리스트 형식의 중첩된 구조를 갖는다
# 두 개의 원소(content, meta)를 갖는 리스트
# content -> 텍스트의 실제 내용
# meta -> 메타데이터
str(corpus.docs)
corpus.docs[[1]]$content
lapply(corpus.docs, content)
?lapply
lapply(corpus.docs, content) %>% unlist %>% as.vector %>% paste(collapse = " " )




#### 메타데이터 ####
corpus.docs[[1]]$meta

# 메타데이터 항목은 사전에 설정되어 있음
# 항목별 추출하려면 meta() 이용
meta(corpus.docs[[1]], tag="datetimestamp")

# 메타데이터에 빈 항목을 채우고 싶을 떄
meta(corpus.docs[[1]], tag="author")
meta(corpus.docs[[1]], tag="author", type="local") <- "BBC"
# type="local" 메타데이터가 각 개별 문서에 저장
# type="corpus" 메타데이터가 코퍼스 전체에 저장 
meta(corpus.docs[[1]])


# 모든 문서에 각각의 내용을 한번에 채우고 싶을 때
source <- c("BBC", "CNN", "FOX")
meta(corpus.docs, tag="author", type="local") <- source
lapply(corpus.docs, meta, tag="author") 
?lapply

# 메타데이터에 항목을 추가하기
category <- c("health", "lifestyle", "business")
meta(corpus.docs, tag="category", type="local") <- category
lapply(corpus.docs, meta, tag="category")

# 메타데이터 항목을 지우기
# 항목을 NULL값으로 변경하면 된다.
meta(corpus.docs, tag="origin", type="local") <- NULL
lapply(corpus.docs, meta)




#### 코퍼스에서 추출하기 ####
# 코퍼스에서 조건을 만족하는 문서 추출하기
# 01.tm_filter()

corpus.docs.filtered <-
  tm_filter(corpus.docs,
            FUN=function(x)
              any(grep("weight|diet", content(x))))
lapply(corpus.docs.filtered, content)
?grep
?content
?any

# 02.필터링조건을 충족하는 인덱스를 생성해서 필터링
idx <- meta(corpus.docs, "author")=="FOX" | meta(corpus.docs, "category")=="health"
lapply(corpus.docs[idx], content)


# 코퍼스를 파일로 저장하기 ####
writeCorpus(corpus.docs)
list.files(pattern="\\.txt")
# 각 문서당 한개의 텍스트파일이 생성되었음



#### 텍스트 가공하기 ####
# tm패키지
getTransformations() # 함수보기

# [1] "removeNumbers"    
# [2] "removePunctuation"
# [3] "removeWords"      
# [4] "stemDocument"     
# [5] "stripWhitespace" -> tm_map()과 함께 이용
?tm_map

# 대문자, 소문자 통일
toupper()
tolower() # 코퍼스 객체에 그대로 사용할 수 없음  
          # 코퍼스객체를 다루는 함수는 따로 있다.
content_transformer() # 얘와 함께 사용
                      # 코퍼스 객체를 다룰 수 있는 함수로 변환해주는 함수

corpus.doc <- tm_map(corpus.docs, content_transformer(tolower))
lapply(corpus.doc, content)



#### 불용어 제거 ####
# a, the, and, but, is, are, have, may, this, that, he, she -> 불용어
# 불용어 리스트
stopwords("english")
?tm_map
corpus.docs <- tm_map(corpus.docs, removeWords, stopwords("en"))
lapply(corpus.docs, content)


#### 불필요한 문자열 삭제(사용자정의함수) ####
# 코퍼스객체를 다루는 함수는 따로 있다.
# x문자열에서 패턴에 대응되는 부분을 찾아서 삭제하는 함수 만들기 
myRemove <- content_transformer(function(x, pattern)
  {return(gsub(pattern, "", x))})
# 텍스트의 url을 제거 
text
corpus.docs <- tm_map(corpus.docs, myRemove, "(f|ht)tp\\S+\\s*") # ftp나 http로 시작하고 스페이스를 제외한 어떤 문자든 하나 이상 오고, 스페이스문자가 다수 와도 되는 패턴
lapply(corpus.docs, content)

# 텍스트의 문장부호를 제거
corpus.docs <- tm_map(corpus.docs, removePunctuation)
lapply(corpus.docs, content)

# 텍스트의 숫자를 제거 
corpus.docs <- tm_map(corpus.docs, removeNumbers)
lapply(corpus.docs, content)

# 공백 제거
corpus.docs <- tm_map(corpus.docs, stripWhitespace)
lapply(corpus.docs, content)

# 맨 앞과 맨 뒤의 공백 제거
corpus.docs <- tm_map(corpus.docs, content_transformer(trimws))
lapply(corpus.docs, content)


# 어간추출작업
# 형태는 다르지만 의미상 동일한 경우 하나의 공통 어간으로 대체
# 원래 단어 고유의 형태를 잃어버리는 단점
install.packages("SnowballC")

corpus.docs <- tm_map(corpus.docs, stemDocument)
lapply(corpus.docs, content)

# stemDocument가 놓친 것은 내가 스스로 할 수 있다
tm_map(corpus.docs, content_transformer(gsub), 
       pattern="economist", replacement="economi")
lapply(corpus.docs, content)
?gsub
