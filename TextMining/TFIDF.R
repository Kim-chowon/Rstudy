# install.packages("quanteda")
library(quanteda)
# 텍스트분석 함수, 데이터 제공, 인기있음

# 미국 역대 대통령 취임식 연설문
data_corpus_inaugural
summary(data_corpus_inaugural)
class(data_corpus_inaugural)
head(data_corpus_inaugural)

# 전처리를 위해 데이터 프레임으로 변환해서 사용
library(tidytext)
library(tibble)
library(dplyr)

# 코퍼스를 데이터프레임으로, 1990년 이후만, 대통령 별 하나의 연설문으로 
tidy(data_corpus_inaugural) %>% 
  filter(Year > 1990) %>% 
  group_by(President, FirstName) %>% 
  summarise_all(list(~trimws(paste(., collapse=" ")))) %>%  # 모든 변수에 함수 적용
                                                            # text를 붙이기 위해 paste
                                                            # 앞에서 넘겨받은 데이터 = .
                                                            # trimws() : 문장 앞뒤 공백 제거 
  arrange(Year) %>%  # 연도별로 나타내기
  ungroup() -> us.president.address

us.president.address
# 4개의 행 = 네명의 대통령의 연설문(들)
# 이제 이 텍스트데이터(티블)을 바탕으로 문서-용어 행렬만들고, 여러가지 빈도분석을 수행해보자.


# tm패키지의 Corpus로 바꾸기
library(tm)
?DataframeSource # 형식에 맞는 데이터프레임이 필요
us.president.address 

# text열을 두번째 열로 옮기고, doc_id열을 만들어야 한다
us.president.address <- us.president.address %>% 
  select(text, everything()) %>%  # 맨앞으로
  add_column(doc_id=1:nrow(.), .before=1)
# 4행1열짜리 데이터프레임 만들어서 cbind해도 될 것 같음

address.corpus <- DataframeSource(us.president.address) %>% 
  VCorpus

lapply(address.corpus[1], content)

# 전처리하기
stopwords
mystopwords <- c(stopwords("english"), c("can", "must", "will"))

address.corpus <- address.corpus %>% 
  tm_map(content_transformer(tolower)) %>% 
  tm_map(removeWords, mystopwords) %>% 
  tm_map(removePunctuation) %>% 
  tm_map(removeNumbers) %>% 
  tm_map(stripWhitespace) %>% 
  tm_map(content_transformer(trimws)) %>%   # 텍스트 앞 뒤 공백 제거
  tm_map(content_transformer(gsub), 
         pattern="america|americas|americans|americans",
         replacement="america")

lapply(address.corpus[1], meta)
lapply(address.corpus[1], content)

# 문서용어행렬 만들기
address.dtm <- DocumentTermMatrix(address.corpus)
inspect(address.dtm)
# 네개의 문서, 단어가 2316 추출
# 비어있는 셀은 62%, 5699셀이 비어있음


# 개별 단어의 출현 빈도는 각 열의 합계
termfreq <- as.matrix(address.dtm) %>% colSums

length(termfreq)

termfreq[order(termfreq, decreasing=T) %>% head]
termfreq[order(termfreq, decreasing=T) %>% tail]

findFreqTerms(address.dtm, lowfreq=40) # 40번 이상 출현 단어만
findFreqTerms(address.dtm, lowfreq=50, highfreq = 100) 

# 시각화(막대그래프)
library(ggplot2)
termfreq.df <- data.frame(word=names(termfreq), frequency=termfreq)
head(termfreq.df) # 단어와 빈도를 내용으로하는 데이터프레임

ggplot(subset(termfreq.df, frequency >= 40),
       aes(
         x = reorder(word, frequency),
         y = frequency,
         fill = word
       )) +
  geom_col(color = "dimgrey") +
  labs(x = NULL, y = "Term Frequency(count)") +
  geom_text(aes(label = frequency), size = 3.5, color = "black", hjust=2) +
  coord_flip()
# x=reorder(word, frequency) 단어의 출현빈도순으로 
# coord_flip() 수평으로
# hjust=2 라벨 위치 조정



# 워드클라우드
set.seed(123)
library(wordcloud)       
library(RColorBrewer)
# 단어의 이름과 출현빈도가 포함된 데이터가 필요
head(termfreq)

wordcloud(words=names(termfreq), freq=termfreq,
          scale=c(4,0.5),  # 단어 크기의 범위
          min.freq = 5,    # 최소5번 이상 출현 단어만
          rot.per=0,      # 수직으로 나타낼 단어 비율
          random.order = F, # 높은 빈도가 중앙에
          colors=brewer.pal(6, "Dark2"),
          random.color = F) # 빈도에 따라 색상 결정
          









# 대통령에 따라 사용한 단어의 차이
inspect(address.dtm)
rownames(address.dtm) <- c("Clinton", "Bush", "Obama", "Trump")
Docs(address.dtm)

# 타이디텍스트로 변환
address.tf <- tidy(address.dtm)
address.tf

# 가장 많이 사용된 단어 10개씩 추출
# 우선, 대통령을 팩터로 지정해주자
address.tf <- address.tf %>% 
  mutate(document=factor(document,
                         levels=(c("Clinton", "Bush", "Obama", "Trump")))) %>% 
  arrange(desc(count)) %>% # 단어의 출현빈도 내림차순
  group_by(document) %>% # 문서별 그루핑
  top_n(n=10, wt=count) %>% # couunt변수 상위 10개 추출
  ungroup()

address.tf  

ggplot(address.tf, 
       aes(reorder_within(x=term, by=count, within=document), y=count, fill=document)) +
  geom_col(show.legend = F) +
  facet_wrap(~document, ncol=2, scale="free") +
  labs(x=NULL, y="Term Frequency(count)") +
  coord_flip()

# america는 중요한 단어라고 볼 수 없다.
# 셀값이 tf-idf값이 되도록 문서-용어행렬을 다시 만들자
address.dtm2 <- DocumentTermMatrix(address.corpus,
                                   control=list(weighting=weightTfIdf))
address.dtm2

rownames(address.dtm2) <- c("Clinton", "Bush", "Obama", "Trump")
Docs(address.dtm2)
inspect(address.dtm2)



# 타이디텍스트로 변환
address.tfidf <- tidy(address.dtm2) %>% 
  mutate(tf_idf=count, count=NULL) # count이름 바꿔주기
address.tfidf


# 가장 많이 사용된 단어 10개씩 추출
address.tfidf <- address.tfidf %>% 
  mutate(document=factor(document,
                         levels=(c("Clinton", "Bush", "Obama", "Trump")))) %>% 
  arrange(desc(tf_idf)) %>% # 단어의 출현빈도 내림차순
  group_by(document) %>% # 문서별 그루핑
  top_n(n=10, wt=tf_idf) %>% # couunt변수 상위 10개 추출
  ungroup()

address.tfidf  

ggplot(address.tfidf, 
       aes(reorder_within(x=term, by=tf_idf, within=document), y=tf_idf, fill=document)) +
  geom_col(show.legend = F) +
  facet_wrap(~document, ncol=2, scale="free") +
  labs(x=NULL, y="Term Frequency-Inverse Document Frequency") +
  coord_flip()


# 타이디텍스트를 이용해서 빈도분석
# 01. TF기반 분석
us.president.address

# 토큰화
address.words <- us.president.address %>% 
  unnest_tokens(word, text)
address.words

# 전처리
address.words <- address.words %>% 
  anti_join(stop_words, by="word") %>% 
  filter(!grepl(pattern="\\d+", word)) %>% 
  mutate(word=gsub(pattern="'", replacement = "", word)) %>% 
  mutate(word=gsub(pattern="america|americas|americans|americans",
         replacement="america", word)) %>% 
  count(President, word, sort=T, name="count") %>%  # 문서열, 단어열, 소팅한다, 집계수치 열이름
  ungroup()

address.words

# 상위 10개 단어 추출
address.words %>% 
  group_by(word) %>% # 단어별로 함수적용
  summarise(count=sum(count)) %>% 
  arrange(desc(count)) %>% 
  top_n(n=10, wt=count) %>% 
  ggplot(aes(reorder(word, -count), count)) +
  geom_col(color="dimgrey", fill="salmon", width=0.6, show.legend=F) +
  geom_text(aes(label=count), size=3.5, color="black", vjust=-0.3) +
  labs(x=NULL, y="Term Frequency (count)") +
  theme(axis.text.x = element_text(angle=45, hjust=1))



# 02. tfidf산출하기
address.words <- address.words %>% 
  bind_tf_idf(term=word, document = President, n=count)
address.words

address.words %>% 
  arrange(desc(tf_idf)) # 상위 열개

address.words %>% 
  arrange(tf_idf) # 하위 열개, idf가 0


address.words %>% 
  arrange(desc(tf_idf)) %>% 
  mutate(President=factor(President,
                         levels=c("Clinton", "Bush", "Obama", "Trump"))) %>% 
  group_by(President) %>% 
  top_n(7, wt=tf_idf) %>% 
  ungroup() %>% 
  ggplot(aes(reorder_within(word, tf_idf, President), tf_idf, fill=President)) +
  geom_col(show.legend = F) +
  facet_wrap(~President, ncol=2, scales="free") +
  scale_x_reordered() +
  labs(x=NULL, y="TF-IDF") +
  coord_flip()

