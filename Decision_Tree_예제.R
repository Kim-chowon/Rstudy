#### y변수가 범주형인 경우 : 분류나무 ####
#### 분류나무 만들기 ####
library(rpart)
library(rpart.plot)
library(tidyverse)
head(iris)

?rpart.control
my.control <- rpart.control(xval=10, cp=0, minsplit=2)
# xval=10 과적합을 방지하기 위한 교차검정 k의 수
# cp=0 (기본세팅)
# minsplit=5 분할하기 위한 최소 기준 관측치(부모노드)

?rpart
tree.model <- rpart(Species~., 
                    method="class", 
                    control=my.control, 
                    data=iris)
tree.model
# y ~ . : 모든 변수를 x변수로
# 범주형이기 때문에 분류나무 할거다. = "class"

rpart.plot(tree.model)


##### 가지치기 ####
printcp(tree.model)
# cp : complexity parameter 복잡할수록 일반화 어렵
# error : 훈련데이터 에러
# xerror : 테스트데이터 에러 -> 얘가 높아지기 전에 잘라줘야 함
# CP가 0.02일 때 잘라줘야 함.
# 최적 cp는 0.02

pruned.model <- prune.rpart(tree.model, cp=0.01)
pruned.model %>% rpart.plot
# 더 간명한 모델.
# 과적합 문제 방지하고 일반화가능성 높임



#### 예측하기  ####
testdata <- data.frame(Petal.Width=c(0.2, 2),
                       Petal.Length=c(1.4, 2.7),
                       Sepal.Width=c(3,4),
                       Sepal.Length=c(5,6))
predict(pruned.model, newdata=testdata, type="class")



#### Random Forest ####
library(mlbench)
data(BreastCancer)
str(BreastCancer)
# $2~10 예측변수
# $11 class 결과변수

# 전처리 ####
bc <- BreastCancer[-1]
bc <- cbind(lapply(bc[-10], function(x) as.numeric(as.character(x))), bc[10])
bc
# id사라지고 모두 숫자로

set.seed(567)
train <- sample(nrow(bc), 0.7*nrow(bc))
bc.train <- bc[train,]
bc.test <- bc[-train,]
sum(is.na(bc) == 1)

# install.packages("randomForest")
library(randomForest)
set.seed(123)
bc.forest <- randomForest(Class ~.,
                          data=bc.train,
                          na.action=na.roughfix,
                          importance=T)
# Class ~., 결과변수 ~ 예측변수
# data=bc.train, 
# na.action=na.roughfix, # 결측값 처리방법: 수치형변수면 중위수, 명목변수는 최빈값
# importance=T 예측변수의 중요도 평가
bc.forest
# Number of trees: 500
# No. of variables tried at each split: 3  - 노드분할을 위해 선택된 세개의 예측변수 
bc.forest.pred <- predict(bc.forest,
                          newdata=bc.test,
                          type="prob")
head(bc.forest.pred)

bc.forest.pred <- predict(bc.forest,
                          newdata=bc.test,
                          type="response")


table(bc.forest.pred$Class, bc.forest.pred)
