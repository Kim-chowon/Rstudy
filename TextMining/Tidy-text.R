text <- c("Crash dieting is not the best way to lose weight. http://bbc.in/1G0J4Agg",
          "A vegetarian diet exclueds all animal flesh(meat, poultry, seafood).",
          "Economists surveyed by Refinitiv expect the economy added 160,000 jobs.")
source <- c("BBC", "CNN", "FOX")

#### tibble ####
# 문자열로 저장된 텍스트 데이터를 타이디텍스트 데이터셋으로 변환하기 위해서는 먼저 이를 데이터프레임으로 저장해야 한다.
# tibble() 이용

library(tidyverse)
text.df <- tibble(source=source, text=text)
# data.frame()과 동일한 방식으로 사용
text.df
class(text.df)
# tibble은 데이터프레임이긴 하지만 다양한 화면출력방식을 제공
# 문자열을 읽어들일 때 팩터로 자동변환하지 않음 
# 행이름 사용하지 않음
# 타이디텍스트 데이터셋은 티블형식으로 데이터를 저장


#### 토큰화 ####
if(!require(tidytext)) install.packages("tidytext")
library(tidytext)

unnest_tokens(tbl=, output=, input=)
# tbl=데이터프레임 (토큰단위로 분해해서 한행에 한개씩 저장)
# output= 분해한 토큰을 저장할 새로운 열이름
# input= 분해할 텍스트가 저장된 열이름
text.df
unnest_tokens(text.df, word, text)
# 33개 행 = 전체 단어 개수


# 파이프 연산자 사용
tidy.docs <- text.df %>% 
  unnest_tokens(word, text)
tidy.docs
# 티블데이터는 10개만 보여줌
# 다 보고 싶으면 
print(tidy.docs, n=Inf)


# 단어 외의 다양한 분석단위로 토큰 만들기
?unnest_tokens
# token = "words" 기본값
# drop = TRUE(디폴트) 원래 텍스트 열을 삭제할테냐?
# to_lower = TRUE(디폴트) 소문자로 변환할테냐?
# 변환과정에서 자동으로 문장부호 제거해줌

# 코퍼스를 다루려면 코퍼스를 다루는 함수를 사용해야 했음
# 타이디텍스트는 일반 함수를 적용할 수 있음

#### 단어 정렬하기 ####
tidy.docs %>% 
  count(source) %>%  # 출처별 집계
  arrange(desc(n))   # 내림차순 정렬


#### 불필요한 단어 제거하기 ####
# 01.url제거하기
?anti_join
# 두 개의 데이터프레임에서 같은 게 있으면 그걸 삭제
# 열이름 같으면 by=인수 지정할 필요 없지만
# 열이름 다르면 c("a" = "b")와 같은 방식으로 지정

# 삭제할 단어가 포함된 데이터셋을 먼저 생성해야 한다.
word.removed <- tibble(word=c("http", "bbc.in", "1g0j4agg"))
tidy.docs <- anti_join(tidy.docs, word.removed, by="word") %>% 
  print(n=Inf)
tidy.docs$word

# 02. 숫자 제거하기
# 정규표현식 이용
grep("\\d+", tidy.docs$word)
tidy.docs <- tidy.docs[-grep("\\d+", tidy.docs$word),]
tidy.docs$word

# 03. 텍스트 열에서 제거하고 나서, ttf로 만들기 
text.df$text <- gsub("(f|ht)tp\\S+\\s*", "", text.df$text)
text.df$text

text.df$text <- gsub("\\d+", "", text.df$text)
text.df$text

tidy.docs <- text.df %>% 
  unnest_tokens(word, text)
tidy.docs
print(tidy.docs, n=Inf)

# 04. 불용어 제거하기
stop_words

tidy.docs <- tidy.docs %>% 
  anti_join(stop_words, by="word")
tidy.docs$word


# 05. 공백 제거하기
tidy.docs$word <- gsub("\\s+", "", tidy.docs$word)

# 06. 어간 추출하기
library(SnowballC)
tidy.docs <- tidy.docs %>% 
  mutate(word=wordStem(word))
tidy.docs$word

# stem함수가 놓친 것
tidy.docs$word <- gsub("economist", "economi", tidy.docs$word)
tidy.docs$word


#### 코퍼스를 TTF로 변환하기 ####
# 코퍼스를 DF로 -> DF를 TTF로
text <- c("Crash dieting is not the best way to lose weight. http://bbc.in/1G0J4Agg",
          "A vegetarian diet exclueds all animal flesh(meat, poultry, seafood).",
          "Economists surveyed by Refinitiv expect the economy added 160,000 jobs.")
source <- c("BBC", "CNN", "FOX")

library(tm)
corpus.docs <- VCorpus(VectorSource(text))
corpus.docs

meta(corpus.docs, tag="author", type="local") <- source

tidy(corpus.docs)
# tidy(): 인수로 주어지는 객체의 클래스에 따라서 적합한 하위함수를 불러와 시행
# 코퍼스객체가 주어질 경우 티블형식으로 자동으로 바꿈
?tidy


tidy(corpus.docs) %>%             # 데이터프레임 생성
  unnest_tokens(word, text) %>%   # 토큰화
  select(source=author, word)     # author열을 source라는 이름으로 바꿔서 추출, word열도 추출


tidy.docs %>%
  count(word, sort = TRUE) 

library(ggplot2)

# 빈도수 그래프
tidy.docs %>%
  count(word, sort = TRUE) %>%
  filter(n >= 1) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word)) +
  geom_col() +
  labs(y = NULL)


