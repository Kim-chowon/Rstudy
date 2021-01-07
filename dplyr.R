#### dplyr 패키지 ####
# 데이터셋을 분할, (함수)적용, 결합하는 패키지 
# 행추출, 열추출, 소팅, 새로운 변수 생성, 요약, 샘플, 그룹화, %>% 
install.packages("dplyr")
library(dplyr)

str(airquality)
head(airquality)

#### filter() ####
# 행 추출 / 열 입력
?filter
air1 <- filter(airquality, Month == 6)  
head(air1)
# 이미 배웠던 걸로도 가능
air2 <- airquality[airquality$Month==6, ]
air2 <- subset(airquality, subset=(Month==6)) 
head(air2)
# filter()는 인자를 간단하게 쓴다. 그리고 행번호를 바꿔준다

# and = &, ,
# or = |
air <- filter(airquality, Month==6 & Temp > 90)
air <- filter(airquality, Month==6, Temp > 90)
air
air <- filter(airquality, Ozone > 80 | Temp > 90)
air

#### slice() ####
# 행 번호로 가져오기
slice(airquality, 6:10)
airquality[6:10, ]
# slice()는 행번호를 바꿔준다

slice(airquality, n())  #n()는 행의 개수(=마지막 행번호)
slice(airquality, (n()-4):n())

#### arrange() ####
# 지정한 열을 기준으로 오름차순 행 소팅
arrange(airquality, Temp, Month, Day) # Temp -> Month -> Day 순으로 동률 처리
arrange(airquality, desc(Temp), Month, Day) # Temp만 내림차순

#### select() ####
# 열 추출 / 열 입력
air1 <- select(airquality, Month, Day, Temp) # 원하는 열을, 원하는 순서대로 배열
air1 <- select(airquality, Temp:Day) 
air1 <- select(airquality, -(Temp:Day)) 
str(airquality)
air2 <- airquality[, c("Month", "Day", "Temp")]
air2 <- airquality[, c("Temp":"Month")]
air2 <- airquality[, 4:6]
head(air1)
head(air2)
# select()는 한번에 여러개 열 추출할 때 인덱싱보다 편하다.

# 열이름도 추출과 동시에 바꿀 수 있다. 
head(airquality)
air <- select(airquality, Solar=Solar.R)
head(air)
# 그러나 변경한 열만 추출된다.
# 열이름 바꿀 땐 rename()
air <- rename(airquality, Solar=Solar.R)
head(air)

#### distinct() ####
# 특정 열에 포함된 중복되지 않은 값들 추출
distinct(select(airquality, Month))
distinct(airquality$Month)
unique(airquality$Month)

#### matate() ####
# 기존 데이터 프레임의 열(변수)를 이용해서 새로운 열 생성
air1 <- mutate(airquality,
       Temp.C=(Temp-32)/1.8,     # 섭씨변수 추가
       Diff=Temp.C-mean(Temp.C)) # 편차변수 추가
head(air1)

# transform()이랑 비슷
air2 <- transform(airquality,
          Temp.C=(Temp-32)/1.8,     # 섭씨변수 추가
          Diff=Temp.C-mean(Temp.C))
air2 <- transform(airquality,
                  Temp.C=(Temp-32)/1.8)
head(air2)
air3 <- transform(air2,
                  Diff=Temp.C-mean(Temp.C))
head(air3)
# mutate()는 함수 내에서 생성된 변수를 바로 다른 변수 만들 때 사용할 수 있음
# transform()은 바로 못함

#### summarise() ####
# 요약통계량
mean1 <- summarise(airquality, 
                  mean(Temp))
mean2 <- mean(airquality$Temp)
str(mean1)
str(mean2)

install.packages("psych")
library(psych)
describe(airquality)

summ
summ <- summarise(airquality, 
          Mean=mean(Temp, na.rm=T),
          Medi=median(Temp, na.rm=T), 
          SD=sd(Temp, na.rm=T),
          Max=max(Temp, na.rm=T),
          Min=min(Temp, na.rm=T),
          n(), 
          n_distinct(Month),
          first(Temp),
          last(Temp))
str(summ)


#### sample 추출함수 ####
sample_n(airquality, 5)       # 지정된 정수 개의 무작위 행추출
sample_frac(airquality, 0.05) # 지정된 비율만큼 무작위 행 추출
sample_frac(airquality, 0.05, replace=T) # 복원추출


# sample()은 무작위 열추출 또는 무작위 순열
sample(x=1:10, size=5)       # 비복원추출
sample(1:10, 5, replace = T) # 복원추출
sample(20)                   # 무작위 순열

#### group_by ####
# 주어진 데이타 셋으로부터 집단변수의 레벨별로 분할된 그룹화 객체 생성
air.group <- group_by(airquality, Month) # Month의 레벨(5,6,7,8,9)별로 그룹화
class(air.group)
# "grouped_df" 그룹화된 데이터 프레임이라는 뜻
air.group
# tibble은 데이터 프레임이랑 똑같은 구조에 장점이 더 있음
# tibble은 열이름 밑에 데이터 구조, 한 화면에 보여줄 수 있는 만큼만 출력
# "Groups:   Month [5]" Month의 레벨별로 그룹화 되어있다는 뜻

summarise(air.group, 
          Mean.Temp=mean(Temp, na.rm=T),
          SD.Temp=sd(Temp, na.rm=T),
          Days=n())

#### %>% 파이프연산자 ####
library(dplyr)
library(magrittr)
# 한 함수의 출력 결과 또는 데이터를 다음 함수의 첫번째 인수로 전달
# 윈도우 Shift + Ctrl +M
# 맥 Shift + Cmd + M
iris
str(iris)
iris %>%  head
head(iris)
1:10 %>% mean
# 첫번째 인수로 데이터프레임을 갖는 함수들에 적용하면 편함
a1 <- select(airquality, Ozone, Temp, Month)
a2 <- group_by(a1, Month)
a3 <- summarise(a2,
                Mean.Ozone=mean(Ozone, na.rm=T),
                Mean.Temp=mean(Temp, na.rm=T))
a4 <- filter(a3, Mean.Ozone > 40 | Mean.Temp > 80)                 

air <- airquality %>% 
  select(Ozone, Temp, Month) %>% 
  group_by(Month) %>% 
  summarise(Mean.Ozone=mean(Ozone, na.rm=T),
            Mean.Temp=mean(Temp, na.rm=T)) %>% 
  filter(Mean.Ozone > 40 | Mean.Temp > 80)     
air

