#자료분석l.Length) #평균
rm(list=ls())
iris.sample <- iris$Sepal.Length
median(iris.sample) #중앙값
mean(iris.sample, trim = 0.2) #절사평균
quantile(iris.sample) #사분위수
quantile(iris.sample, (0:4)/4) #이거랑 같다.
summary(iris.sample) #기초통계량
fivenum(iris.sample) #사분위수랑 비슷 #처음끝가운데세개
diff(range(iris.sample)) #최댓값-최솟값
var(iris.sample) #분산
sd(iris.sample) #표준편차

#사분범위 상자그림 그리기
data(state)
head(state.x77)
st.Illiteracy <- state.x77[,"Illiteracy"]
boxplot(st.Illiteracy, ylab="Illiteracy")

#사분범위 상자그림 그리기2
head(iris)
#품종에 따른 Petal.Width자료에 대한 boxplot 그리기
boxplot(Petal.Width~Species, data=iris,
        ylab="Petal.Width")

#a~b = y축,x축



#히스토그램 그리기
st.income <- state.x77[,"Income"]
#왜 state.x77$Income 하면 에러가 나지?
hist(st.income,
     main="Histogram for Income",
     xlab="Income",
     ylab="frequency", 
     border="blue", #막대테두리 색상
     col="green", #막대 색상
     las=3, #~3까지 글씨방향이 달라짐
     breaks=5) #구분선 개수


#줄기-잎 그림
score <- c(40,50,55,60,65,67,78,77,75,66)
stem(score, scale=2)

#paste() 함수
#각 문자열을 연결해 하나로 만들 때 사용한다.
paste("Good", "Morning", "Kim",
      sep=" ")
paste("Good", "Morning", "Kim",
      sep="/")
paste(1:10, "sheep",
      sep=" ")

# substr()문자열 자르기
# nchar() 문자열 길이
smp <- "Hello World"
substr(smp, 1,5)
substr(smp, 7,nchar(smp)) #띄어쓰기도 글자로 인식

#gsub() 문자열 바꾸기
smp <- "Hello World"
gsub("Hello", "Happy", smp)

