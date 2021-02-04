library(tidyverse)
#### 다차원 척도법 ####

# 계량적 MDS ####
str(eurodist)
# 유럽 도시 간의 거리를 측정한 데이터셋
# 유럽 도시 간 거리를 나타내는 'dist' 거리행렬

labels(eurodist)

# 처음 다섯개 도시 간 거리행렬 출력
as.matrix(eurodist)[1:5, 1:5]
# 셀값은 거리를 나타낸다
# 거리가 작을수록 케이스간 유사도가 크다는 걸 의미


# 거리를 간격척도나 비율척도로 측정한 계량데이터로부터 생산된 거리행렬에 대한 다차원 척도법 분석은
# cmdscale()함수를 이용해서 수행
eurocity.mds <- cmdscale(d=eurodist, # 거리행렬 또는 셀값이 거리를 나타내는 행렬
                         k=2)        # 데이터가 표현될 공간의 차원. 일반적으로 2차원이 편하다
eurocity.mds         
# 각 케이스에 대한 (x,y)좌표를 행렬로 리턴

eurocity.mds %>% 
plot(type="n",
     main="Multidimensional Scaling Plot")

eurocity.mds %>% 
text(rownames(eurocity.mds),
     col="maroon",
     cex=0.7)

# 차원1=x축은 서-동을 나타냄
# 차원2=y축은 북-남을 나타냄
# y축 뒤집을 수 없을까?
eurocity.mds[,2] <- -eurocity.mds[,2]


eurocity.mds %>% 
  plot(type="n",
       main="Multidimensional Scaling Plot")

eurocity.mds %>% 
  text(rownames(eurocity.mds),
       col="maroon",
       cex=0.7)
# 케이스 간 거리만을 이용 -> 상대적 위치에 따라 배치됨
# 축, 그래프의 방향은 그 자체로는 의미가 없다.



#### 거리행렬부터 해보기 #### 
# 판사의 평가점수를 기록한 데이터
str(USJudgeRatings)

# 우선 거리를 먼저 측정해야 한다.
# 간격척도나 비율척도로 측정된 계량데이터의 경우에는 dist()를 이용해서 유클리드 거리를 계산할 수 있따
USJudgeRatings.dis <- USJudgeRatings %>% 
  dist %>% 
  cmdscale

USJudgeRatings.dis %>% 
  plot(type="n",
       main="Multidimensional Scaling Plot") 
  
USJudgeRatings.dis %>% 
  text(rownames(USJudgeRatings.dis),
       col="blue",
       cex=0.6)


# 비계량적 MDS ####
# 명목척도나 서열척도로 측정된 비계량데이터가 포함되었을 경우 
# 유클리드 거리는 적합하지 않음
# cluster::daisy() 거리계산할때
# MASS::isoMDS() 다차원척도법 분석할때
library(cluster)
str(mtcars)

mtcars.dis <- mtcars %>% 
  daisy(metric="gower") 


library(MASS)
mtcars.mds <- mtcars.dis %>% 
  isoMDS
mtcars.mds
# isoMDS()는 (x,y)좌표를 리스트 객체 내의 point 행렬로 반환한다
# 따라서 이 반환된 객체 내의 포인트 행렬을 좌표로 지정

mtcars.mds$points %>% 
  plot(type="n",
       main="Multidimensional Scaling Plot")

mtcars.mds$points %>% 
  text(rownames(mtcars),
       col="purple",
       cex=0.7)

