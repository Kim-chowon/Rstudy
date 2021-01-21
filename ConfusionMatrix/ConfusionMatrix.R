#### 성능평가 ####

# 유방암 양성/악성을 판단하는 예측모델을 평가해보자

# 유방암 예측모델 만들기
library(mlbench)
data("BreastCancer")
str(BreastCancer)

# 1. 전처리
# id변수 제거
bc <- BreastCancer[-1]

# class(목표변수) 빼고 예측변수(팩터)를 모두 숫자로 바꿔
bc <- cbind(lapply(bc[-10], 
                   function(x) as.numeric(as.character(x))), 
            bc[10])


bc

# 2. 훈련데이터와 테스트데이터 만들기
set.seed(123)
train <- sample(nrow(bc), 0.7*nrow(bc))
bc.train <- bc[train,]
bc.test <- bc[-train,]
table(bc.train$Class)
table(bc.test$Class)

# 3. 예측모델 만들기 (의사결정나무 C5.0알고리즘) : 엔트로피, 정보이득 이용
install.packages("C50")
library(C50)
library(rpart.plot)
library(rattle)
library(FSelector)

# 예측모델 만들기
bc.c50 <- C5.0(Class ~ ., 
               data=bc.train)
tree <- rpart(Class~., data=bc.train,
              control=rpart.control(minsplit=2))
fancyRpartPlot(tree, palettes = c("RdPu"))

# 예측하기
bc.c50.pred <- predict(bc.c50,
                       bc.test,
                       type="class")


# 혼동행렬 만들기
bc.c50.cmatrix <- table(bc.test$Class,
                        bc.c50.pred,
                        dnn=c("Actual", "Predicted"))
bc.c50.cmatrix
# 오분류 케이스 13개

## 좀 더 다양한 정보를 가진 혼동행렬
# install.packages("gmodels")
library(gmodels)
CrossTable(bc.test$Class,
           bc.c50.pred,
           prop.chisq = F,
           dnn=c("Actual", "Predicted")) -> bc.c50.CT

# 예측정확도 지표
mean(bc.test$Class == bc.c50.pred)
sum(diag(bc.c50.cmatrix)/sum(bc.c50.cmatrix))
# 똑같아요

# 성능평가 지표 한번에 보기
library(caret)
confusionMatrix(bc.c50.pred, bc.test$Class,
                positive="malignant")
# Accuracy
# Sensitivity
# Specificity
# PPV
# NPV 

# 민감도와 특이도
sensitivity(bc.c50.pred,
            bc.test$Class,
            positive = "malignant")
specificity(bc.c50.pred,
            bc.test$Class,
            negative = "benign") 

# 의사결정나무의 ROC곡선 그리기
bc.c50 <- C5.0(Class ~ ., 
               data=bc.train)

bc.c50.pred <- predict(bc.c50,
                       bc.test,
                       type="prob") # 임계치=예측확률이니까, 확률을 봐야한다
head(bc.c50.pred)

# install.packages("Epi")
library(Epi)
ROC(test=bc.c50.pred[,2],  # positive 예측확률
    stat=bc.test$Class,    # 실제 범주
    MI=F,
    main="ROC Curve (Epi package)")
?ROC
# 민감도와 특이도의 합이 최대가 되는 최적의 기준값을 표시
# 그 때의 민감도와 특이도, PPV, NPV값도 출력

# Sens: 0.967
# Spec: 0.94



