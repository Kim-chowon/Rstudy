# 부분집합
# 데이터 전처리

#### 인덱싱 이용 ####

$ # 데이터셋의 하나의 원소 추출
  # 데이터 프레임에 적용하면 벡터 반환
  # 리스트에 적용하면 원소 반환

[[]] # 하나의 원소 추출하여 백터 형식으로 반환

[] # 데이터셋으로부터 여러 개의 원소를 리스트/데이터프레임 형식으로 반환

# 리스트 인덱싱
str(mtcars)
mtcars$mpg
mtcars[["mpg"]] #벡터가 그대로 나놈
mtcars["mpg"] # 리스트 형식으로 나옴 
mtcars[c(1,4)]
mtcars[-c(2:10)] #음과 양 한번에 사용 못함 / 2부터 10까지 빼고 나머지는 다 보여주어라. 

# 행렬 인덱싱
str(iris)
iris[1:5, ] # 처음 다섯개의 행 데이터프레임 추출 / 행-열 순서로 입력하는 것 
iris[, c("Sepal.Length", "Sepal.Width")]
iris[, "Sepal.Length"] # 열을 하나만 추출할 경우에 벡터형식으로 나온다
iris[, "Sepal.Length", drop=F] # 원래 구조 유지
iris["Sepal.Length"] # 원래 구조 유지하고 싶으면 리스트인덱싱이 낫다

iris[1:5, c("Sepal.Length", "Sepal.Width")]

# 조건 충족하는 것들만 인덱싱
iris[iris$Sepal.Length > 7, ]
iris[iris$Sepal.Length > 7, c("Sepal.Width", "Species")]

#### 함수 이용 ####
subset(iris,
       subset = (Sepal.Length > 7), # 출력할 행의 조건
       select = c("Sepal.Width", "Species"),# 출력할 열 지정
)


#### 랜덤 샘플 추출 #### 
sample(x=1:10, size=5) # 비복원추출
sample(1:10, 5, replace = T) # 복원추출

<<<<<<< HEAD
a <- sample(20) # 무작위 순열
a
=======
sample(10) # 무작위 순열, 순서를 무작위로 바꾸라
>>>>>>> 0cbb348afd344f08398cac64556823b8861a08a9

# 랜덤샘플을 동일하게
# 난수생성 초기값 지정하면 된다
set.seed(1)
sample(1:10, 5, replace = T)

sample(1:10, 5, replace = T)

set.seed(1)
sample(1:10, 5, replace = T)

# 데이터 프레임으로부터 무작위 표본을 추출하려고 한다 
# 행으로부터 무작위 표본을 얻고자 함
# 그냥 sample함수는 열로부터 무작위 표본이 추출됨
sample(iris,3)
# 5개 열 중 3개의 열이 무작위로 추출
set.seed(2)
# 행번호로 구성된 무작위 서브셋 먼저 만들고
# 이를 인덱스로 이용하여 추출
index <- sample(nrow(iris), 3) # 아이리스의 행의 개수를 대상으로 3개의 행을 무작위 추출
index
iris[index, ]

#### 중복값 제거한 서브셋 ####
duplicated() # 중복 여부를 논리값으로 반환
duplicated(c(1,1,2,2,3,3,4,5,6,7,1)) # 처음출현 = F, 중복되면 T
# R은 각 행을 하나의 값으로 취급한다. 따라서 중복값=중복행
id <- c("A", "B", "C")
name <- c("Mouse", "Keyboard", "USB")
price <- c(30000, 40000, 35000)
product <- data.frame(id=id, name=name, price=price)
product
product <- rbind(product, c("C", "USB", "35000"))
product

duplicated(product) 
product[!duplicated(product), ] # 중복 안된 행만 추출

# 중복된 위치의 인덱스를 먼저 알고 제거하고 싶을 때
which(duplicated(product))
product[-which(duplicated(product)), ]
index <- which(duplicated(product)) # 예쁘게
product[-index, ]

# 중복 원소 파악할 필요는 없을 때
unique(product)


#### 결측값 제거한 서브셋 ####
# 결측값 포함된 데이더프레임으로부터 결측값 포함 행을 제거
str(airquality)
complete.cases(airquality) # 행에 결측값 하나라도 포함되어 있으면 F
airquality.nona <- airquality[complete.cases(airquality),]
airquality.nona

airquality.nona <- na.omit(airquality)
str(airquality.nona)

#### 범주화 ####
cut(x=범주화하고자하는 숫자벡터, breaks=벡터나 정수로 구간을 지정)
cut(x=iris$Sepal.Width, breaks=c(0,1,2,3,4,5))
# Levels: (0,1] (1,2] (2,3] (3,4] (4,5]
cut(x=iris$Sepal.Width, breaks=c(5))
# 임의로 만든 동일한 간격의 5개 구간

# 구간 별 빈도 계산
table(), summary()
iris.cut <- cut(x=iris$Sepal.Width, breaks=c(5))
table(iris.cut)
summary(iris.cut)

iris.cut <- cut(x=iris$Sepal.Width, 
    breaks=c(0,1,2,3,4,5),
    labels=c("Smaller", "Small", "Medium", "Big", "Bigger"))
table(iris.cut)
