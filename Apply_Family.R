# 일련의 데이터 원소들에 반복적으로 동일한 작업을 수행할 때
#### apply() ####
lapply()
sapply()
mapply()

?apply
apply(X=배열, 행렬, MARGIN=반복적용 필요한 차원, FUN=반복적용할 함수, ...)

x <- matrix(1:20, 4, 5)
x
# 각 행의 가장 큰 값 찾기
apply(X=x, MARGIN=1, FUN=max) # MARGIN: 1은 행에 대해, 2는 열에 대해
apply(X=x, MARGIN=2, FUN=min)

y <- array(1:24, c(4, 3, 2))
y

apply(y, 1, paste) 
apply(y, 1, paste, collapse=",") # 행에 대하여 # FUN인자 다음에 인자 입력
apply(y, 2, paste, collapse=",") # 행에 대하여 
apply(y, 3, paste, collapse=",") # 테이블에 대하여

apply(y, c(1,2), paste, collapse=",") # 1차원(행)과 2차원(열)이 교차하는 값에 paste()적용

apply(y, c(1,2,3), paste, collapse=",")
# sep과 collapse의 차이?
# 문자로 인식되네 -> 숫자로 바꾸려면?
str(pst)
pst <- apply(y, 1, paste, collapse=",")
as.numeric(pst)
# 안바뀌네..
# 중간에 , 있어서 그럼

# 숫자 중간에 숫자 아닌 것 있을 때, 숫자형으로 변환할 수 없음
# 이럴 때 정규표현식 사용
replc_pst <- gsub(pattern = "[^0-9]", replacement = "", pst)
replc_pst

npst <- as.numeric(replc_pst)
str(npst) 

Titanic
str(Titanic)   #, , $를 보면 차원을 알 수 있다        

apply(Titanic, 1, sum)
apply(Titanic, 4, sum) 
apply(Titanic, "Survived", sum)
apply(Titanic, c(1,4), sum) # 1차원 합을 행으로, 4차원 합을 열로

#### lapply(), sapply() #### 데이터가 리스트 or 데이터프레임 일때

?lapply
lapply() # 리스트로 반환
sapply() # 단순할 경우 벡터나 행렬로 반환(자기가 알아서 판단)

exams <- list(spring18=c(78, 89, 91, 86, 98, 88),
              spring19=c(75, 95, 90, 99, 80),
              spring20=c(98, 97, 95, 89, 90, 78, 89), 
              spring21=c(99, 78, 88, 96))
exams
# 각 학기 학생 수가 궁금하다 -> 원소 별 하나의 데이터 나오는 경우
# length() 함수를 각 학기에 반복 적용하면 되겠다
str(exams)
# 리스트 구조니까 lapply()
lapply(exams, length)
# 꽤 단순하니까 sapply()
sapply(exams, length)

# 각 학기 범위를 알아볼까 -> 원소 별 두 개 이상의 데이터 나오는 경우  
lapply(exams, range)
sapply(exams, range) 

iris
str(iris)
sapply(iris, mean)

# 사용자 정의 함수 적용 가능
sapply(iris, 
       function(x) ifelse(is.numeric(x), mean(x), "Not a Number"))
?mean
options(digits=1)

#### mapply #### 복수의 데이터 셋 반복적용 가능
               # 주어진 데이터 셋의 원소 쌍을 만들고 적용
mapply(FUN = rep, 1:4, 4:1) #1:4는 함수 적용 대상 #4:1은 반복 횟수
rep(1,4)
rep(2,3)
rep(3,2)
rep(4,1)
        