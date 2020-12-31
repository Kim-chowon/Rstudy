getwd()
setwd(C:/Users/user/Documents/R projects/Rstudy)
Chowon <- "Gradstudent"
print(c("Chowon is", Chowon))
Target <- Chowon
x <- if(Target == "Gradstudent"){
  print("사람아님")} else {
    print("사람")
  }

if(

if(#조건)(#조건이 트루일 때) else(#조건이 거짓일 때)

  
<- #Alt + -

#오름차순, 내림차순
v1 <- 1:10
sort(x = v1, T) #기본 오름차순, TRUE로 하면 내림차순

#matrix

x <- 1:4
y <- 5:8
m1 <- cbind(x,y) #x랑 y를 칼럼으로 묶어
m1
m2 <- rbind(x,y) #x랑 y를 로우로 묶어
m2

score <- c(96, 83, 28, 24, 67)
name <- c("김", "이", "박", "최", "홍")
m3 <-  cbind(name, score)
m3
m3[3,2]

#행,열에 이름 붙이기

#matrix안에는 같은 데이터 형식이어야 함
#그래서 데이터 프레임으로 만들어줘야 함

m4 <- data.frame(name, score)
m4
rownames()
colnames()

iris
is.data.frame(iris)
iris["Species"]
iris$Species    #Levels: setosa versicolor virginica
                #Levels이 포함되어 있다는 것은 팩터값이라는 뜻
is.factor(iris$Species)
dim(iris) #행과 열의 숫자
str(iris) #요약보기
unique(iris$Species) #열에 대한 정보를 추출할 떄 $표시
                     #중복값 제거한 특성 추출

subset(iris, Species == "setosa")  #조건에 맞는 행 추출
is.data.frame(iris)
class(iris$Species)
class(iris$Sepal.Width)
SW <- iris$Sepal.Width
class(SW)

#파이프연산자 사용할때 라이브러리에 tidyverse
#파이프연산자 많이 쓰는 습관
library(tidyverse)
SW %>% class()

state.x77
st <- data.frame

