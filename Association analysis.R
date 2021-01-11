# 연관성 분석   
# 대량의 데이터에 숨겨진 항목 간의 연관규칙을 찾아내는 기법
# 텍스트마이닝에서 연관 키워드 또는 유사 문서의 추출

# 연관성 분석 시 항목이 많아질수록 조합할 수 있는 연관성 규칙은 기하급수적으로 늘어남
# Apriori 알고리즘
# 기본 규칙: 한 항목이 자주 발생하지 않는다면 이 항목을 포함하는 집합들도 자주 발생하지 않는다
# 삼겹살에 대한 지지도가 0.4라면 {삼겹살,생수}, {삼겹살,사과}에 대한 지지도는 아무리 높아도 0.4를 넘지 못할 것이다 
rm(list=ls())

install.packages("arules")
library(arules)
basket <- readLines("basket.csv") # 라인단위로 읽어오기
basket
# 장바구니 하나를 Transaction이라고 한다 -> 문자열로 이루어져 있어야 함 
# Transaction으로 변환하기 위해 ',' 기준으로 하나씩 잘라주기
basket.trans <- strsplit(basket, ",")
basket.trans <- as(basket.trans, "transactions")
basket.trans

inspect(basket.trans)

# 연관성 규칙 도출(지지도0.1 이상, 신뢰도 0.8 이상인 연관성 규칙만 도출)
basket.apriori <- apriori(basket.trans, parameter= list(support=0.1,
                                      confidence=0.8))
inspect(basket.apriori)
?apriori
# lhs = 조건
# rhs = 결과
# count = 연관성 규칙이 발생한 건수

# 향상도가 1.2 이상이 데이터 확인
subset(basket.apriori, subset = lift > 1.2) %>% inspect # 행의조건

# 조건에 삼겹살이 포함된 연관성 규칙
subset(basket.apriori, subset = lhs %in% c("삼겹살")) %>% inspect
# %in% 교집합 연산

