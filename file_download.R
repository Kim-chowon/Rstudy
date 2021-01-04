library(tidyverse)
library(rvest)

url <- "https://www.gutenberg.org/files/11/11-0.txt"

#라인 단위로
readLines(url, n=100, encoding="UTF-8")
alice <- readLines(url, n=100, encoding="UTF-8")

#단어 단위로 #라인으로 만들고 싶으면 paste
scan()
one.line <- scan(url, what=character(), skip=55,
                 nlines=1, encoding="UTF-8")
paste(one.line, collapse=" ")

#루프
for (i in 1:10) (one.line <- scan(url, what=character(), skip=55,
                                  nlines=1, encoding="UTF-8")
                 paste(one.line, collapse=" ")
)

#1부터 10까지의 숫자가 i가 된다
#다음의 함수를 반복한다
#skip인자도 계속 바뀌어야 한다
skip <- 55
#각 라인이 들어갈 문자벡터도 있어야 한다
alice <- character(10)

for (i in 1:10) {one.line <- scan(url, what=character(), skip=skip,
                                  nlines=1, encoding="UTF-8")
                 alice[i] <- paste(one.line, collapse=" ")
                 skip <- skip + 1
}

alice

#i는 1부터 10까지 반복한다
#one.line에 단어들이 들어간다
#단어들을 paste함수로 붙이고, 그거를 alice라는 문자벡터에 한줄씩 넣는다
#마지막으로 skip인자를 하나씩 업데이트한다