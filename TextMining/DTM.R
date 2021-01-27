#### 코퍼스로부터 문서-용어 행렬 만들기 ####
text <- c("Crash dieting is not the best way to lose weight. http://bbc.in/1G0J4Agg",
          "A vegetarian diet exclueds all animal flesh(meat, poultry, seafood).",
          "Economists surveyed by Refinitiv expect the economy added 160,000 jobs.")

library(tm)
library(tidyverse)
corpus.docs <- VCorpus(VectorSource(text)) %>% 
  tm_map(content_transformer(tolower)) %>% 
  tm_map(removeWords, stopwords("english"))
myRemove <- content_transformer(function(x, pattern)
  {return(gsub(pattern, "", x))})

corpus.docs <- corpus.docs %>% 
  tm_map(myRemove, "(f|ht)tp\\S+\\s*") %>% 
  tm_map(removePunctuation) %>% 
  tm_map(removeNumbers) %>% 
  tm_map(stripWhitespace) %>% 
  tm_map(content_transformer(trimws)) %>%   # 텍스트 앞 뒤 공백 제거
  tm_map(stemDocument) %>% 
  tm_map(content_transformer(gsub), pattern="economist", replacement="economi")

lapply(corpus.docs, meta)
lapply(corpus.docs, content)



?DocumentTermMatrix
corpus.dtm <- DocumentTermMatrix(corpus.docs,
                   control=list(wordLengths=c(2, Inf))) # 단어 추출 기준
corpus.dtm 
# 3행 18열의 DTM이 만들어졌다
# 19 = 전체 셀 중에서 숫자가 채워져 있는 셀의 개수
# 35 = 전체 셀 중에서 0으로 채워진 셀의 개수
# 35/전체 = 65% : 비어있는 셀의 비율 = Sparsity
# 10 = 가장 긴 단어의 길이
# Weighting = 문서용어행렬의 셀값을 무엇으로 나타내었는지, 여기서는 단어 출현 빈도
# 컨트롤 인자에서 지정할 수 있음(TF-IDF도 가능)

nTerms(corpus.dtm) # 단어의 개수 보기
Terms(corpus.dtm)  # 단어 보기
nDocs(corpus.dtm)  # 문서 개수 보기
Docs(corpus.dtm)   # 문서 이름 보기 (행)

rownames(corpus.dtm) <- c("BBC", "CNN", "FOX")  # 문서 이름 바꾸기
Docs(corpus.dtm)

# 좀 더 자세히 탐색하기
inspect(corpus.dtm)
inspect(corpus.dtm[1:2, 10:15])

# 코퍼스로부터 만든 문서용어행렬을 타이디텍스트로
library(tidytext)
tidy(corpus.dtm)


#### 타이디텍스트로부터 문서-용어 행렬 만들기 ####
text <- c("Crash dieting is not the best way to lose weight. http://bbc.in/1G0J4Agg",
          "A vegetarian diet exclueds all animal flesh(meat, poultry, seafood).",
          "Economists surveyed by Refinitiv expect the economy added 160,000 jobs.")
source <- c("BBC", "CNN", "FOX")

library(tidyverse)
library(tidytext)
library(SnowballC)

text.df <- tibble(source=source, text=text)
text.df$text <- gsub("(f|ht)tp\\S+\\s*", "", text.df$text)
text.df$text <- gsub("\\d+", "", text.df$text)
tidy.docs <- text.df %>% 
  unnest_tokens(word, text) %>% 
  anti_join(stop_words, by="word") %>% 
  mutate(word=wordStem(word))
tidy.docs$word <- gsub("\\s+", "", tidy.docs$word)
tidy.docs$word <- gsub("economist", "economi", tidy.docs$word)

tidy.docs %>% print(n=Inf) 


# 타이디텍스트 데이터셋으로부터 문서-용어 행렬을 생성하려면 먼저 문서-단어쌍의 빈도를 계산해야 한다.
tidy.dtm <- tidy.docs %>%
  count(source, word) %>% 
  cast_dtm(document = source, term = word, value = n)

tidy.dtm

Terms(tidy.dtm)
Docs(tidy.dtm)
inspect(tidy.dtm)
