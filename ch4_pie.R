#원그래프 작성
rm(list=ls())
par(mfrow=c(1,1))

MPA <- c(rep("HUFS",3), rep("KU",6), rep("KHU",2))
MA <-  c("HUFS","HUFS","HUFS","HUFS","HUFS","HUFS",
         "KU","KU",
         "KHU")
sample.data2 <- c(MPA, MA)
sample.data2
pie.table <- table(sample.data2)
pie(pie.table, main="Master Degree Univ.")

# 원그래프의 여러가지 예
# Simple Pie Chart
slices <- c(10, 12,4, 16, 8)
lbls <- c("US", "UK", "Australia", "Germany", "France")
pie(slices, labels = lbls, main="Pie Chart of Countries")

# Pie Chart with Percentages
slices <- c(10, 12, 4, 16, 8)
lbls <- c("US", "UK", "Australia", "Germany", "France")
pct <- round(slices/sum(slices)*100)
lbls <- paste(lbls, pct) # add percents to labels
lbls <- paste(lbls,"%",sep=" ") # ad % to labels
pie(slices,labels = lbls, col=rainbow(length(lbls)),
    main="Pie Chart of Countries")

# 3D Exploded Pie Chart
install.packages("plotrix")
library(plotrix)
slices <- c(10, 12, 4, 16, 8)
lbls <- c("US", "UK", "Australia", "Germany", "France")
pie3D(slices,labels=lbls,explode=0.1,
      main="Pie Chart of Countries ")

# Pie Chart from data frame with Appended Sample Sizes
mytable <- table(iris$Species)
lbls <- paste(names(mytable), "\n", mytable, sep="")
pie(mytable, labels = lbls,
    main="Pie Chart of Species\n (with sample sizes)")