#### k평균 군집분석 ####

# 00. 데이터 전처리 ####
# 데이터 살펴보기
str(state.x77)
head(state.x77)

# 표준화
state.scaled <- scale(state.x77)


# 01. 추출할 군집 개수 결정 ####
# 추출할 군집의 개수를 설정해야 하지만 몇개의 군집인지 사전에 모른다
# 군집의 개수를 달리하면서 k평균 군집분석을 반복하여 그 중 가장 의미있는 군집분할을 찾아야 함
# 또는 함수 이용

install.packages("NbClust")
library(NbClust) # 최적의 군집개수를 알려주는 다양한 지표 제공

set.seed(123) # 처음 중심점을 임의로 결정하기 때문에
nc <- NbClust(state.scaled, # 군집대상의 데이터셋
              distance = "euclidean", # 거리 측정 방법
              method="kmeans",        # 군집 방법
              min.nc=2, max.nc=15)    # 군집의 최소, 최대 개수
nc

nc$Best.nc # 각 지표가 추천하는 최적의 군집 개수가 행렬형식으로 저장

table(nc$Best.nc[1, ]) # 2개 또는 3개 군집개수가 가장 많은 지지


# 02. 군집 생성 ####
set.seed(123)
clustering.km <- kmeans(state.scaled,
                        centers = 3,  # 분할군집개수
                        nstart = 25)  # 지정된 횟수만큼 군집분석 실행해서 최적의 결과 도출. 보다 안정적
clustering.km$cluster # 각 케이스별 소속 군집
clustering.km$centers # 최종 군집 중심점
clustering.km$size    # 각 군집의 크기
# 표준화 값으로 계산되어 있음



# 03. 해석 및 시각화 ####
# 원래대로 보고싶으면
aggregate(state.x77,
          by=list(cluster=clustering.km$cluster), # 각 케이스별 소속 군집
          mean)

library(cluster)          
clusplot(x=state.x77, # 데이터프레임 or 행렬형식(거리행렬)
         clus=clustering.km$cluster, # 각 케이스가 속한 군집을 나타내는 벡터
         color=T,
         shade=T,
         labels=2,
         lines=0,
         main="Cluster Plot")
# 주성분분석이나 다차원척도법을 이용해서 변수들을 2차원으로 축소한 후
# 2차원 평면에 각 케이스를 나타내고, 군집은 타원으로 표현


# 04. 타당성 검토 ####
# install.packages("factoextra")
library(factoextra)

get_clust_tendency(nut, 4) # 4는 k-1
res$hopkins_stat 