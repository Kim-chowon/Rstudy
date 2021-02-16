library(rvest)
library(tidyverse)

tar <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start=&dr.end=&qType=title&q=%EC%9B%90%ED%9D%AC%EB%A3%A1"
read_html(tar)

# {html_document}라는 R의 class로 가져왔다
# 제목 따오기
# 노드를 선택해볼게요

read_html(tar) %>% 
  html_nodes("strong[class='text-ellipsis']") %>% 
  html_text() %>% 
  gsub(pattern="\n", replacement="") %>% 
  gsub(pattern="\t", replacement="") %>% 
  write.csv(file="article_head_jeju1.csv") 


?write.csv
getwd()

# 링크 따오기
# html_attr()은 보통 링크 따올때 사용하고, 
# 하이퍼링크(href)는 보통 'a'태그에 들어가 있습니다.
read_html(tar) %>% 
  html_nodes('a') %>% 
  html_attr('href')
# 너무 많아요

read_html(tar) %>% 
  html_nodes('.list-unstyled.newsBoardBox') %>%   # 'a'태그만 찾으면 너무 많으니까 부모노드를 찾아줘요
  html_nodes('a') %>% 
  html_attr('href')


# for문을 이용해서 모든 페이지의 모든 링크에 들어가서 제목과 본문을 다 가져올 수 있음



# 요청하기 다른 방법 ####
url <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start=&dr.end=&qType=title&q=%EC%9B%90%ED%9D%AC%EB%A3%A1"
library(rvest)
read_html(url)

library(httr)
GET(url)
# GET이라는 표준양식으로 요청하는 것
# 서버에서 제공하는 응답 전체를 가져옴
library(dplyr)
GET(url) %>% content()
# read_html()와비슷하게 나옴
# 왜 GET()을 써야 할까?
# contents로 정보를 제공함
?read_html
?GET

POST
# 우리가 정보를 제공
