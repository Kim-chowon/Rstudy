# 야드를 미터로 변환하는 함수를 만들어 보겠습니다
transLength <- function(x){
  tlength <- round(x*0.9144, digits = 1) # 소수첫째자리까지 반올림
  result <- paste(tlength, "m", sep="")
  return(result) # 명령어 return: 정의된 함수의 실행 결과를 함수 내에서 작업공간으로 보내는 역할
}

y <- c(100,150,200)
transLength(y)


# return이 없을 경우 값을 확인하려면 print()
transLength <- function(x){
  tlength <- round(x*0.9144, digits = 1) # 소수첫째자리까지 반올림
  result <- paste(tlength, "m", sep="")
}
transLength(100)
print(transLength(100))

#함수를 다른 함수에 넣을 땐 ()붙이면 안돼
trans2 <- transLength  

# 중간에 함수를 벗어나고 싶을 때 return명령어 쓴다
# 숫자가 아닌 문자가 들어오면 함수를 종료하는 함수를 만들어 보겠다
transLength <- function(x){
  if(!is.numeric(x)) return("Not a Number")
  tlength <- round(x*0.9144, digits = 1)
  result <- paste(tlength, "m", sep="")
  return(result) 
}

transLength("A")

#### 함수인수의 특징 ####
# 함수 인수에 Default값 정의할 수 있다.
# 함수 인수는 이름을 가져야 한다.
# 함수 인수 이름을 몰라도 순서를 알면 쓸 수 있다.
# 가변적인 인수 리스트를 지정할 수 있다.

# 멀티 인수
transLength <- function(x, mult, unit){
  tlength <- round(x*mult, digits = 1)
  result <- paste(tlength, unit, sep="")
  return(result) 
}

transLength(y, mult=3, unit="ft")
transLength(y)

# 초기값 지정
transLength <- function(x, mult=0.9144, unit="m"){
  tlength <- round(x*mult, digits = 1)
  result <- paste(tlength, unit, sep="")
  return(result) 
}

transLength(y)

# digit인수 대신 ...
transLength <- function(x, mult=0.9144, unit="m", ...){
  tlength <- round(x*mult, ...)
  result <- paste(tlength, unit, sep="")
  return(result) 
}

transLength(y, digits=2)
transLength(y)
# round()이 초기값이 digits=0이기 때문에 정수로 출력된다. 
# 다른 함수에서 사용하는 인수 이름을 사용하는 게 좋습니다.

# 함수 자체가 인수가 될 수 있따.
# FUN 인수
transLength <- function(x, mult=0.9144, unit="m", FUN=round, ...){
  tlength <- FUN(x*mult, ...)
  result <- paste(tlength, unit, sep="")
  return(result) 
}

# 어제 했던
outer(c(1,2,3), c(1,2,3))
asian.countries <- c("Korea", "Japan", "China")
info <- c("GDP", "Population", "Area")
outer(asian.countries, info, FUN=paste, sep="-")

# 함수 내의 인수는 함수가 종료되면 작업공간에서 사라진다
# 함수는 일시적으로 생성한 로컬환경에서 작업하고, 로컬환경은 함수 종료와 동시에 소멸
# 로컬환경은 현재의 작업환경인 글로벌 환경 안에 포함

ls()

#### 로컬환경과 글로벌환경 ####
x <- 11:15
# 아무 것도 안나와야 정상인 함수
scopetest <- function(x) {
  cat("This is x: ", x, "\n")
  rm(x) #x를 작업공간에서 제거했음
  cat("This is x after removing x", x, "\n")
}

scopetest(x)

scopetest(x=15)
# 로컬환경에서 인수를 먼저 찾는다.
# 15:11 x가 정상적으로 출력된 후, x를 작업공간에서 제거하자, 로컬환경의 x인수는 더이상 없다. 
# 로컬환경에 인수가 없으니 글로벌 환경에서 찾는다. 그러면 11:15가 출력된다. 
rm(list=ls())

# 함수 안의 인수를 먼저 찾고 함수 밖에서 인수를 찾는다는 것
# 인수로 지정된 변수를 구분할 수 있도록 하는 것이 중요
