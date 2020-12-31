#도수분포표 작성방법

rm(list=ls()) #함수다지우기
sample.data <- c("y","y","y","y","N","N","N")
table(sample.data) #도수분포표
table(sample.data)/length(sample.data) #비율 출력

#데이터에서 바로 도수분포표를 작성하고 싶을 때
table(iris$Species)

#막대그래프를 작성하고 싶다.

MPA <- c("HUFS", "HUFS", "HUFS",
         "KU","KU","KU","KU","KU","KU",
         "KHU","KHU")
# 또는,
#MPA <- c(rep("HUFS",3),
#         rep("KU",6),
#         rep("KHU",2))

MA <-  c("HUFS","HUFS","HUFS","HUFS","HUFS","HUFS",
         "KU","KU",
         "KHU")

sample.data2 <- c(MPA, MA)
sample.data2

plot.sample.data2 <- table(sample.data2)
plot.sample.data2

barplot(plot.sample.data2,            #데이타이름
        main = "Master Degree Univ.") #바플랏의 이름

#데이터로 해보겠습니다.
data(mtcars)
carb <- mtcars$carb 
#또는 
#carb <- mtcars[,"carb"]

table(carb)
barplot(table(carb),
        main="Barplot of Carburetors",
        xlab="of carburetors",    #x축이름
        ylab = "frequency")       #y축이름

#barplot의 구조 +색상
barplot(table(carb),
        main="Barplot of Carburetors",
        xlab="of carburetors",
        ylab = "frequency",
        col="red")

#한 화면에 그래프를 여러개 그리고 싶다.
par(mfrow=c(1,3)) #1x3 윈도우 생성
barplot(table(mtcars$carb),
        main="Barplot of Carburetors",
        xlab="of carburetors",
        ylab = "frequency",
        col="red")
barplot(table(mtcars$cyl),
        main="Barplot of Carburetors",
        xlab="of carburetors",
        ylab = "frequency",
        col="blue")
barplot(table(mtcars$gear),
        main="Barplot of Carburetors",
        xlab="of carburetors",
        ylab = "frequency",
        col="green")

#연습1

# 1. infert 데이터셋의 education 컬럼 값을 잘라내어 edu 에 저장한뒤 edu 의 값을 보이시오. 
head(infert)
edu <- infert$education
edu

# 2. edu 에 있는 값들을 중복을 제거하고 보이시오. 
unique(edu)

# 3. edu 에 있는 값들에 대해 도수 분포표를 작성하여 보이시오. 
t.edu <- table(edu)
t.edu

# 4. edu 에 있는 값들에 대해 막대 그래프를 작성하여 보이시오.
barplot(t.edu)

