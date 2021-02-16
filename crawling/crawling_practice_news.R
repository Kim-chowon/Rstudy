# devtools::install_github("ChiHangChen/KeyboardSimulator")
# install.packages("remote")
library(remote)
remote::install_github("ChiHangChen/KeyboardSimulator")

library(rvest)
library(lubridate)
library(tibble)
library(dplyr)

# max page check

max_page <- function(tar){
  read_html(tar) %>% 
    html_nodes("div.paging_comm .link_page") %>% # 노드를 찾아올 때 시행착오를 거칩니다. 
    html_text() %>% 
    as.numeric() %>% 
    max() %>% 
    return()
}

tar <- "https://news.joins.com/politics/bluehouse/list/1?filter=OnlyJoongang&date=2019-01-10"

max_page(tar)

tar_url <- "https://news.joins.com/politics/bluehouse/list/1?filter=OnlyJoongang&date=2019-01-10"

max <- max_page(tar)

root <- "https://news.joins.com"

articles <- c()

for (i in 1:max) {
  
  tar_url <- paste0("https://news.joins.com/politics/bluehouse/list/",i,"?date=2019-01-10")
  print(tar_url)
  read_html(tar_url) %>% 
    html_nodes("span.lead a") %>% 
    html_attr("href") -> link_list
  
  for (j in 1:length(link_list)) {
    print(paste0(i,j))
    tar <- paste0(root, link_list[j]) # 링크를 하나하나 root에 붙여줍니다.
    print(tar)
    news <- read_html(tar)
    news %>% 
      html_nodes("h1#article_title") %>% 
      html_text() -> title
    
    news %>% 
      html_nodes("div.byline") %>%  # 이 노드에 들어가서
      as.character() %>%            # 태그들까지 글자로 인식하게 한 뒤
      strsplit("em") %>%            # em으로 잘라줍니다.(쪼갤 땐 모양을 먼저 봅니다)
      .[[1]] %>%                    # strsplit()은 결과를 리스트로 주기 때문에 벡터로 바꿔줍니다.
      grep("입력", ., value = T) %>% # '입력'이라는 글자가 붙어있는 애를 데려와서 그 값까지 보여줍니다
      gsub(">|입력|<|/", "", .) %>%  #">|입력|<|/" 이거 다 날리자
      trimws() %>%                   # 앞뒤 공백 없애주기
      ymd_hm(tz = "Asia/Seoul") -> datetime # lubridate::ymd_hm()을 이용해서 시간데이터로 바꿔줍니다.
    
    news %>% 
      html_nodes("span.profile strong a") %>% 
      html_text() %>% 
      .[1] -> reporter
    
    news %>% 
      html_nodes("div#article_body") %>% # 이 노드에 들어가서
      as.character() %>%                 # 일단 다 글자로 바꿔주고
      strsplit("<br>|</div>") %>%        # enter역할을 하는 <br>태그로 잘라주면 문단정보가 살아남.
      .[[1]] %>%                         # 스플릿 결과(리스트)를 벡터로 바꿔주고
      trimws("both") -> body_tem         # 공백 없애서 일단 저장하고
    body_tem <- body_tem[-grep("(</|<!)",body_tem)]  # 쓸데없는 거 없애고
    body <- body_tem[nchar(body_tem) > 1]            # 데이터 없는 행 날리고 최종으로 저장하기
    
  
    
  }
  
}

articles
articles %>% distinct(title)


readr::write_excel_csv(articles, "test_run.csv")