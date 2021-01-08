?fread
# read.csv보다 훨씬 빠른 읽어오기 함수
# 데이터테이블이 데이터프레임 보다 빠르고 편하다
library(data.table)
getwd()
sc <- read.csv('results.csv')
sc
sc.dt <- fread('results.csv')
sc.dt
str(sc.dt)
sc.df <- as.data.frame(sc_dt)
str(sc.df)

system.time(sc <- read.csv('results.csv'))
system.time(sc.dt <- fread('results.csv'))

