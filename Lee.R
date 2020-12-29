# 변수선언
tot1 <- 5
tot1

# 변수명을 입력하면 자동으로 나온다

tot2=10
tot2
tot2=tot1 + tot2

# 기존의 값을 업데이트하는 것(기존의 값이 없어지고, 5+10의 결과값 출력)

tot2

1tot

# 변수명은 항상 영어로 시작(대소문자 변경)

# 데이터: 숫자형(1,2,3), 문자형("문자")

# 데이터 숫자형(1,2,3)

num1 <- c(1,2,3,4,5)

# c 행렬 벡터, 여러개의 변수를 동시에 저장하는 방식
# 변수이름은 하나이지만, 그 안에 공간(주소)을 여러개 만들어 놓는 것
# 들어오는 순서대로 공간을 저장함 => 5개의 방을 저장
# 저장만 된다. 출력은 안된다(명령을 내려서 출력해야 한다)

num1 

mode(num1)
typeof(num1)

# double : 소수점 들어가는 것 

# 문자형 ("영어")
char1 <- c("male","femamle")
mode(char1)
typeof(char1)

# 문자형("한글")

char2 <- c("남자","여자")
mode(char2)
typeof(char2)

# 산술연산 

tot1 <- -5
tot2 <- 10

tot1+tot2
tot1-tot2
tot1*tot2
tot1/tot2
tot1^tot2

# 마지막 것은 제곱 **로 해도 됨

# 스칼라

c(1) # c는 소문자로 쓴다
C(1)

# 벡터 (c)- 숫자형

num <- c(1,2,3,4) # c(1:4)
num
numT <- t(num) # 열벡터를 행벡터로 변환
View(num) # 데이터 보기
View(numT)
num %*% numT # 벡터곱셈(4*1 x 1*4) = 4*4
numT %*% num # 벡터곱셈(1*4 x 4*1) = 1*1) 

# 문자형, 논리형

c("m","F","F","M")
c(TRUE, FALSE, FALSE, TRUE)


m <- 1:12
m
m <- c(1:12)

# 행렬 (Matrix 4X3)
mtx <- matrix(m, ncol=4)  #  (m을 가지고 하는데, 4개 열을 만들겠다.  nrow, ncol)
mtx

mtx[3,2] #3열 2행을 출력하라

# 배열 (array 2X3X2) # 열, 행, 깊이 

arr <- array(m, c(2,3,2))
arr

# 데이터 프레임 (Data Frame)

var1 <- c(1,2,3,4)
var2 <- factor(c("M","F","F","M"))  # factor로 해야 그룹변수로 인식한다. 나중에 lable 명령어도 있다. 
df = data.frame(id = var1, sex = var2)
View(df)
str(df)
#$
# 나중에 데이터에서 변수를 뽑아올 때에는 $표시를 한다. date.frame의 변수를 읽는 기본 구조 


# 리스트 텍스트마이님에 활용
v1 <- c(1,2,3,4)
v2 <- matrix(1:12, nrow=4)
v3 <- array(1:12, c(2,3,2))
v4 <- data.frame(id = c(1,2,3,4), sex = c("M","F","F","M"))
lt <- list(number=v1, matrix=v2, kakaka=v3, koko=v4)
lt

str(lt) #str : 데이터 구조를 보여주어라 . [] 벡터와 행렬, [[]] 리스트 형태의 데이터이다. 

save.image()
getwd()
