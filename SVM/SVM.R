#### 예제 1 ####
# 2차원 공간에서 두 종류의 꽃을 분류해보자

iris.sub <- subset(iris,
                   select = c("Sepal.Length", "Sepal.Width", "Species"),
                   subset = Species %in% c("setosa", "virginica"))
# 2차원 공간에서 1차원 초평면 만들거니까 예측변수도 두개만

iris.sub$Species <- factor(iris.sub$Species)
head(iris.sub); tail(iris.sub)


# 관측값을 2차원 공간에서 산점도로 그려보자
library(ggplot2)
ggplot(iris.sub, aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point(aes(color=Species, shape=Species),
             size=2)
# 선형적 분할이 가능하겠구나

# 초평면과 서포트벡터를 찾아보자
install.packages("e1071")
library(e1071)
set.seed(123)
iris.svm <- svm(Species ~ .,     # 결과변수~예측변수
                data=iris.sub,   
                kernel="linear", # 커널함수를 지정. 커널함수는 기본적으로 가우시안RBF커널함수
                                 # 여기서는 차원의 확장 없이 초평면 탐색할 수 있으므로 커널함수로서 선형함수를 지정.
                cost=1,          # 오분류에 대한 패널티 (너무 크면 과대적합, 너무 작으면 과소적합)
                scale=F)         # 데이터를 표준화할테냐?

str(iris.svm)
class(iris.svm)
summary(iris.svm) # 분석결과에 대한 기초적인 정보

 # Number of Support Vectors:  12 
 # 서포트 벡터의 개수

 # ( 6 6 )
 # 두 개 범주에 6개씩 포함

iris.svm$index # 서포트벡터의 인덱스 보기
iris.svm$SV    # 서포트벡터의 관측값 보기
iris.sub[iris.svm$index, ] # 서포트벡터의 범주 보기


# 산점도 상에 서포트벡터 표시하기 
ggplot(iris.sub, aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point(aes(color=Species, shape=Species),
             size=2) +
  geom_point(data=iris.sub[iris.svm$index, c(1,2)],
             color="darkblue",
             shape=21,
             stroke=1.0,
             size=5)


# 초평면 표현하기
# 초평면을 나타내는 직선의 방정식의 계수와 절편은 svm객체에서 찾을 수 있음
str(iris.svm)
w <- t(iris.svm$coefs) %*% iris.svm$SV
w # 계수

b <- iris.svm$rho
b # 절편

ggplot(iris.sub, aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point(aes(color=Species, shape=Species),
             size=2) +
  geom_point(data=iris.sub[iris.svm$index, c(1,2)],
             color="darkblue",
             shape=21,
             stroke=1.0,
             size=5) +
  geom_abline(intercept = b/w[1,2],
              slope=-(w[1,1]/w[1,2]),
              color="dimgray",
              lty="dashed",
              lwd=1)

# 오분류 케이스 찾기

# 범주 예측하기
iris.svm.pred <- predict(iris.svm,         # 예측모델
                         newdata=iris.sub) # 예측할 데이터
head(iris.svm.pred)                    # 예측결과 보기
table(iris.sub$Species, iris.svm.pred, 
      dnn=c("Actual", "Predicted"))    # 얼마나 맞췄나 보기 
?table                                 
mean(iris.sub$Species == iris.svm.pred) # 정확도 보기


# cost값을 변화시켜보기
# 코스트 커지면 서포트벡터 개수 작아짐 -> 오분류 줄어들고 마진 작아지지만 과다적합문제
# 코스트 작아지면 서포트벡터 개수 커짐 -> 오분류 늘어나고 마진 커지지만 과소적합문제
set.seed(123)
iris.svm2 <-  svm(Species ~ .,     
              data=iris.sub,   
              kernel="linear",
              cost=100,          # 코스트 값 늘려
              scale=F)
summary(iris.svm2)
# 서포트벡터 줄어들었다

w <- t(iris.svm2$coefs) %*% iris.svm2$SV

b <- iris.svm2$rho

ggplot(iris.sub, aes(x=Sepal.Length, y=Sepal.Width)) +
  geom_point(aes(color=Species, shape=Species),
             size=2) +
  geom_point(data=iris.sub[iris.svm2$index, c(1,2)],
             color="darkblue",
             shape=21,
             stroke=1.0,
             size=5) +
  geom_abline(intercept = b/w[1,2],
              slope=-(w[1,1]/w[1,2]),
              color="dimgray",
              lty="dashed",
              lwd=1)
# 모든 관측값이 초평면에 의해 완벽히 분류되었음 
# 그러나 마진의 폭이 굉장히 작아짐
iris.svm2.pred <- predict(iris.svm2,         
                         newdata=iris.sub) 
head(iris.svm2.pred)                   
table(iris.sub$Species, iris.svm2.pred, 
      dnn=c("Actual", "Predicted"))  
mean(iris.sub$Species == iris.svm2.pred)
# 오분류된거 하나 없지  
# 정확도가 1
# 마진의 폭이 너무 작아서, 일반화 어려움. 
# 새로운 데이터 넣었을 때 오분류 가능성 높아짐


#### 예제 2 ####
# 결혼생활 동안 외도 여부 예측해보자 

install.packages("AER")
library(AER)
data("Affairs")
str(Affairs) # 결혼생활 데이터
             # $affairs 외도 횟수 -> 결과변수니까 이진범주형으로 바꿔줘야 함
aff <- Affairs
aff$affairs <- factor(ifelse(aff$affairs > 0, 1, 0),
                      levels=c(0,1),
                      labels=c("No", "Yes"))
?ifelse

str(aff)
table(aff$affairs)
prop.table(table(aff$affairs))

# 훈련데이터/테스트데이터 나누기
set.seed(123)
?sample
train <- sample(nrow(aff), 0.7*nrow(aff))
aff.train <- aff[train, ]
aff.test <- aff[-train, ]

table(aff.train$affairs)
table(aff.test$affairs)

# svm분석 시행
library(e1071)
set.seed(123)
aff.svm <- svm(affairs ~ ., # 결과변수 ~ 예측변수
               data = aff.train)
summary(aff.svm)



# 예측하기
aff.svm.pred <- predict(aff.svm, 
                        newdata=aff.test)
head(aff.svm.pred)
table(aff.test$affairs, aff.svm.pred,
      dnn=c("Actual", "Predicted"))
mean(aff.test$affairs == aff.svm.pred)



# 각 범주별 예측확률을 계산하기
set.seed(123)
aff.svm2 <- svm(affairs ~ ., 
               data = aff.train,
               probability=T)
aff.svm2.pred <- predict(aff.svm2,
                         newdata = aff.test,
                         probability = T)
head(aff.svm2.pred)
str(aff.svm2.pred)
attr(aff.svm2.pred, "probabilities")[1:6, ]


# 성능개선을 위한 튜닝하기
# RBF커널함수(디폴트)를 이용한 튜닝
set.seed(123)
aff.svm.tuned <- tune.svm(affairs ~ .,
                          data=aff.train,
                          gamma=10^(-3:3), # 데이터를 분할하는 초평면의 형태를 결정
                                           # 감마인수 값이 크면 더 많은 서포트벡터, 좀더 복잡한 분류 경계 생성
                                           # 훈련데이터 오분류 작아지지만 일반화 힘들어져
                                           # 0보다 크게 설정해야 함
                          cost=2^(-5:5))
# 감마와 코스트는 둘다 너무 커지면 과적합 문제 발생하기 때문에 적절한 값 찾아야 함
# tune.svm() 감마와 코스트를 변화시켜가면서 최적의 값을 찾아가는 함수
# 77개의 모델 중 가장 작은 오차를 보이는 모델을 찾아냄
summary(aff.svm.tuned)
# best parameters: 최적의 감마와 코스트
aff.svm.tuned$best.model$gamma
aff.svm.tuned$best.model$cost

set.seed(123)
aff.svm <- svm(affairs ~ .,
               data=aff.train,
               gamma=0.001,
               cost=0.03125)
aff.svm.pred <- predict(aff.svm, 
                        aff.test)
table(aff.test$affairs, aff.svm.pred,
      dnn=c("Actual", "Predicted"))
mean(aff.test$affairs == aff.svm.pred)
# 개선된 성능


#### 다중분류 ####
# e1071패키지는 1:1 방식을 이용
set.seed(123)
train <- sample(nrow(iris), 0.7*nrow(iris))
iris.train <- iris[train, ]
iris.test <- iris[-train, ]

set.seed(123)
iris.svm <- svm(Species ~ .,
                data=iris.train)
summary(iris.svm) # 45개의 서포트벡터

library(ggplot2)
iris.mds <- data.frame(cmdscale(dist(iris.train[,-5])))
ggplot(iris.mds, aes(x=X1, y=X2)) +
  geom_point(aes(color=iris.train[,5],
                 shape=iris.train[,5], size=2)) +
  geom_point(data=iris.mds[iris.svm$index,],
             color="dimgray", shape=21,
             stroke=1.0, size=5) +
  labs(color="Species", shape="Species", x="Dimension 1",
       y="Dimension 2",
       title="SVM Classification from Iris Dataset") +
  theme(plot.title=element_text(face="bold"))
  
iris.svm.pred <- predict(iris.svm, iris.test)
table(na.omit(iris.test)$Species, 
      iris.svm.pred,
      dnn=c("Actual", "Predicted"))
mean(na.omit(iris.test)$Species == iris.svm.pred)
