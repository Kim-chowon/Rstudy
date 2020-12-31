#csv파일은 칼럼을 콘마로 구분한 포멧이다.
#read.csv 함수로 불러올 수 있다.
#write.csv 함수로 저장할 수 있다.

#write.csv(저장할 변수, "파일이름", 
#             row.names=F(행의 이름을 붙이지 마라), 
#             quote=F(문자열을 저장할 경우 문자열 공백/따옴표 여부))


getwd()
setwd(getwd())
mydata <- read.csv("test.csv")
View(mydata)
myRow1 <- mydata[2,]
myRow2 <- mydata[,3]

mynew <- mydata[,c(2,3)]
mynew
write.csv(mynew,
          "kid_new.csv",
          row.names=F,
          quote=F)
#파일탐색기로 찾아서 읽어오는 방법이 있다.
#mydata2 <- read.csv(file.choose(파일이 있는 폴더 지정),
#                    header=T) #헤더는 칼럼네임을 함께 가져올지 여부
mydata2 <- read.csv(file.choose(파일이 있는 폴더 지정),
                    header=T)

#한글이 포함된 데이터를 깨짐없이 불러오고 싶을 때,
#한글에도 여러 종류가 있다. 인코딩 방법의 대표적 방법이 UTF-8, euc-kr이다.
#euc-kr의 경우 읽지 못하기 때문에 인코딩옵션을 바꿔줘야 한다.
#csv 저장할 때 파일포멧형태를 UTF-8로 저장하면 된다.


