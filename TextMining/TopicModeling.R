library(textdata)

news <- dataset_ag_news(split="test")
news

table(news$class)

# topicmodels::LDA() 사용 <- 이 함수는 DTM을 필요로한다.
# 데이터셋을 코퍼스로 바꾸고, DTM으로 바꿔준다.
install.packages("topicmodels")
library(topicmodels)
library(tm)
docs <- VCorpus(VectorSource(news$description))

lapply(docs,content)[1:3]

# 전처리
myRemove <- content_transformer(function(x, pattern)
  {return(gsub(pattern, "", x))})
toSpace <- content_transformer(function(x, pattern)
  {return(gsub(pattern, " ", x))})
# :이나 ,으로 연결되어 있는 단어를 그냥 지우는 것 보다 공백으로 만들어 주는 게, 단어분석에 용이
mystopwords <- c(stopwords("english"),
                 c("first", "second", "one", "two", "three", "last", "least", "just", "ago", "day", "will", "can", "and",
                   "said", "yesterday", "people", "said", "new", "monday", "tuesday", "thursday", "wednesday",
                   "year", "friday", "next", "week", "today", "game", "sunday", "world", "reuters", "quot","time","night",
                   "saturday", "four", "states", "york", "percent", "may", "says"))
library(tidyverse)

docs <- docs %>% 
  tm_map(content_transformer(tolower)) %>% 
  tm_map(myRemove, "(f|ht)tp\\S+\\s*") %>% 
  tm_map(myRemove, "www\\.+\\S+") %>% 
  tm_map(removeWords, mystopwords) %>% 
  tm_map(toSpace, ":") %>% 
  tm_map(toSpace, ";") %>% 
  tm_map(toSpace, "/") %>% 
  tm_map(toSpace, "\\.") %>% 
  tm_map(toSpace, "\\\\") %>% 
  tm_map(removePunctuation) %>%
  tm_map(removeNumbers) %>%
  tm_map(stripWhitespace) %>% 
  tm_map(content_transformer(trimws))

lapply(docs, content)[1:3]

dtm <- DocumentTermMatrix(docs)
inspect(dtm)

# 토픽모델링 결과와 비교하기 위해 카테고리명을 미리 삽입해놓기
# 실제에서 토픽이 얼마나 잘 분석되었는지는 분석자의 주관적 판단에 의존하는 경우가 많음
rownames(dtm) <- paste0(rownames(dtm), "-", news$class)
inspect(dtm)
?paste0


# 토픽추출
library(topicmodels)
news.lda <- LDA(dtm, k=4, method="Gibbs", # 문서용어행렬, 토픽개수, 사용빈도높은 Gibbs방법
                control=list(seed=123, 
                             burnin=1000,     # 1000번까지는 사용하지 않고 버린다.
                             iter=1000,       # 샘플링반복
                             thin=100))       # 매100번쨰 결과가 다음 샘플링을 위해 사용됨
class(news.lda)

# 뉴스기사별 대표 토픽확인 
# 대표 토픽:가장 높은 확률의 토픽
topics(news.lda) %>% head
topics(news.lda) %>% table

# 토픽별 대표단어 확인
terms(news.lda, 10)

# 정보 확인
str(news.lda, max.level = 2, nchar.max = 50)
# 핵심정보는 beta, gamma 안에 있다
# @ beta           : num [1:4, 1:20387] -12.8 -10.4 -12.8 -12.8 -12.8 ...
# 단어와 토픽 간의 관계, 확률, 베타확률
# 4개의 토픽, 20387개의 단어, 각 단어별 토픽과의 관련성을 보여줌
# 각 토픽으로부터 특정 단어가 생성될 확률 = 특정 단어가 각 토픽에서 출현할 확률
# @ gamma          : num [1:7600, 1:4] 0.246 0.201 0.25 0.243 0.276 ...
# 문서와 토픽 간의 관계, 확률, 감마확률, 
# 7600개의 문서, 4개의 토픽, 각 뉴스기사의 각 토픽과의 관련성
# 


# 베타
news.lda@beta[, 1:5]
# 네개의 토픽과 다섯개 단어 
# 셀값은 토픽과 단어의 관계를 보여주는 확률값(로그값)
?exp
exp(news.lda@beta[, 1:5])
# 토픽별 발생확률이 가장 높은 상위 다섯개 단어를 추출해서 그래프 그려보기
library(tidytext)
news.term <- tidy(news.lda, matrix="beta")
news.term

library(dplyr)
news.term.top <- news.term %>% 
  group_by(topic) %>% 
  top_n(5, beta) %>% 
  ungroup() %>% 
  arrange(topic, -beta)
news.term.top

library(ggplot2)
ggplot(news.term.top, 
       aes(reorder(term, beta), beta, fill=factor(topic)))+
  geom_col(show.legend = F)+
  facet_wrap(~ paste("Topic", topic), scales="free")+
  labs(x=NULL, y="word-Topic Probability(Beta)")+
  coord_flip()

# 감마
# 각 토픽이 문서에 할당될 확률, 즉 문서의 토픽 구성비율을 확인

# 처음 다섯개 뉴스기사가 네 개의 토픽에 구속될 확률
news.lda@gamma[1:5, ]

news.doc <- tidy(news.lda, matrix="gamma")
news.doc

# document    topic gamma
# <chr>       <int> <dbl>
#   1 1-Business      1 0.246
# 첫번째 기사가 토픽1로 지정될 확률이 0.246
# 첫번째 기사가 토픽1에 속하는 단어의 24.6%정도를 포함하고 있다는 뜻



# 토픽모델링 결과와 원래 카테고리가 얼마나 일치하는지 살펴보자
library(tidyr)
news.doc <- news.doc %>% 
  separate(document, c("id", "category"), sep="-", convert = T)
news.doc

# 카테고리별 토픽 분포 확인
ggplot(news.doc, 
       aes(x=factor(topic), y=gamma, fill=category))+
  geom_boxplot(color="gray50", show.legend = F)+
  facet_wrap(~ category, scales = "free")+
  labs(x="Topic", y="Document-Topic Probability (Gamma)")
