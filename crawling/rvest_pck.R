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

# 여기부터 진정 제가 하고싶었던 것입니다
# url을 잘라서 변수를 입력할 수 있게 만들어줍니다.
url_start <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start="
start_date.y <- 2019
start_date.m <- "-07"
start_date.d <- "-01"
url_end <- "&dr.end="
end_date.y <- 2020
end_date.m <- "-06"
end_date.d <- "-30"
url_name <- "&qType=contents&q="
name <- "원희룡"

# url과 변수를 붙여붙여 하나의 url로 만들고, page=?를 반복 입력해줍니다.
urls <- NULL
for (x in 1:49){
  urls[x] <- paste0(url_start, start_date.y, start_date.m, start_date.d, url_end, end_date.y, end_date.m, end_date.d, url_name, "원희룡&page=", x)
} 
urls
str(urls)

# getwd()
# links변수에 링크를 저장합니다. 링크는 보통 a태그, attr=href에 저장되어 있습니다.
links <- NULL
for(url in urls){
  html <- read_html(url)
  links <- c(links, html %>% 
               html_nodes('.list-unstyled.newsBoardBox') %>% 
               html_nodes('a') %>% 
               html_attr('href'))
}

# 링크가 인식이 안되어서 확인해보니
links 
# 주소를 완벽하게 만들어 줍니다.
links <- paste0("http://www.jeju.go.kr", links)

# 텍스트를 가져옵니다.
txts <- NULL
for(link in links){
  html <- read_html(link)
  txts <- c(txts, html %>% 
              html_nodes('div[id="articleContents"]') %>% 
              html_nodes('p') %>% 
              html_text())
}

# 텍스트가 엄청 많은데 중간중간에 이상한게 많이 있습니다.
str(txts)
class(txts)
length(txts)
library(tibble)
txts <- as_tibble(txts)
# 빈 행은 지워줍니다.
txts <- txts %>% 
  subset(nchar(value) >= 5)


# csv파일로 만들어 줍니다.
txts %>% write.csv(file="article_jeju_4.csv")

# 원희룡 지사의 임기 2년차 보도자료 중 '원희룡'이 들어간 보도자료내용 모음. 여기서 '원희룡'이 몇 번 나왔는지 센다
# 이제 이거를 임기 3년차, 4년차, 5년차로 반복한다.
# 그러면 제주도 보도자료에서 매년 전체문서 수 대비 원희룡 이름 수 비율을 알 수 있고, 이게 권력형 나르시시즘의 척도가 될 수 있다. 



# 반복문으로 만들어 보겠습니다.
# 반복 순서가 궁금합니다.

for (y in 2016:2019){
  url_start <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start="
  start_date.y <- y
  start_date.m <- "-07"
  start_date.d <- "-01"
  url_end <- "&dr.end="
  end_date.y <- y+1
  end_date.m <- "-06"
  end_date.d <- "-30"
  url_name <- "&qType=contents&q="
  name <- "원희룡"
  urls <- NULL
  for (x in 1:9){
    urls[x] <- paste0(url_start, start_date.y, start_date.m, start_date.d, url_end, end_date.y, end_date.m, end_date.d, url_name, "원희룡&page=", x)
  }
  links <- NULL
  for(url in urls){
    html <- read_html(url)
    links <- c(links, html %>% 
                 html_nodes('.list-unstyled.newsBoardBox') %>% 
                 html_nodes('a') %>% 
                 html_attr('href'))
  }
  links <- paste0("http://www.jeju.go.kr", links)
  txts <- NULL
  for(link in links){
    html <- read_html(link)
    txts <- c(txts, html %>% 
                html_nodes('div[id="articleContents"]') %>% 
                html_nodes('p') %>% 
                html_text())
  }
  txts <- as_tibble(txts)
  txts %>% 
    subset(nchar(value) >= 5) %>% 
    write.csv(file="article_jeju.csv")
}

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
