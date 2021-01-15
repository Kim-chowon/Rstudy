#### 연속형 변수: 유클리드 거리 ####

install.packages("flexclust")
library(flexclust)

data("nutrient")
str(nutrient)
head(nutrient)

d <- dist(nutrient,           # 거리를 계산할 데이터셋(행렬 또는 데이터프레임 형식)
          method="euclidean") # 기본값 유클리드
d
class(d) # 거리행렬
head(d)

d.Head <- as.matrix(d)[1:5, 1:5]
d.Head
# d.Head[!lower.tri(d.Head)]
# 거리행렬에서 셀값이 작으면 = 케이스간 거리가 작다 = 유사도가 크다

# 변수들이 갖는 값의 범위가 현저히 다르면 왜곡된 결과를 가져올 수 있음 
# 표준화 -> 유클리드 거리 계산
nutrient
nut <- nutrient[1:5, 1:2]
nut
# 5개 케이스의 에너지와 단백질의 표준화 거리를 구해보겠습니다.
# 각 케이스 변수값에서 평균을 빼고 표준편차로 나눠야 합니다.
# 그렇게 표준화된 값으로 행렬을 만든 후 유클리드거리를 구합니다.

z_energy <- (nut[,1] - mean(nut[,1]))/sd(nut[,1])
z_protein <- (nut[,2] - mean(nut[,2]))/sd(nut[,2])

z_nut <- cbind(z_energy, z_protein)
z_nut

row.names(z_nut) <- c("BEEF BRAISED", "HAMBURGER", "BEEF ROAST", "BEEF STEAK", "BEEF CANNED")
z_nut

z_nut_d <- dist(z_nut, "euclidean")
z_nut_d

# 비교
dist(nut)
nut




#### 범주형 변수 : 재카드 거리 ####
install.packages("proxy")
library(proxy)

pr_DB$get_entry("Jaccard") # 설명보기
# binary형태의 데이터에 대한 비유사성 척도
# (FALSE, FALSE) pairs 에 대해서는 고려하지 않고 무시하며, 비교 대상의 두 객체 집합의 합집합과 교집합을 비교한다

# 예제1 : 합집합, 교집합 이용 ####
# $1=빨강, $2=노랑, $3=파랑 (binary 형태의 데이터셋)
x <- matrix(c(0,1,0,0,1,0,1,1,1,1,1,0,0,0,1),
            byrow=T,
            ncol=3)
x
dist(x, method="Jaccard")

library(tidyverse)
stats::dist(x, method="binary") %>% as.matrix


# 예제2 : 더미변수 이용 ####
library(MASS)
str(survey)

# sex와 smoke변수 간 거리 계산
survey.SS <- survey[c("Sex", "Smoke")]
head(survey.SS)

# 1) 더미변수로 변환
install.packages("fastDummies")
library(fastDummies)
survey.dummy <- dummy_cols(survey.SS, # 범주형변수가 포함된 데이터셋
                           remove_selected_columns = T, # 원래 범주형 변수를 지울테냐
                           remove_first_dummy = T,      # 첫번째 변수를 기준변수로 사용할테냐
                           ignore_na = T)
head(survey.dummy)
survey.dummy.d <- dist(survey.dummy, "Jaccard") # 인덱싱 안됨

survey.dummy.d 
as.matrix(survey.dummy.d)                       # 시각화? 필요한가?

d <- stats::dist(survey.dummy, method="binary")
as.matrix(d)[1:5, 1:5]



# 데이터셋에 연속형, 범주형 변수 모두 포함되어 있을 때
# daisy()를 이용한다
library(cluster)
d <- daisy(survey, metric="gower") # 연속형 변수일 경우 변수 표준화 후 맨하탄거리로 측정
                                   # 연속형 변수가 아닐 경우 더미변수로 변환 후 다이스거리로 측정
as.matrix(d)[1:5, 1:5]
 
