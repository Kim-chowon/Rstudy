library(ggplot2)
data(iris)
scatter <-  ggplot(data=iris, aes(x=Sepal.Length,
                                  y=Sepal.Width)
                   )
scatter + geom_point(aes(color=Species,
                         shape=Species)) +
  xlab("Sepal Length") + ylab("Sepal Width") +
  ggtitle("Sepal Length-Width")