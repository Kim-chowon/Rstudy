library(httr)
pacman::p_library("httr", "rvest", "RSelenium")
library(rvest)
# install.packages("RSelenium")
library(RSelenium)

remD <- remoteDriver(port=4445L, # 포트번호 입력
                     browserName="chrome") # 사용할 브라우저

remD$open() # 서버에 연결

basic_url <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start=2016-07-01&dr.end=2017-06-30&qType=contents&q="
urls <- NULL
for (x in 1:9){
  urls[x] <- paste0(basic_url, "원희룡&page=", x)
}
urls

library(rvest)
library(dplyr)

links <- html %>% 
  html_nodes('.list-unstyled.newsBoardBox') %>% 
  html_nodes('a') %>% 
  html_attr('href')

links <- NULL
for(url in urls){
  html <- read_html(url)
  links <- c(links, html %>% 
               html_nodes('.list-unstyled.newsBoardBox') %>% 
               html_nodes('a') %>% 
               html_attr('href'))
}


for(link in links){
  remD$navigate(link)
}

remD$navigate(paste0("http://www.jeju.go.kr/news/bodo/list.htm?dr.start=&dr.end=&qType=title&q=", srch.title)) #이 홈페이지로 이동 


html <- remD$getPageSource()[[1]] 
html <- read_html(html) #페이지의 소스 읽어오기 

links <- html %>% 
  html_nodes('.list-unstyled.newsBoardBox') %>% 
  html_nodes('a') %>% 
  html_attr('href') #선택된 노드를 텍스트 화


sWords[1:10] #1~20개가져오기 



id<-remD$findElement(using = "css selector", value = "input#id")
pw<-remD$findElement(using = "css selector", value = "input#pw")

id$sendKeysToElement(list("ID"))
pw$sendKeysToElement(list("PW"))

btn <- remD$findElement(using="css selector", value='input.btn_global') 
btn$clickElement()

btn$close()

if (!require("devtools")) install.packages("devtools")
devtools::install_github("ChiHangChen/KeyboardSimulator")
install.packages("taskscheduleR")

library(KeyboardSimulator)
library(taskscheduleR)



urls

for (x in 1:9){
  write(urls[x], file="urls.txt")
}


for (x in 1:9){
  print(urls[1])
  mouse.move(36,796, duration=1)
  mouse.click(hold=T)
  mouse.move(870,796)
  mouse.release()
  keybd.press("ctrl+c")
  keybd.press("Alt", hold = T)
  keybd.press("Tab")
  keybd.release("Alt")
  mouse.move(238,49)
  mouse.click()
  keybd.press("ctrl+v")
  keybd.press("enter")
}


mouse.get_cursor()
mouse.click(513,842)
mouse.click(305, 63)

basic_url <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start=2016-07-01&dr.end=2017-06-30&qType=contents&q="
urls <- NULL
for (x in 1:9){
  urls[x] <- paste0(basic_url, "원희룡&page=", x)
}
urls

library(rvest)
html <- read_html(urls[1]) 
library(dplyr)

links <- html %>% 
  html_nodes('.list-unstyled.newsBoardBox') %>% 
  html_nodes('a') %>% 
  html_attr('href')

links <- NULL
for(url in urls){
  html <- read_html(url)
  links <- c(links, html %>% 
               html_nodes('.list-unstyled.newsBoardBox') %>% 
               html_nodes('a') %>% 
               html_attr('href'))
}


links 

txts <- NULL
for(link in links){
  html <- read_html(link)
  txts <- c(txts, html %>% 
              html_nodes('article-contents') %>% 
              html_nodes('p') %>% 
              html_text())
}
text

basic_url <- "http://www.jeju.go.kr/news/bodo/list.htm?dr.start=2016-07-01&dr.end=2017-06-30&qType=contents&q=%EC%9B%90%ED%9D%AC%EB%A3%A1&page="
urls <- NULL
for (x in 1:9){
  urls[x] <- paste0(basic_url, x)
}

urls