#텍스트 처리 함수
#문자열 패턴을 바탕으로 텍스트 처리 작업
#패턴검출
#패턴위치정보
#패턴추출
#패턴치환
#패턴분할

string <- c("data anlaytics is useful",
            "business anlaytics is helpful",
            "visualization of data is interesting for data scientists")

grep(pattern="data", x=string, value = T)
string[grep(pattern="data", x=string)]

grep("useful|helpful", string, value=T,
     invert=T) 

grepl() #l은 logic을 의미, 논리값 출력
grepl("useful|helpful", string)
sum(grepl("useful|helpful", string)) #논리값에 sum함수 이용하면 수를 쉽게 셀 수 있음

grepl("new", state.name, ignore.case=T) #대소문자 구분 말아라
sum(grepl("new", state.name, ignore.case=T))

regexpr() #텍스트 벡터의 각 원소에서 첫번째 매칭 위치와 길이 
regexpr(pattern="data", text=string)

[1]  1 -1 18 #첫번째 매칭이 이루어지는 시작 위치
[1]  4 -1  4 #매칭된 패턴의 길이
 
gregexpr(pattern="data", text=string) #리스트 형식


regmatches() #패턴추출
regmatches(x=string, m=gregexpr("data", string)) #위치정보와 길이정보

sub(pattern="data", replacement="text", x=string)
gsub("data", "text", x=string)

strsplit(x=string, split=" ") #리스트구조
unlist(strsplit(x=string, split=" "))
unique(unlist(strsplit(x=string, split=" ")))
       
       