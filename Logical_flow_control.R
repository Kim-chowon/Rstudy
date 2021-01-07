x <- pi
y <- 3
if (x > y) x
if (x < y) x

if else #조건이 트루이면 어떤 일 수행, 트루가 아니면 다른 일 수행 
if (x < y) x else y

# 괄호 안에 하나의 논리값만 가질 수 있기 때문에 벡터연산 수행 불가능
x <- pi
y <- 1:5
if (x < y) x else y

ifelse() # 조건문에 벡터 포함
test <- c(T, F, T, T, F)
yes <- 1:5
no <- 0
ifelse(test, yes, no ) # test를 시험해서 T이면 yes, F이면 no  

switch() # 첫번째 인수의 값에 따라서 두번째 인수로 지정된 코딩을 수행

center <- function(x, type) {
  switch(type,
         mean=mean(x),
         median=median(x),
         trimed=mean(x, trim=0.1),
         "Choose one of mean, median, and trimmed"
  )
}
x <- c(2,3,5,7,11,13,17,19,23,29)
#type의 값에 따라서 mean, median, trimed 세개 중에 하나 수행
center(x, "mean")
center(x, "var")

# 반복-멈춤

i <- 5
repeat {if(i > 25) break
  else {print(i)
              i <-  i + 5}
}
  

i <- 5
while (i <= 25) {
  print(i)
  i <- i + 5
}


for #for문의 형식: (var in list) statement
for (i in seq(5,25,5)) print(i)
# for루프 내에서 생성된 객체는 함수가 종료되어도 사라지지 않는다
i <- 1
for (i in seq(5,25,5)) i 
i
