#ggplot 코드없이 사용하기

install.packages("esquisse")
library(esquisse)
library(ggplot2)

mydata <- iris
head(mydata)
library(ggplot2)


ggplot(data = mydata, aes(x = Sepal.Length,
                          y = Sepal.Width)) +
  geom_point(aes(col = Species))

             