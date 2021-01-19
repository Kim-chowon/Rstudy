#### 계층적 군집분석 ####
library(flexclust)
data("nutrient")
str(nutrient)
head(nutrient)

# 00. 데이터 전처리 ####
# 행이름 소문자로 바꾸기
nutrition <- nutrient
row.names(nutrition) <- toupper(row.names(nutrition))
head(nutrition)


# 변수마다 측정단위, 범위가 다르다. -> 표준화하자
nutrition.scaled <- scale(nutrition)



# 01. 거리계산과 알고리즘 선택 ####
# hclust() : 계층적 군집분석 수행 함수
# dist()로 생성한 거리행렬을 바탕으로 군집화 작업 수행
# 우선 식품 간 거리를 계산
d <- dist(nutrition.scaled)
?dist
d

?hclust # method
clustering.average <- hclust(d, method="average")
clustering.average 

# 덴드로그램 형성
plot(clustering.average, hang=-1,
     col="darkgreen", xlab="Food",
     main="Hierarchical Clustering with Average Link")
# 덴드로그램은 개별 케이스의 군집 형성 과정을 보여준다
# x축은 개별 케이스, y축은 군집결합의 기준이 되는 값을 나타냄
# 평균연결법을 사용했으므로 y축은 케이스 간 평균 거리를 나타냄
# 덴드로그램만으로는 몇 개의 군집으로 나눌지 알 수 없다.
# 바람직한 군집의 개수를 결정해야 한다.



# 03. 군집 수 결정 ####
# 최적의 군집개수 계산
library(NbClust)
nc <- NbClust(nutrition.scaled,       # 군집분할대상 데이터
              distance = "euclidean", # 유클리드 거리
              method = "average",     # 평균연결법
              min.n = 3, max.nc = 15) # 최소, 최대 군집개수
nc$Best.nc
# 각 지표가 추천하는 최적의 군집 개수가 제시
# 열은 지표, 첫째 행은 군집 개수, 둘째 행은 지표값
# 지표마다 지지하는 군집 개수가 다르다. 
# 일반적으로 가장 많은 지표로부터 지지를 받는 군집 개수를 선택
# 각 군집개수별로 지지받은 개수를 구하려면? 
table(nc$Best.nc[1,])
# 군집개수 5개가 7번 지지 받았다
# 군집개수 3개, 5개, 15개 중 선택할 수 있다.



# 04. 군집 생성 ####
# 군집개수를 결정했으면 군집을 생성해야지
clusters <- cutree(clustering.average, # 계층적군집분석 결과로부터 생성된 객체
            k=5)                       # 군집의 개수
clusters
# 각 케이스 별 몇번 군집으로 할당되었는지 알 수 있음


# 각 군집에 할당된 케이스 개수 확인하기
table(clusters)



# 05. 시각화 및 해석 ####
# 덴드로그램으로 나타내기
plot(clustering.average, hang=-1,
     col="darkgreen", xlab="Food",
     main="Hierarchical Clustering with Average Link") # 위에 거랑 같은거
rect.hclust(clustering.average, # 계층적군집분석 결과로부터 생성된 객체
            k=5)                # 군집의 개수


# 군집은 케이스간 유사도를 바탕으로 도출되기 때문에 군집의 속성을 비교할 수 있다
# 각 군집에 속한 케이스의 변수값 평균, 중위수 계산
aggregate(nutrition, 
          by=list(clusters), # 집단변수에 군집을 지정
          mean)

# 비교를 위해 표준화
a <- aggregate(nutrition %>% scale, by=list(clusters), mean)
n <- as.vector(table(clusters)) # 각 군집에 할당된 케이스 개수
nut <- cbind(a,n)
str(nut)

# 06.타당성 검토 ####
install.packages("factoextra")
library(factoextra)

get_clust_tendency(nut, 4) # 4는 k-1
res$hopkins_stat           # 홉킨스 통계량이 기준값(0.5)보다 작다고 하더라도, 필요에 따라 군집을 만들어 내는 데 이용할 수 있다.