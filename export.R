#### 출력 ####

con <- file("r.txt", open = "w") #open인수에 w는 쓰기 r은 읽기
cat("Hi", file=con)
close(con)

list.files()
file.create("temp.txt")
file.exists("temp.txt")
file.remove("temp.txt")
