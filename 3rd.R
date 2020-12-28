#스터디 세번째

#벡터생성
1:10
a <- c(1:10)

#나머지
9%%2

A <- matrix(1:28, ncol = 4)
#ncol은 칼럼의 수

B <- t(A) #행과 열 바꾸기

A%*%B #행렬의 곱
#영행렬은 어떤 행렬에다 곱해줘도 자기 행렬값이 나옴

#초급

#%in% : 왼쪽에 오른쪽이 들어있나?
%in%
  hero <- c("superman", "batman", "spiderman","ironman")
marble.hero <- c("spiderman", "ironman")
hero %in% marble.hero
rm(marble.herd)

:: #"~에 속한"이라는 뜻
  #패키지의 함수를 불러올 때 
  #명시적으로 어느 패키지의 함수를 사용하는지 알려주는 것
  dplyr::Filters()

%>%
  x <- 1:10
y <- x*2
plot(x,y)
x %>% plot(y) 
# 왼쪽에 있는 애를 오른쪽 함수의 첫번째 인자로 삼는다
library(tidyverse)

cars
dim #데이터의 요약값
dim(cars)
cars %>% dim()
# 왼쪽에 있는 애가 여기저기 함수에 자주 쓰일 때

ls()
#함수가 뭐 있는지 전부 산출한다

ls.str()
rm()
rm(list=ls())

save.image()
#작업공간 전체저장
save(hero, file="hero.r")
rm(hero)
load("hero.r")

history()

library
Sys.setlocale("LC_ALL", "English")
Sys.setlocale("LC_ALL")
installed.packages()
colnames(installed.packages())
installed.packages()[,c("Package", "Version")]
search()
#R이 함수를 찾아보는 우선순위
#어느 패키지인지 확실하게 하고싶으면 :: 이용하세요
base::t(m)
#t에 벡터 또는 함수설정했을 때 t를 패키지에 있는 함수로서 이용하고 싶을 때

install.packages("ggplot2")
#이 함수는 어느 패키지에 있나요??
??xyplot
library(ggplot2)
search(xyplot)
?xyplot
#알고자 하는 것과 데이터를 입력하라고 오른쪽에 나옴.
#나머지는 디폴트
xyplot(dist ~ speed, data=cars)
#y값이 dist, x값이 스피트라는 뜻

detach() #패키지없애는거

#패키지 안에도 데이터가 포함되어있어. 
library(datasets)
AirPassengers
head(AirPassengers) #앞에 있는 값들만 나와
tail(AirPassengers,10) #뒤에 있는 값들 10개만 나와
data(package="ggplot2") 
data(Animals, package="MASS")
Animals
rm(Animals)
library(MASS)
Animals

help.start()

apropos() #함수를 검색하는 식
apropos("vector") #문자열 포함
apropos("q$") #q로 끝나는거 
apropos("[7-9]") #7과 9사이의 숫자가 포함되어있는 함수 찾기
apropos("xy+") #뭐더라

install.packages("sos")M
library(sos)
FindFn() #인터넷에서 검색결과 찾아주는거

install.packages("plot3D")
library(plot3D)

