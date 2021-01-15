#### 분류분석 ####
# 데이터만 가지고 컴퓨터가 자동으로 분류 -> 머신러닝의 원리   

# 사과품종을 예측하는 분류분석 모델 만들기
apple <- read.csv("apple.csv")
apple

str(apple)

boxplot(weight ~ model, data = apple)
  # 품종별 무게분포를 살펴본 결과, 로얄후지와 미시마는 다른 것들과 차이를 보인다
# 무게로는 로얄후지와 미시마의 차이가 불분명하다
boxplot(sugar ~ model, data = apple)
# 품종별 당도분포를 살펴본 결과, 무게분포보다 품종별 차이가 뚜렷하지 않으나,
# 로얄후지와 미시마의 차이가 더욱 분명하다

# 이 사과는 어떤 사과인지 예측하려면
# 1. 무게를 따져본다 -> 무거우면 로얄후지 아니면 미시마
# 2. 당도를 본다 -> 좀 더 달면 미시마

# 분류기준에 따라 데이터를 분류
# 의사결정 트리!

# 1. Train/Test 나누기 ####
# 훈련데이터(train data): 모델 구축 시 활용할 데이터
# 테스트데이터(Test data): 모델의 정확도를 확인할 데이터

install.packages("caret")
library(caret)

?createDataPartition

set.seed(1)

apple.index <- createDataPartition(apple$model, p=0.8, list=F) 
# 컴퓨터가 랜덤으로(실행마다 다르게 나올 수 있음)
# Y: 예측해야 하는 것 (사과 품종)
# p: 훈련데이터 비율
# list로 결과 볼거냐?
apple.index
# 훈련데이터로 지정할 데이터의 인덱스들

apple.train <- apple[apple.index, ]
apple.test <- apple[-apple.index, ] # 사과 인덱스에 빠진 것. 

nrow(apple.train) # 학습
nrow(apple.test)  # 평가

# 2. 분류분석 실행하기 ####
install.packages("rpart")
library(rpart)

apple.model <- rpart(model ~ .,
                     data=apple.train,
                     control=rpart.control(minsplit=2))
# 분류할 데이터 ~ 모델에 영향을 미치는 요인(분류 기준)
# 모든 요인을 다 쓸거야 = .
# minsplit 노드에 포함되는 최소 데이터 개수
apple.model

# 3. 모델 시각화 ####
install.packages("rpart.plot")
library(rpart.plot)
rpart.plot(apple.model)

# 4. 해석 #### 
# 1)
# 네모 박스 하나가 노드
# 각 노드는 성질를 가지고 있음. 이 경우에는 품종=성질
# 두번째 숫자들은 신뢰도(각 사과 당 20%의 확률로 로얄후지라고 생각하고 있음. 아직 첫번째니까)
# 마지막 100%는 이 노드까지 온 사과의 비율(20개의 사과가 모두 이 노드까지는 접근했다)
# -> 20개의 사과를 가지고 로얄후지인지 판별하는 노드 
#  
# 2) 
# acid < 0.53 인지 물어봄
# no라고 대답한건 홍옥 뿐(20% 도달)
# yes라고 대답한 사과는 25%의 확률로 로얄후지
# 
# 3)
# weight >= 366 인지 물어봄
# yes라고 대답하면 50%의 확률로 로얄후지
# no라고 대답하면 50%확률로 아오리
# 
# 4) 
# color = 적색 인지 물어봄
# yes라고 대답하면 로얄후지로 판명.

# 5. 예측하기 ####
apple.predict <- predict(apple.model, apple.test, type="class") 
apple.predict
# 모델에 테스트데이터를 적용한 결과

# 6. 모델 평가하기 (Kappa지수) ####
# 보통 0.4~0.6 적당
actual <- apple.test$model

# 혼동행렬을 만들어서 실제test데이터의 품종과 predict데이터의 품종이 얼마나 일치하는지 확인

confusionMatrix(actual, apple.predict, mode = "everything")
actual <- as.factor(actual) 
