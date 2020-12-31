blood.vec <- c("A",
               "AB",
               "A",
               "O",
               "B")
blood.type <- factor(blood.vec)
blood.type
is.factor(blood.type)

blood.type[6] <- "D" #D를 넣으면 에러가 나고, <NA>로 대체된다.
blood.type

#factor값은 순서대로 숫자로 변환하여 사용할 수 있다.
as.numeric(blood.type)
#[1]  1  2  1  4  3 NA

#read.csv로 읽어오면 factor로 저장된다.

levels(blood.type)
# [1] "A"  "AB" "B"  "O" 
levels(blood.type)[2]
# [1] "AB"

