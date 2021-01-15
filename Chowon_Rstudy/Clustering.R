# 데이터 살펴보기

str(state.x77)
head(state.x77)

# 표준화
state.scaled <- scale(state.x77)

# 추출할 군집의 개수를 설정해야 하지만 몇개의 군집인지 사전에 모른다
# 군집의 개수를 달리하면서 k평균 군집분석을 반복하면서 그 중 가장 의미있는 군집분할을 찾아야 함
# 또는 함수 이용

install.packages("NbClust")
library(NbClust)
# 최적의 군집개수를 알려주는 다양한 지표 제공
set.seed(123)
nc <- NbClust(state.scaled,
              distance = "euclidean",
              method="kmeans",
              min.nc=2, max.nc=15)
# min.nc=2, max.nc=15 군집의 최소개수, 최대개수
nc
nc$Best.nc # 각 지표가 추천하는 최적의 군집 개수가 행렬형식으로 저장
table(nc$Best.nc[1, ]) # 2개 또는 3개 군집개수가 가장 많은 지지

set.seed(123)
clustering.km <- kmeans(state.scaled,
                        centers = 3,  # 분할군집개수
                        nstart = 25)  # 지정된 횟수만큼 군집분석 실행해서 최적의 결과 도출. 보다 안정적
clustering.km$cluster # 각 케이스별 소속 군집
clustering.km$centers # 최종 군집 중심점
clustering.km$size    # 각 군집의 크기

aggregate(state.x77,
          by=list(cluster=clustering.km$cluster),
          mean)

library(cluster)          
clusplot(x=state.x77,
         clus=clustering.km$cluster,
         color=T,
         shade=T,
         labels=2,
         lines=0,
         main="Cluster Plot")
