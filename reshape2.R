rm(list=ls())

# 데이터셋의 형태를 변환할 때 이용하는 패키지
# 데이터셋 형태: Wide format / Long format

#### 부록: 그림 불러오기 ####
install.packages("jpeg")
library(jpeg)
getwd()
setwd("C:/Users/user/Documents/R projects/Rstudy")
img <- readJPEG("dataformat.jpg")
plot(1:2, type='n')
rasterImage(as.raster(img), 1.2, 1.27, 1.8, 1.73, interpolate=FALSE)
# 래스터 그래픽=비트맵
?rasterImage

#### reshape2 ####
wideformat <- data.frame(country=LETTERS[1:10], 
                            import=seq(110, 200, 10), 
                            export=seq(130, 320, 20))
wideformat
# 옆으로 변수들이 나란히 배열

longformat 
# 데이터 셋에 포함된 모든 변수 목록을 나타내는 하나의 열과 이들 변수의 데이터값을 갖는 또 하나의 열
# wideformat의 데이터를 2개의 열 만으로 표현
# 변수의 개수가 증가하면 밑으로 길어짐

# 함수들마다 요구하는 포맷이 다르다.
# R에서는 Longformat 사용 많음 (ex.ggplot2)

install.packages("reshape2")
library(reshape2)
melt()  # wide -> long
dcast() # long -> wide

#### melt() ####
smiths # 전형적인 wide format
melt(smiths)
# Using subject as id variables 
# subject를 식별자 변수로 사용했다 = 변수 바뀔때마다 반복되는 애
# factor나 문자형 변수를 식별자변수로 사용(default)
?melt
# 데이터셋의 형태에 따라 내부함수 적용 달라짐 
# dataframe용 함수를 살펴보자
melt(
  data,          # wide 데이터셋 
  id.vars,       # 식별자변수 지정
  measure.vars,  # 측정변수 지정(식별자변수 나머지, 둘 중 하나만 지정하면 됨)
  variable.name = "variable", # 변수목록의 이름
  ...,          
  na.rm = FALSE,
  value.name = "value",       # 데이터값 목록의 이름 
  factorsAsStrings = TRUE
)

smiths
library(tidyverse)
smiths.long <- smiths %>% melt(id.vars = "subject",
     measure.vars = c(2:5),
     variable.name = "var",
     value.name = "val")

# 예쁘게 ctrl shft a
smiths.long <- smiths %>% melt(
  id.vars = "subject",
  measure.vars = c(2:5),
  variable.name = "var",
  value.name = "val"
)

smiths.long
melt(smiths)

#### dcast() ####
dcast(smiths.long)
?dcast

dcast(
  data,     # long format 데이터셋
  formula,  # ~(틸다?) 식별자변수 ~ 측정변수
  fun.aggregate = NULL,
  ...,
  margins = NULL,
  subset = NULL,
  fill = NULL,
  drop = TRUE,
  value.var = guess_value(data)
)

dcast(smiths.long, subject ~ var)
# Using val as value column: use value.var to override.
# 지정하지 않으면 마지막 열을 측정값이 들어간 열로 간주
dcast(smiths.long, subject ~ var,
      value.var="val")

head(airquality)
aq.long <- melt(airquality, 
                id.vars = c("Month", "Day"))
head(aq.long)
tail(aq.long)

aq.wide <- dcast(aq.long,
                 Month + Day ~ variable,
                 value.var = "value")
head(aq.wide)
airquality

# 포맷변환시 하나의 셀에 여러개의 값이 들어가는 문제 나타날 수 있다
# 식별자변수 똑같은거 여러개일 경우

dcast(aq.long, Month ~ variable)
# Aggregation function missing: defaulting to length
# 무슨 함수 적용해야하는지 모르겠으니까 우선 length() 적용했다는 뜻
dcast(aq.long, Month ~ variable,
      fun.aggregate=mean, na.rm=T)


library(reshape2)
rma <- fread('C:\\Users\\user\\Documents\\R projects\\Rstudy_Lee\\ch09\\Ch0902.RMA.csv')
rma <- as.data.frame(rma)
rma.wide <- reshape2::dcast(rma, id ~ time)
str(rma.wide)
