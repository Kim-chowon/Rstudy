library(httr)
library(rvest)

url <- "http://news.naver.com/main/read.nhn?mode=LSD&mid=shm&sid1=102&oid=437&aid=0000165410"

read_html(url) # 이거랑
GET(url) # 이거랑 비슷합니다.
# 다만 GET()은 GET방식으로 요청하는 것입니다.
GET(url) %>% content()

# 연습용 사이트에서 연습하기
GET("http://httpbin.org/get") %>% content
ah <- httr::add_headers("User-Agent" = "chowon's practice")
GET("http://httpbin.org/get", ah) %>% content
?POST
