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
#각 열의 개수는 모든 행에서 동일해야 함
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

y <- c(0,25, 50, 75, 100)
z <- c(50,50,50,50,50)
y == z
y != z
y > z
y < z
y == 50

as.numeric(TRUE) #인수를 숫자로 변환하는 함수
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
all.equal(sqrt(2)^2, 3) #차이가 매우 작지않으면 쓸모x
isTRUE(sqrt(2)^2==3)    

fruit <- c("Apple", "Banana", "Strawberry")
food <- c("Pie", "Juice", "Cake")
paste #문자열 붙여주기
paste(fruit, food)
paste(fruit, "Juice")


######벡터함수######
abs(-3:3) #절댓값
log(1:5)  #자연로그(밑수가 자연상수 E인 로그)
log(1:5, base=exp(1))
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
round(456.789, digits=-2) #10^2 자릿수까지 출력

#반올림자릿수에 5가 있으면, 가장 가까운 짝수로 반올림 해버림
round(12.5)
round(10.5)
round(11.5)
round(-3.5)

floor(12.45)  #가장 가까운 정수로 내리기
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

###
