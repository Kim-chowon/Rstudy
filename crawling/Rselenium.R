########## 연습하기 1 ###########
CMD java -Dwebdriver.gecko.driver="geckodriver.exe" -jar selenium-server-standalone-3.141.59.jar -port 4445

library(httr)
library(rvest)
library(RSelenium)

remD <- remoteDriver(port = 4445L, # 포트번호 입력 
                     browserName = "chrome") #사용할 브라우저 

remD$open() #서버에 연결
title_you <- "R코홀릭"

remD$navigate(paste0("https://www.youtube.com/results?search_query=",title_you)) #해당 홈페이지로 이동 

html <- remD$getPageSource()[[1]]
html <- read_html(html) #페이지의 소스 읽어오기 

youtube_title <- html %>% 
  html_nodes("#video-title") %>% 
  html_text() #선택된 노드를 텍스트 화

youtube_title[1:20] #1~20개가져오기 


youtube_title<-gsub("/n","",youtube_title) %>% 
  trimws 

youtube_title

write.table(youtube_title, file = "C:/Users/user/Documents/R projects/Rstudy/crawling/youtube_title.txt",sep=",",row.names=FALSE,
            quote = FALSE)


############ 연습하기 2 ############
remD <- remoteDriver(remoteServerAddr = 'localhost', 
                     port = 4445L, # 포트번호 입력 
                     browserName = "chrome") 
remD$open() #서버에 연결
remD$navigate("https://www.youtube.com/watch?v=-4Hi0QDEIk4") #이 홈페이지로 이동 

#영상 플레이
btn <- remD$findElement(using="css selector", value='.html5-main-video')
btn$clickElement()

#홈페이지 스크롤
remD$executeScript("window.scrollTo(0,500)")
remD$executeScript("window.scrollTo(500,1000)")
remD$executeScript("window.scrollTo(1000,1500)")



html <- remD$getPageSource()[[1]]
html <- read_html(html) #페이지의 소스 읽어오기 

ytube_comments <- html %>% html_nodes("#content-text") %>% html_text() 
ytube_comments<-ytube_comments[1:50]

ytube_comments<-gsub("\n","",ytube_comments) #데이터 정제 1
ytube_comments<-trimws(ytube_comments)

ytube_comments

write.table(ytube_comments, file = "E:/R/R셀레니움/결과물/youtube_comments.txt",sep=",",row.names=FALSE,
            quote = FALSE)
