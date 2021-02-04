#### 나이브베이즈(Naive Bayes) ####

# 베이즈정리(Bayes' theorem) 바탕으로
# 관심 있는 사건이 발생할 확률 추정
# 사전에 알고 있는 정보(예측변수)를 바탕으로
# 특정 사건(결과변수)이 발생할 확률을 계산
# 사건에 해당하는 결과변수는 범주형 변수이어야 하며,
# 예측변수는 범주형 변수를 가정

# 경험에 기반한 선험적, 불확실성 내포하는 수치 기반
# 추가정보를 바탕으로 사전확률 갱신
# 귀납적 추론 방법

#packages install (신비한 방법)
if(require("mlbench")   == F) install.packages("mlbench")
if(require("dplyr")     == F) install.packages("dplyr")
if(require("MASS")      == F) install.packages("MASS")
if(require("e1071")     == F) install.packages("e1071")

# 라이브러리
library(mlbench) # 활용할 데이터셋
library(dplyr)
library(MASS)
library(e1071) # 베이지안 모델에 활용 알고리즘
library(stats)
# install.packages("pacman")
pacman::p_load('mblench', "dplyr", "MASS", "e1071", "stats") # 전왜안되죠

# 데이터
set.seed(1234)

data("HouseVotes84")
votes <- HouseVotes84
str(votes)

# 16개 안건에 대한 찬성반대로 구분되어 있음 (n,y 1,2)
# 각 국회 소속 정당에 대한 정보 저장 (class)
# 안건에 대한 찬성반대로 소속정당을 예측할 수 있을까?
# 찬반 투표결과에 따른 정당차이

# 첫 번째 안건 확인해보겠다.

library(ggplot2)
vote1 <- na.omit(votes[,c(1,2)])              # 결측값 제외한 저장
vote1$V1 <- factor(vote1$V1,                  # 
                   levels = c("n", "y"),       # 
                   labels = c("No", "Yes"))    #                   

ggplot(vote1, aes(x=V1, fill=Class)) +        # 정당별로 다른 색으로 표현(fill)
  geom_bar(position = "dodge", width = 0.7) + # 막대그래프
  labs(title = "Pros and Cons for Vote 1",    # 
       x = "Vote 1",
       y = "Number of Congressmen",
       fill = "Party")      # 정당별 다른 색

# 국회의원들 투표 성향에 따라 예측할 수 있겠다!
# 분석 전 결측값 제거 : 결측값을 같은 정당 소속 의원들의 안건찬성비율로 대체
head(votes) 
sum(is.na(votes))

# col 안건 cls 정당
# 안건별 정당별 결측값의 개수를 반환하는 함수
naCount <- function(col, cls) {                       # col 안건 cls 정당
  return(sum(is.na(votes[,col]) & votes$Class==cls))  # T 값 합산하여 출력
}                                                     # na인지, 그 정당과 일치하는지 체크해서 트루이면 합산
# 인수로 주어진 정당이자, na이면 합산한다는 뜻
naCount(2, "democrat") # 2번째 열(1번째 안건)에 대한 민주당 결측값
naCount(2, "republican") # 2번째 열(1번째 안건)에 대한 공화당 결측값

# 결측값을 안건찬성비율로 대체
# 안건별 정당별 찬성비율을 반환하는 함수
yesProb <- function(col, cls) {
  sum.y <- sum(votes[,col]=="y" & votes$Class==cls, na.rm = T) # 찬성하면서, 그 정당이면 합산
  sum.n <- sum(votes[,col]=="n" & votes$Class==cls, na.rm = T) # 반대하면서, 그 정당이면 합산
  return(sum.y/(sum.y+sum.n))                                  # 찬성비율 계산해서 리턴
}
yesProb (2, "democrat")
yesProb (2, "republican")


# 결측값 채우는 함수를 모든 안건에 대해 실행
set.seed(123) # 난수 초기값 설정
for (i in 2:ncol(votes)) {         # 두번째 열부터 마지막 열까지 루프
  if(sum(is.na(votes[,i])) > 0) {  # 결측값이 포함되어 있으면,
    d.na <- which(is.na(votes[,i]) & votes$Class=="democrat")   # 대체할 행 추출(na가 들어있는 행이고, 민주당)
    r.na <- which(is.na(votes[,i]) & votes$Class=="republican") # na가 들어있는 행이고, 공화당
    votes[d.na, i] <- ifelse(runif(naCount(i, "democrat"))      # na개수만큼의 난수(0과1 사이의 값)를 생성
                             < yesProb(i, "democrat"), "y", "n") # 각 난수값과 찬성비율을 비교, 찬성비율보다 작으면 y, 크면 n으로 대체 
    votes[r.na, i] <- ifelse(runif(naCount(i, "republican"))
                             < yesProb(i, "republican"), "y", "n")
  }
}

?runif
sum(is.na(votes))
head(votes)

set.seed(123)
train <- sample(nrow(votes), 0.7*nrow(votes))
votes.train <- votes[train,]
votes.test <- votes[-train,]
table(votes.train$Class)
table(votes.test$Class)
# 비슷비슷하게 선정

# install.packages("e1071")
library(e1071)
votes.nb <- naiveBayes(Class ~ ., data=votes.train)
# 결과변수와 예측변수는 모두 범주형 변수여야 한다

votes.nb # 각 안건별 찬반비율

# 얼마나 맞아 떨어지는가 확인
votes.nb.pred <- predict(votes.nb, newdata = votes.test[,-1])

head(votes.nb.pred)

table(votes.test$Class, votes.nb.pred, dnn = c("Actual", "Predicted"))
# 혼동행렬
mean(votes.nb.pred==votes.test$Class)


# 확률 예측
votes.nb.pred <- predict(votes.nb, newdata = votes.test[,-1], type = "raw")
# predict()는 디폴트로 범주를 리턴
# 타입에 로우 입력하면 각 범주 별 예측확률이 나온다
head(votes.nb.pred)

votes.nb.pred <- factor(votes.nb.pred[,"republican"] > 0.5, # 임계값 설정
                        levels = c(FALSE, TRUE),
                        labels = c("democrat", "republican"))
head(votes.nb.pred)
table(votes.test$Class, votes.nb.pred, dnn = c("Actual", "Predicted"))
mean(votes.nb.pred==votes.test$Class)
# 프레딕트랑 값 같다
# 프레딕트도 임계값 0.5이기 때문



# 교차검증 방법 : 여러번 검증
nbRuns <- function(fraction, run) {   # 훈련데이터의 할당비율과 시행횟수를 인수로
  results <- NULL # ???
  for (i in 1:run) {
    train <- sample(nrow(votes), fraction*nrow(votes))
    votes.train <- votes[train,]
    votes.test <- votes[-train,]
    votes.nb <- naiveBayes(Class ~ ., data=votes.train)
    votes.nb.pred <- predict(votes.nb, newdata = votes.test[,-1])
    results[i] <- mean(votes.nb.pred==votes.test$Class)
  }
  return(results)
}

# 비율과 시행횟수 지정
votes.nb.cv <- nbRuns(0.7, 10)
votes.nb.cv
summary(votes.nb.cv)
# mean값 정도의 정확도를 보인다.


?data.frame
# 얼마나 정확한가? 시각화
library(ggplot2)
ggplot(data.frame(acc=votes.nb.cv), aes(x="", y=acc)) +
  geom_boxplot(fill="slategray", color="darkslategray", width=0.5) +
    geom_point(position="jitter", color="royalblue", alpha=0.7) +
  labs(title="Accuracy for Party Prediction with 100 samples",
       y="Accuracy") +
  coord_flip() +
  theme(axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank())

