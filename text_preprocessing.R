#텍스트 #한개 또는 여러개의 문자 #string
fox.says <- "It is only with the HEART that one can see rightly"
fox.said <- "What is essential is invisible to the eye"
prince1 <- "You come at four in the afternoon, the at three I shall begin to be happy"
pirnce1 <- "One runs the risk of weeping a little, if one lets himself be tamed"
prince2 <- "What makes the desert beautiful is that somewhere it hides a well"
txt <- "Data Analytics is useful. Data Analytics is also interesting"
words <- c()
words2 <- 

x <- "We have a dream"
x
nchar(x) #텍스트의 문자의 개수(공백포함)
length(x) #원소의 개수

y <- c("we","have","a","dream")
nchar(y)
length(y)
nchar(y[4])

sort() #텍스트의 틀을 정렬
letters
sort(letters, decreasing=T)

tolower(LETTERS) #모두 소문자로
toupper(letters) #모두 대문자로

strsplit(x, split=" ") #텍스트 분할, 리스트 형식으로 출력 
","
""
":" 
"\t"
unlist(strsplit(x, split=" "))
I.said <- unlist(strsplit(x, split=" "))
I.said

paste()    #텍스트 결합

prince1 <- "You come at four in the afternoon, the at three I shall begin to be happy"
prince2 <- "One runs the risk of weeping a little, if one lets himself be tamed"
prince3 <- "What makes the desert beautiful is that somewhere it hides a well well"
littleprince <- c(prince1, prince2, prince3)
strsplit(littleprince, " ")
#리스트구조

strsplit(littleprince, " ") [[3]]
strsplit(littleprince, " ") [[3]][[5]]

unique() #중복아닌 것 #대소문자 구별
tolower(strsplit(littleprince, " ") [[3]])
unique(tolower(strsplit(littleprince, " ") [[3]]))

paste("Everybody", "wants", "to", "fly")
paste("Everybody", "wants", "to", "fly", sep="")
paste0("Everybody", "wants", "to", "fly")

paste("Type", 1:5)

heroes <- c("Batman", "Superman", "Spiderman")
paste(heroes, "wants", "to", "fly", collapse = ", and ") #결합된 원ㅗ들 결합

outer() #모든 가능한 조합을 행렬로 #기본은 곱하기
outer(c(1,2,3), c(1,2,3))
asian.countries <- c("Korea", "Japan", "China")
info <- c("GDP", "Population", "Area")
outer(asian.countries, info)
outer(asian.countries, info, FUN=paste, sep="-")
as.vector(outer(asian.countries, info, FUN=paste, sep="-")
)

x <-  outer(asian.countries, info, FUN=paste, sep="-")
x
x[!lower.tri(x)] #대각선의 아랫부분의 반대만  추출
                 #중복 제거

sprintf() #변수와 텍스트를 섞어 쓰기 좋음
customer <- "Chowon"
buysize <- 10
deliveryday <- 3

paste("Hello,", customer, ", your order of", buysize, "product(s) will be delivered within", deliveryday, "day(s)", 
      sep=" ")

sprintf("Hello %s your order of %s product(s) will be delivered within %s day(s)",
        customer, buysize, deliveryday,
        sep=" ")

students <- c("Cho", "Kim", "Lee")
midterm <- c(10, 20, 30)
hw <- c(3,2,1)
sprintf("Hello %s, your midterm score is %s and you have to do %s homework(s)",
        students, midterm, hw,
        sep=" ")

substr() #문자열의 부분집합
substr("Data Analytics", start=1, stop=4)
substr("Data Analytics", start=6, stop=nchar("Data Analytics"))
substring("Data Analytics", 6)

class <- c("Data Analytics", "Data Mining", "Data Visualization")
substr(class, 1, 4) 
substr(class, 1, c(4, 5, 6))

grep() #특정 문자열 포함하는 텍스트 찾기
islands
grep(pattern="New", x=islands) #안나옴
str(islands)

landmasses <- names(islands)
grep(pattern="New", x=landmasses)

landmasses[grep(pattern="New", x=landmasses)]
grep(pattern="New", x=landmasses, value=T)

#찾아 바꾸기
sub()
gsub()
txt <- "Data Analytics is useful. Data Analytics is also interesting"

sub(pattern="Data", replacement="Business", x=txt)
gsub("Data", "Business", txt)

#패턴인수 
#정규 표현식: 특정한 규칙을 갖는 문자열 패턴을 표현하는 방법
#메타문자: 정규표현식에 사용되는 특수문자
[:digit:] #0~9숫자
[:lower:] 
[:upper:]
[:alpha:] #A~z
[:alnum:] #A~z0~9
[:punct:] #문장부호
[:balnk:] #space, tab
[:space:] #space, tab, newline, form feed, carriage return
[:print:] #프린트 가능 문자 [:alnum:],[:punct:], [:space:]
[:graph:] #사람이 읽을 수 있는 문자 [:alnum:],[:punct:]
#수량자
? #앞 문자는 없거나 1회 출현
* #앞 문자는 0회 이상 반복
+ #앞 문자는 1회 이상 반복
{n}   #앞 문자는 n회 반복
{n,}  #앞 문자는 n회 이상 반복
{n,m} #앞 문자는 n회 이상, m회 이하 반복
#문자클래스 시퀀스
\w #단어문자
\W #단어문자를 제외한 문자
\d #숫자
\D #숫자를 제외한 문자
\s #스페이스 문자
\S #스페이스 문자를 제외한 문자
\b #단어 양쪽 끝의 빈 문자열
\B #단어 양쪽 끝을 제외한 빈 문자열
\< #단어 시작
\> #단어 끝
  
words <- c("a,
