# dataframe에만 적용할 수 있는 포맷변환패키지
# reshape2보다 향상된 기능

install.packages("tidyr")
library(tidyr)

gather() # melt()와 같음
spread() # dcast()와 같음


head(airquality)
?gather
gather(
  data,
  key = "key",      # 변수 목록 이름
  value = "value",  # 데이터값 목록 이름
  ...,              # 변수리스트, 여기 안넣으면 자동으로 식별자변수
  na.rm = FALSE,
  convert = FALSE,
  factor_key = FALSE
)

aq.long <- gather(airquality,
                  key=Factor,
                  value=Measurement,
                  Ozone:Temp)   # 인덱스 가능 # 콤마로 연결 가능
aq.long <- gather(airquality,
                  key=Factor,
                  value=Measurement,
                  -Month, -Day) # -식별자변수로 변수리스트 입력 대체 가능


head(aq.long)
airquality %>% gather(Factor, Measurement, Ozone:Temp) 


?spread
spread(
  data,
  key,
  value,
  fill = NA,
  convert = FALSE,
  drop = TRUE,
  sep = NULL
)

aq.wide <- spread(aq.long,
                 Factor,
                 Measurement)
aq.wide

#### separate(), unite() ####
separate() # 열 분할함수
unite()    # 열 결합함수

head(iris) # wide
iris.long <- gather(iris, Element, Measurement,
                    -Species)
head(iris.long)
# Sepal.Length를 두개의 열로 변환해보자
? separate
separate( 
  data,  # 분할대상
  col,   # 분할할 열이름
  into,  # 분할되고 나서 열이름
  sep = "[^[:alnum:]]+",  # 문자나 숫자가 아닌것
  remove = TRUE,
  convert = FALSE,
  extra = "warn",
  fill = "warn",
  ...
)

iris.sep <- separate(iris.long,
                     col=Element,
                     into=c("Part", "Measures"))
head(iris.sep)

?unite
unite(data,
      col,  # 결합 후 새롭게 생성할 열이름
      ...,  # 결합할 열들
      sep = "_", #
      remove = TRUE,
      na.rm = FALSE)

iris.unite <- unite(iris.sep,
                    col=Factor,
                    Part, Measures,
                    sep=" ")
head(iris.unite)
