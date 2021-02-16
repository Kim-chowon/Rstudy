library(rvest)
library(tidyverse)
# 여기부터 진정 제가 하고싶었던 것입니다
# url을 잘라서 변수를 입력할 수 있게 만들어줍니다.
url_start <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start="
start_date.y <- 2016
start_date.m <- "-07"
start_date.d <- "-01"
url_end <- "&dr.end="
end_date.y <- 2017
end_date.m <- "-06"
end_date.d <- "-30"
url_name <- "&qType=contents&q="
name <- "원희룡"

# url과 변수를 붙여붙여 하나의 url로 만들고, page=?를 반복 입력해줍니다.
urls <- NULL
for (x in 1:2){
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
txts %>% write.csv(file="article_jeju_1-1.csv")

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
    write.csv(file="article_jeju_.csv")
}