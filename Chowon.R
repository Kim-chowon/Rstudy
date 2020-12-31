######데이터 구조######

#벡터는 동일한 유형의 데이터를 원소로 갖는 집합 ex)숫자벡터, 문자벡터, 논리값벡터
c(1,2,3,4,5)

#팩터는 범주형값을 원소로 갖는 데이터 집합
c("A", "B", "C", "A", "B") 
#등급
factor(c("A", "B", "C", "A", "B")) 
#서열팩터가 될 수도

#행렬은 2차원 벡터 집합
matrix(1:12, 3,4)

#배열은 3차원 벡터 집합
array(1:12, c(2,3,2))   #2*3 행렬이 2개

#데이터프레임은 2차원 집합, 열마다/행마다 원소 유형 달라도 됨(행렬과 차이)
data.frame(product=c("A", "B", "C"),
           price=c(100,200,300))

#리스트는 객체 집합. 자료주머니. 어떤 데이터든 들어갈 수 있음. 개수 상관 없음.
list(x=c("A", "B", "C", "A", "B"),
     y=matrix(1:12, 3,4),
     z=data.frame(product=c("A", "B", "C"),
                  price=c(100,200,300))
)




######벡터 생성######
#c()는 인수로 주어진 벡터들을 서로 결합
c(1,2,3,4,5,6,7,8,9,10)
c("we", "love", "data", "analytics")
c(TRUE, FALSE, TRUE, FALSE)

#여러개의 원소를 갖는 벡터들을 결합할 수도 있음
odd <- c(1,3,5)
even <- c(2,4,6)
c(odd, even) #원래 순서대로

3:9
9:-1

seq(from=3, to=9)
seq(from=3, to=9, by=2)
seq(from=3.5, to=1.5, by=-0.5)

seq(from=0, to=100, length.out=5)
#0부터 100까지 원소의 개수는 5개
seq(from=-1, to=1, length.out=5)
#간격은 자동으로 계산

rep(1, times=3)
rep(c(1,2,3), times=3)        #인수를 세번 반복해줘
rep(c(1,2,3), each=3)         #각각을 세번씩 사용해줘
rep(c(1,2,3), times=c(1,2,3)) #각각을 n번씩 사용해줘
rep(c(1,2,3), length.out=8)   #각각을 여러번 사용해서 8개 원소를 만들어줘

num <- c(1,2,3)
cha <- c("x", "y", "z")
c(num, cha) #숫자를 문자로 바꿔버림

#벡터의 유형과 내부구조 파악
str(num) 
str(cha) #chr은 문자벡터(charactor)

#벡터의 길이 = 원소의 개수
length(num)

#상수벡터
LETTERS
letters
month.name
month.abb
pi

month <- c(12,9,3,5,1)
month.name[month]
#[]는 인덱싱




######벡터 연산######
#R의 모든 작업은 함수를 벡터에 개별적으로 처리하는 방식 = 벡터연산
1 + 2
"+"(1,2)

c(1,2,3) + c(4,5,6)
c(1,2,3) * c(4,5,6)
c(1,2,3) - c(4,5,6)
c(10,20,30) / c(4,5,6)
c(10,20,30) %% c(3,5,7) #나머지
c(10,20,30) %/% c(3,5,7) #몫

#만약 앞뒤 벡터의 길이가 다르면?
#길이가 짧은 쪽 벡터를 반복 사용하는 규칙
c(10,20,30) + c(1,2,3,4,5,6)
c(10,20,30,10,20,30) + c(1,2,3,4,5,6)
c(1,3,5) * 10

#백터의 길이가 배수여야 함
c(1,2,3) + c(4,5,6,7,8)

== 
  != #같지않냐
  <
  >
  <=
  >=
  !x    #x가 아니다
x | y #x or y
x & y #X and y
isTRUE()

v <- pi
w <- 10/3
(v == w) | (v < w)
(v == w) & (v < w)
v == w
isTRUE(v==w)
is.

y <- c(0,25, 50, 75, 100)
z <- c(50,50,50,50,50)
y == z
y != z
y > z
y < z
y == 50

as.numeric(TRUE) #인수를 숫자로 변환하는 함수
as.numeric("a")
as.numeric(FALSE)
TRUE + TRUE
TRUE * TRUE
TRUE * FALSE

y <- c(0,25, 50, 75, 100)
y > 50
sum(y > 50) #TRUE의 값을 합하면, TRUE의 개수를 셀 수 있따

#반환된 논리값 중 일부 또는 전부가 TRUE인지 알고싶을 때
any(-3:3 > 0)
all(-3:3 > 0)

sqrt(2)^2 == 2
sqrt(2)^2 - 2
#같아야 하는 두 숫자도 다르게 인식하는 경우가 있다. (반올림때문에 미세한 차이 발생)
all.equal(sqrt(2)^2, 2) #매우 작은 반올림 오차를 무시하는 함수
all.equal(sqrt(2)^2, 2.2) #차이가 매우 작지않으면 쓸모x
isTRUE(sqrt(2)^2==3)    

fruit <- c("Apple", "Banana", "Strawberry")
food <- c("Pie", "Juice", "Cake")
paste #문자열 붙여주기
paste(fruit, food)
paste(fruit, "Juice")



######벡터함수######
abs(-3:3) #절댓값
log(1:5)  #자연로그(밑수가 자연상수 E인 로그)
log(1:5, base=exp(5))
log2(1:5)
log10(1:5)
exp(1:5)  #자연상수 E를 밑수로 한 지수값 (지수함수)
y <- exp(1:5)
log(y) #로그함수와 지수함수는 역의 관계

factorial(1:5)
choose(5,2) #5개 중에서 2개 뽑는 경우의 수

sqrt(1:5)

options("digits")
pi

signif(456.789, digits=2) #유효자릿수 두자리로 출력, 반올림
signif(456.789, digits=3) 

round(456.789, digits=2) #소수점이하 둘째자리까지 출력(셋째자리에서 반올림)
round(456.789)
round(sqrt(1:5), digits=2)
round(456.789, digits=-1) #10^2 자릿수까지 출력

#반올림자릿수에 5가 있으면, 가장 가까운 짝수로 반올림 해버림
round(12.5)
round(10.5)
round(11.5)
round(-3.5)

floor(12.75)  #가장 가까운 정수로 내리기
ceiling(-3.7) #가장 가까운 정수로 올리기
trunc(456.78) #0에 가까운 정수로 올리거나 내리기
trunc(-456.78)

##결측값처리
Inf  #양의 무한대
-Inf #음의 무한대
3/0
5 - Inf

is.infinite() #무한대인지 알아보는 함수
#R에서는 컴퓨터가 다룰 수 있는 수보다 크면 무한대로 간주
1.8*10^308
is.infinite(10^(305:310))

Inf/Inf
Inf * 0
log(-2)
#NaN = Not a Number 계산결과를 정의할 수 없다
is.nan(NaN + 3) #값이 NaN이냐?

#NA = Not Available 결측값
k <- NA
k + 5
sqrt(k)

k == NA  #NA로 논리연산자 이용하면 값은 다 NA
is.na(k) #NA인지 알아보려면 쓰는 함수
is.na(k + 5)
is.na(NaN)

#8강 25분까지 봤음

#벡터 원소 전체를 대상으로 하는 함수
z <- 1:5
sum(z)
prod(z)
max(z)
min(z)
mean(z)
median(z)
range(z)
var(z)
sd(z)

#결측값
w <- c(1,2,3,4,5,NA)
sum(w)

sum(w, na.rm=TRUE) #결측값은 빼고 해라
sum(na.omit(w))

#결측값만으로 구성된 벡터
v <- c(NA,NA,NA,NA,NA,NA)
v
sum(v, na.rm=T)
prod(v, na.rm=TRUE)
max(v, na.rm=TRUE)
min(v, na.rm=TRUE)
#에러가 안나오니 주의!

traffic.death <- c(800, 900, 300, 200, 100, 788, 101)

cumsum(traffic.death)
cumprod(traffic.death)
cummax(traffic.death)
cummin(traffic.death)
#누적연산함수에서는 NA처리 못함
cumsum(c(3,5,1,NA,2,6))

diff(traffic.death) #인접한 두 원소 간의 차이
diff(c(3,5,1,NA,2,6))
diff(1:5, lag=2)    #차이를 구하고자 하는 원소 간 거리를 지정할 수 있음

#집합연산
p <- 1:10
q <- 6:15
union(p,q)     #합집합
intersect(p,q) #교집합
setdiff(p,q)   #차집합
setequal(p,q)  #두 집합 같냐
is.element(setdiff(p,q), p)  #첫번째 인수가 두번째 인수에 속했냐


#######벡터인덱싱######
#특정 위치의 원소 선택하기
num <-  0:30
num
prime <- c(2,3,5,7,11,13,17,19)
prime[3]
prime[c(1,1,5,5)]
prime[4:6]
prime[c(7,5,3)]

indices <- c(1,3,5,7)
prime[indices]
prime[-1]    #제거하고 추출
length(prime)
prime[1:(length(prime)-1)] #마지막 원소 제외
prime[-length(prime)]      #마지막 원소 제외

#원소 변경하기
prime <- c(2,4,5,7,NA,11,14,17,18)
prime[5] <- 23
prime
prime[c(6,8)] <- c(13, 19)
prime

#원소 추가하기 #마지막 인덱스 다음 위치에 값 할당 #벡터 길이 확장
prime <- c(2,3,5,7,11,13,17,19)
length(prime)
prime[9] <- 23
prime[15] <- 47
prime

##논리연산 이용해서 인덱싱

#TRUE 위치에 있는 원소 추출
prime <- c(2,3,5,7,11,13,17,19)
prime[(prime < 10)]
prime[prime %% 2 == 0]

#매n번째 원소 추출
seq_along(prime) #인수로 주어지는 벡터의 길이만큼의 정수를 생성
prime[seq_along(prime) %% 2 == 0]
prime[seq_along(prime) %% 3 == 0]

prime[c(F, T)]  #원소를 반복사용
prime[c(F, F, T)]

#해당 위치의 인덱스를 보고싶어
which()
which.max()
which.min()
#which함수는 논리값을 인수로 #조건을 충족하는 인덱스를 알려줌
rainfall <- c(21, 23, 45, 77, 102, 133, 327, 348, 137, 49, 23, 20)
which(rainfall > 100)
month.name[which(rainfall > 100)]
which.max(rainfall)
month.abb[which.max(rainfall)]
month.abb[which.min(rainfall)]

#조건을 충족하는 인덱스의 값은?
rainfall[rainfall > 100]
rainfall[which.min(rainfall)]

#벡터의 각 원소에 고유의 이름 지정
traffic.death
names(traffic.death) <- c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
traffic.death
traffic.death["Sat"]
weekend <- c("Sat", "Sun")
traffic.death[weekend]

names(rainfall) <-  month.name

traffic.death[traffic.death > 800]
names(traffic.death[traffic.death > 800])

#######팩터####
#요로케 하니까 스크립트 상에서 소제목?이 만들어지네용

#범주형데이터 #Levels를 원소로 하는 백터
review <- c("Good", "Good", "Indifferent", "Bad", "Good", "Bad")
review
factor(review) #문자벡터나 숫자벡터를 팩터로 변환할 때, 이 함수의 인수로 제공하면 됨
review.factor <- factor(review) 
review.factor

str(review.factor)
# Factor w/ 3 levels "Bad","Good","Indifferent": 2 2 3 1 2 1
# 알파벳 순서대로 출력되고 숫자 부여됨
as.numeric(review.factor)

eventday <- c("Mon", "Mon", "Tue", "Wed", "Mon", "Wed", "Thu", "Fri", "Tue")
eventday.factor <- factor(eventday)
eventday.factor 
#벡터의 원소만 가지고 Levels를 출력 
#가능한 Levels 내가 선언할 수 있다. #내가 선언한 순서대로
eventday.factor <- factor(eventday,
                          levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"),
                          ordered=T)
eventday.factor
str(eventday.factor)

#팩터의 levels만 보고싶다
levels(review.factor)
levels(eventday.factor)

#levels의 이름도 바꿀 수 있다 #Levels선언 얘도 가능
levels(review.factor) <- c("B", "G", "I")
review.factor

#levels의 개수를 알고싶다
nlevels(review.factor)
length(levels(review.factor))

#서열팩터 만들기
eval <- c("Medium", "Low", "High", "Medium", "High")
eval.factor <- factor(eval) 　　　#알파벳 순서로 levels 형성
eval.ordered <- factor(eval, 
                       levels=c("Low", "Medium", "High"),
                       ordered=T) 
　　　　　　　　　　　　　　　　　#순서의미부여해서 levels 형성

#범주별 빈도 분석
table(eval.factor)
table(eval.ordered)

#숫자벡터 팩터 변환
sex <- c(2,1,2,2,1,0)
sex.factor <- factor(sex, levels=c(1,2),
                     labels=c("Male", "Female"))
table(sex.factor)

#######행렬 생성#######
#벡터에 차원을 부여하면 행렬
v <- 1:12
dim(v) <- c(3,4)
v

v <- 1:12
matrix(data=v, nrow=3, ncol=4)
matrix(v, 3, 4)
#열방향으로 숫자 채워짐
#행방향으로 채워주고 싶으면
matrix(v, 3, 4, byrow=T)


rnames <- c("R1", "R2", "R3")
colnames <- c("C1", "C2", "C3", "C4")
matrix(v, 3, 4, 
       dimnames=list(rnames, colnames))
#어제 한거랑 비교

z <- matrix(1:6, 3, 2)
rownames(z) <- c("r1", "r2", "r3")
colnames(z) <- c("c1", "c2")
z

#벡터의 원소의 개수와 행or열 개수 이용
mat <- matrix(v, ncol=4)
str(mat)

#행,열 개수 확인
dim(mat)
dim(mat)[1] #행의개수
nrow(mat)
dim(mat)[2] #열의개수
ncol(mat)
length(mat) #셀의개수

#벡터를 결합해서 행렬만들기
v1 <- c(1,2,3,4,5)
v2 <- c(6,7,8,9,10)
rbind(v1, v2)
cbind(v1, v2)
matrix(11:20, 5, 2)
cbind(v1, v2, mt <- matrix(11:20, 5, 2))
rbind(matrix(1:6, 2, 3), matrix(7:12, 2, 3))
getwd()

#######행렬 연산#######
#행렬은 제가 몰라서 다음에...

getwd()
#######리스트#######
#자료형태, 개수 상관 없이 담을 수 있음
list(0.68, 0.95, 0.99, 
     "Apple", 
     c(2,3,4,5), 
     matrix(1:6, ncol=3), 
     mean(1:10))

lst <- list()
lst
lst[[1]] <- 1.23
names(lst) <- c("c1")
length(lst)

#리스트 결합
c(lst1, list2)

a <- list(1,2,3,4,5,6,7)
a
mean(a)         #벡터를 필요로 하는 함수
mean(unlist(a)) #리스트를 해체해서 벡터로

[[]] #원소(자료) 내 데이터값 추출
[]   #원소(자료)를 추출

product <- list("A", 30000, "Nice")
product[[3]]
product[3]
class(product[[3]])
class(product[3])

#이름
product <- list(id="A", 
                price=30000, 
                eval="Nice")
product
product$id
product[["id"]]

#원소 내용 바꾸기
product[[2]] <- 40000
product[["price"]] <- 40000
product$price <- 40000
product[2] <- 40000
product
#여러 값 할당할 때는 [[]]
product[[2]] <- c(30000, 40000)
product[2] <- list(c(30000, 40000))

product[[5]] <- c("Domestic", "Export")
product[5] <- list(c("Domestic", "Export"))

product$madein <- c("Korea", "China")

product

#지울 때
product[[5]] <- NULL


######데이터프레임생성######
#행렬+리스트
v1 <- c("A", "B", "c")
v2 <- c("MOuse", "Keyboard", "USB")
v3 <- c(3000, 9000, 10000)
data.frame(v1, v2, v3) #열이름 반드시 있어야 함
products <- data.frame(row.names=v1, v2, v3) #행이름으로 쓰기

data.frame(id=v1, name=v2, price=v3) #열이름 지정
str(products)
#문자데이터를 팩터로 변환
# 인자로 stirngsAsFactors=F 하면 팩터로 변환 안됨


#행렬을 데이타프레임으로
mat <- matrix(c(1,3,5,7,9,
              2,4,6,8,10,
              2,3,5,7,11), ncol=3)
mat
number <- as.data.frame(mat)
number
#열이름 자동생성
colnames(number) <- c("odd", "even", "prime")
number

#리스트를 데이타프레임으로
v1 <- c("A", "B", "c")
v2 <- c("MOuse", "Keyboard", "USB")
v3 <- c(3000, 9000, 10000)
lst <- list(v1, v2, v3)
lst
product_datafrm <- as.data.frame(lst)
colnames(product_datafrm) <- c("id", "name", "price")
product_datafrm

nrow(product_datafrm)
ncol(product_datafrm)
length(product_datafrm)

######데이터확장######
id <- c("A", "B", "c")
name <- c("MOuse", "Keyboard", "USB")
price <- c(3000, 9000, 10000)
product <- data.frame(id, name, price,
                      stringsAsFactors = F)
product
#행방향확장
rbind(product,
      c("D", "Monitor", 250000))
rbind(product,
      new_rows)
#열방향확장
cbind(product,
      madein=c("KOR", "CHI", "USA", "KOR", "KOR", "USA"))
cbind(product,
      new_cols)

#####날짜#####
Sys.Date()
date()
Sys.time()

class(Sys.Date())

#텍스트를 날짜로
as.Date("2020-12-31") 
YYYY-MM-DD 
YYYY/MM/DD
as.Date("12/31/2020", format("%m/%d/%y"))
?strptime

today <- Sys.Date()
format(today, format="%Y/%m/%d/%A")

weekdays(today)
someday <- today + 100
format(someday, format="%A")
      
start <- as.Date("2020-12-31")
end <- as.Date("2021-01-31")
seq(start, end, 2)
seq(start, by=2, length.out=7)
seq(start, by="week", length.out=7)
seq(from=as.Date("2021-01-01"), by="3 months", length.out=4) #분기

months(start)
quarters(start)

#locale환경
Sys.getlocale()
LC_TIME=Korean_Korea.949 
Sys.setlocale("LC_TIME", "C") #북미표준
weekdays(today)
Sys.setlocale() #다시 원래대로

#시간정보 포함
pct <- as.POSIXct("2021/03/26, 16:00:01",
                  format="%Y/%m/%d, %H:%M:%S")
pct
plt <- as.POSIXlt("2021/03/26, 16:00:01",
                  format="%Y/%m/%d, %H:%M:%S")
plt
class(plt)
unclass(plt)
as.POSIXlt(as.Date("2021-03-26"))
as.POSIXlt(as.Date("2021-03-26"))$wday
as.POSIXlt(as.Date("2021-03-26"))$yday
as.POSIXlt(as.Date("2021-03-26"))$year + 1900
as.POSIXlt(as.Date("2021-03-26"))$mon + 1

strptime("2021-03-26", format="%Y-%m-%d")

y <- 2020
m <- 12
d <- 31
ISOdate(y, m, d) #날짜개체로

