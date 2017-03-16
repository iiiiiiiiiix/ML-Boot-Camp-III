library(dplyr)
library(psych)

rm(list=ls())

setwd("C:/Users/admin/Dropbox/docs/Data/ml-boot-camp/files")
x <- read.csv("x_test.csv", sep = ";")

setwd("C:/Users/admin/Downloads")
y <- read.csv("xgb1.csv", header = F)

xy <- cbind(x,y)
rm(x,y)

xy <- select(xy, 12, 13)
res <- xy

eps = 1e-15
for ( i in 1:nrow(xy) ) {
  if ( xy[i,1] == 14 ) {
    res[i,2] = 1-eps
  }
}

res <- select(res,2)

write.table(res, file="C:/Users/admin/Downloads/xgb1_1.csv", sep =",",
            quote = F, eol="\n\n", row.names = F, col.names = F )


#немного поработаем с фичами перед тем, как строить вторую модель
temp_X <- read.csv("temp_X.csv", sep = ",", header = T)

newX <- select(temp_X, -67)

cor_list <- correlations(newX)
which( colnames(newX)=="new40")
which( colnames(newX)=="new21")
which( colnames(newX)=="new27")
X1 <- select(newX, -52, -33, -39)

# сплит обратно на x_tran, x_test
X <- X1[1:25289,]
test <- X1[25290:nrow(X1),]

write.table(X, file="C:/Users/admin/Downloads/new_train.csv", sep =",",
            quote = F, eol="\n\n", row.names = F, col.names = T )
write.table(test, file="C:/Users/admin/Downloads/new_test.csv", sep =",",
            quote = F, eol="\n\n", row.names = F, col.names = T )