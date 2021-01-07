#ggplot 코드없이 사용하기

install.packages("esquisse") # 그래프를 아주 편하게 그릴 수 있는 툴, ggplot2랑 같이 인식하여야 함
library(esquisse) # 활용할 때에는 위의 addins 에서 ggplot2 builder를 활용하면 됨. 
library(ggplot2)

mydata <- iris
head(mydata)
library(ggplot2)


ggplot(data = mydata, aes(x = Sepal.Length,
                          y = Sepal.Width)) +
  geom_point(aes(col = Species))

library(ggplot2)

ggplot(mydata) +
 aes(x = Sepal.Length, y = Sepal.Width, colour = Species) +
 geom_point(size = 2.44) +
 scale_color_hue() +
 labs(title = "Iris") +
 theme_minimal()

             