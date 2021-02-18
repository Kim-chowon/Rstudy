library(rvest)
library(lubridate)
library(tibble)
library(dplyr)
library(tidyverse)
library(httr)
library(lubridate)


basic.url <- "https://www.chungbuk.go.kr/www/selectBbsNttList.do?key=429&bbsNo=65&searchCtgry=&pageUnit=10&searchCnd=CN&searchKrwd=%EC%9D%B4%EC%8B%9C%EC%A2%85&pageIndex="

root <- "https://www.chungbuk.go.kr/www"

page <- c(242:442)

urls <- paste0(basic.url, page)

# 링크 따기 
links <- NULL
for(url in urls)
{ 
    read_html(url) %>% 
    html_nodes("td.p-subject a") %>% 
    html_attr("href") -> html
  links <- c(links, html)
}

links <- paste0(root, links)
links <- gsub("www./", "www/", links)
links %>% head
links %>% length



# 텍스트 따기
texts <- NULL
for(link in links) {
  link %>% 
    GET(ah) %>% 
    content %>% 
    html_nodes("td.p-table__content") %>%  
    html_text("br") %>% 
    gsub(pattern="\r", replacement="") %>% 
    gsub(pattern="\n", replacement="") %>% 
    gsub(pattern="\t", replacement="") %>% 
    gsub(pattern="사진 확대보기", replacement="") %>% 
    trimws -> content
  texts <- c(texts, content)
}
texts %>% head
texts %>% length
texts %>% write.csv(file="article_chungbuk.csv")

# 날짜 따기
date <- NULL
for(link in links) {
  link %>% 
    GET(user) %>% 
    content %>% 
    html_nodes("time") %>%  
    html_text() -> time
  date <- c(date, time)
}
date %>% head
date %>% length



#################################sample-test#####################################
user <- httr::add_headers("User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36")
GET("https://www.chungbuk.go.kr/www/selectBbsNttList.do?bbsNo=65&key=429", user) %>% 
  content %>% 
  html_nodes("time") %>%  
  html_text() -> time_test 

ah <- httr::add_headers("User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36")
GET("https://www.chungbuk.go.kr/www/selectBbsNttView.do?key=429&bbsNo=65&nttNo=118241&searchCtgry=&searchCnd=CN&searchKrwd=%EC%9D%B4%EC%8B%9C%EC%A2%85&pageIndex=242", ah) %>% 
  content %>% html_nodes("td.p-table__content") %>%  
  html_text("br") %>% 
  gsub(pattern="\r", replacement="") %>% 
  gsub(pattern="\n", replacement="") %>% 
  gsub(pattern="\t", replacement="") %>% 
  gsub(pattern="사진 확대보기", replacement="") %>% 
  trimws -> content_test
  
length(texts)

text_test <- read_html("https://www.chungbuk.go.kr/www/selectBbsNttView.do?key=429&bbsNo=65&nttNo=118241&searchCtgry=&searchCnd=CN&searchKrwd=이시종&pageIndex=242") %>% 
  html_nodes("td.p-table__content") %>%  
  html_text("br") %>% 
  gsub(pattern="\r", replacement="") %>% 
  gsub(pattern="\n", replacement="") %>% 
  gsub(pattern="\t", replacement="") %>% 
  gsub(pattern="사진 확대보기", replacement="") %>% 
  trimws

links <- c(links, html %>% 
             html_nodes("td.p-subject a") %>% 
             html_attr('href'))



