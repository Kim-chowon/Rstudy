#### 덴드로그램 시각화 이용하기 ####
# 계층적 군집분석에서 이용

# 00. 데이터전처리 
data(USArrests)
head(USArrests)
str(USArrests)
# 표준화
USArrests_scaled <- scale(USArrests)

# 01. 거리 계산 
d <- dist(USArrests_scaled, method="euclidean")
d

# 02. 군집 생성 및 덴드로그램 시각화 
cluster <- hclust(d, method = "ward.D")

plot(cluster)

# 여기서 군집 간 높이의 차이가 큰 군집의 개수를 선택하면 
# 군집 내 응집력은 높고 군집 간 이질성이 큰 적절한 군집을 구할 수 있다.

# 단, 데이터 개수가 많을 경우 군집화 시간이 오래걸리고 시각화가 불가능 할 수 있다
# 주관적이다.




#### 팔꿈치 방법 이용하기 ####
# 비계층적 군집분석에서 이용
# 군집의 수 별 "군집 내 군집과 개체 간 거리 제곱합의 총합"의 그래프가 
# 팔꿈치 모양으로 꺾이는 지점의 k를 선택

tot_withinss <- c() # tot.withinss: Total within-cluster sum of squares)"


for (i in 1:20){
  set.seed(1004) # for reproducibility
  kmeans_cluster <- kmeans(USArrests_scaled, centers = i, iter.max = 1000)
  tot_withinss[i] <- kmeans_cluster$tot.withinss
}

plot(c(1:20), tot_withinss, type="b",
     main="Optimal number of clusters",
     xlab="Number of clusters",
     ylab="Total within-cluster sum of squares")



# 또는 군집의 개수 k별 전체 분산 중 그룹 간 분산의 비율 = 설명된 분산의 비율 (F-test)
# "설명된 분산의 비율"을 계산하여 시각화한 후 
# 팔꿈치 모양으로 꺾이는 지점의 군집의 개수를 선택

r2 <- c()

for (i in 1:20){
  set.seed(1004) # for reproducibility
  kmeans_cluster <- kmeans(USArrests_scaled, centers = i, iter.max = 1000)
  r2[i] <- kmeans_cluster$betweenss / kmeans_cluster$totss
}

plot(c(1:20), r2, type="b",
     main="The Elbow Method - Percentage of Variance Explained",
     xlab="Number of clusters",
     ylab="Percentage of Variance Explained")





#### 실루엣 방법 이용하기 ####
install.packages("factoextra")
library(factoextra)
set.seed(1004)
km.res <- kmeans(USArrests_scaled, centers=4)
km.res

library(cluster)
sil <- silhouette(km.res$cluster, dist(USArrests_scaled))
fviz_silhouette(sil)
