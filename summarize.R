# 데이터셋 내에 집단을 구분하는 변수(factor?)가 포함되어 있을 경우 집단별 데이터 요약 
# 집단별로 데이터 분할해야 집단별로 처리할 수 있따

#### 집단분할_split() ####
head(mtcars)
str(mtcars)

?within
mtcars <- within(mtcars,
                 am <- factor(am,
                              levels=c(0,1),
                              labels=c("Automatic", "Manual")))
str(mtcars)
attach(mtcars)

#auto / manual 별로 연비 변수를 분할
split(x=mpg, f=am)
g <- split(x=mpg, f=am)
g
g[[2]]
g[["Manual"]]
sapply(g, mean)

#### 집단분할_unstack() #### 
# 분할하고자 하는 데이터 벡터와 분할변수가 데이터 프레임 형태여야 함
unstack(data.frame(mpg, am))
# 분할하고자 하는 데이터의 숫자가 같으면 데이터 프레임 형태로 반환해준다
detach(mtcars)

attach(iris)
gg <- unstack(data.frame(Sepal.Length, Species))
gg
head(gg) # Species가 열이 됨
str(gg)
summary(gg)

#### 분할과 연산_tapply(), aggregate() ####
tapply(x=벡터, INDEX=팩터, FUN)

tapply(Sepal.Length, Species, mean)
detach(iris)

# INDEX인수에 범주형 변수 리스트 형식으로 넣을 수 있다
?with #attach()랑 똑같은거
with(mtcars, tapply(mpg, list(cyl, am), mean))
with(mtcars, tapply(mpg, list(cylinder=cyl, Transmission=am), mean))

attach(mtcars)
aggregate(mpg, 
          by = list(cylinder=cyl, Transmission=am), 
          FUN = mean) 
detach(mtcars)

# 여러 열을 한번에 집어 넣기
aggregate(mtcars[1:6],
          list(Group.cyl=mtcars$cyl, Group.am=mtcars$am),
          mean)
aggregate(iris[1:4], list(Species=iris$Species), mean)
          

#### by() ####
# 데이터 프레임을 통쨰로 집어넣기
?by
by(iris, iris$Species, FUN=summary)

#### table() ####
# 범주형 변 수 별로 원소 몇개인지 보기
table(gear, am, cyl)
# 연속형 변수는 안돼요
# 구간으로 만들어서 하면 돼요
cut(mpg, breaks=5)
table(cut(mpg, breaks=5))
