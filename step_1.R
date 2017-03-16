library(dplyr)
library(psych)

rm(list=ls())

setwd("C:/Users/admin/Dropbox/docs/Data/ml-boot-camp/files")

x <- read.csv("x_train.csv", sep = ";", header = T)
y <- read.csv("y_train.csv", sep = ";", header = F)
names(y) <- c("labels")
test <- read.csv("x_test.csv", sep = ";", header = T)


X <- rbind(x,test)

X_num <- select(X, -6)

# добавляю cor_means
correlations <- function(data)
{
  correlation_matrix <- round(cor(data, method = "pearson"), 4)
  diag(correlation_matrix) <- 0
  correlation_matrix[lower.tri(correlation_matrix)] <- 0
  fm <- as.data.frame(as.table(correlation_matrix))
  names(fm) <- c("First.Variable", "Second.Variable","Correlation")
  sorted <- fm[order(abs(fm$Correlation),decreasing=T),]
  n <- ncol(data)
  i <- (n^2 - n)/2 # кол-во эл-тов выше главной диагонали
  return(sorted[1:i,])
}

cor_list <- correlations(X_num)
which( colnames(X)=="totalBonusScore" )
which( colnames(X)=="totalStarsCount" )
which( colnames(X)=="numberOfAttemptedLevels" )
which( colnames(X)=="totalScore" )
X1 <- select(X, 2, 9, 10, 11)
cor_means <- as.data.frame(rowMeans(X1))
names(cor_means) <- "cor_means"
cor_means <- as.data.frame(scale(cor_means))

pc <- prcomp(X_num, center = T, scale. = T)
scores <- as.data.frame(pc$x)
scores <- as.data.frame(scale(scores))


X <- X+1

divide_cols <- function(data, a, b){
  col <- as.data.frame(data[,a]/data[,b])
  i = ncol(data)-11
  names(col) <- paste("new",i, sep = "")
  data <- cbind(data, col)
  return(data)
}
multiply_cols <- function(data, a, b){
  col <- as.data.frame(data[,a]*data[,b])
  i = ncol(data)-11
  names(col) <- paste("new",i, sep = "")
  data <- cbind(data, col)
  return(data)
}

# 42 new features
X <- divide_cols(X,2,12)
X <- divide_cols(X,3,12)
X <- divide_cols(X,4,12)
X <- divide_cols(X,5,12)
X <- divide_cols(X,7,12)
X <- divide_cols(X,9,12)
X <- divide_cols(X,10,12)
X <- divide_cols(X,11,12)
X <- divide_cols(X,4,3)
X <- divide_cols(X,7,8)
X <- divide_cols(X,9,2)
X <- divide_cols(X,9,4)
X <- divide_cols(X,9,5)
X <- divide_cols(X,9,7)
X <- divide_cols(X,9,8)
X <- divide_cols(X,9,10)
X <- divide_cols(X,9,11)
X <- divide_cols(X,10,2)
X <- divide_cols(X,10,4)
X <- divide_cols(X,10,5)
X <- divide_cols(X,10,7)
X <- divide_cols(X,10,8)
X <- divide_cols(X,10,11)
X <- divide_cols(X,11,2)
X <- divide_cols(X,11,4)
X <- divide_cols(X,11,5)
X <- divide_cols(X,11,7)
X <- divide_cols(X,11,8)
X <- divide_cols(X,1,2)
X <- multiply_cols(X,7,8)
X <- divide_cols(X,1,12)
X <- divide_cols(X,1,8)
X <- divide_cols(X,9,1)
X <- divide_cols(X,10,1)
X <- divide_cols(X,11,1)
X <- divide_cols(X,1,7)
X <- multiply_cols(X,1,5)
X <- multiply_cols(X,4,2)
X <- divide_cols(X,15,13)
X <- divide_cols(X,18,17)
X <- divide_cols(X,19,17)
X <- divide_cols(X,20,17)


#на основе 12 фичи добавляю колонку вероятностей 
d <- cbind(x,y)
d <- select(d,12,13)

t <- table(d)
sum <- rowSums(t)

p <- c()
eps <- 1e-15
for(i in 1:nrow(t)){
  p[i] <- t[i,2]/sum[i]-eps
}

X1 <- rbind(x,test)

new1 <- c()
for(i in 1:nrow(X1)){
  new1[i] <- switch(
    X1[i,12],
    p[1],
    p[2],
    p[3],
    p[4],
    p[5],
    p[6],
    p[7],
    p[8],
    p[9],
    p[10],
    p[11],
    p[12],
    p[13],
    p[14]
  )
}

probs_from_12 <- as.data.frame(new1)
names(probs_from_12) <- "probs_from_12"

X <- cbind(X, probs_from_12)

X <- scale(log2(X))

sX <- cbind(X, scores, cor_means)

write.table(sX, file="C:/Users/admin/Downloads/temp_X.csv", sep =",",
            quote = F, eol="\n\n", row.names = F, col.names = T )

cor_list <- correlations(sX)
which( colnames(X)=="new14")
which( colnames(X)=="new21")
which( colnames(X)=="new27")
which( colnames(X)=="new15")
X1 <- select(sX, -26, -33, -39, -27)

# сплит обратно на x_tran, x_test
X <- X1[1:25289,]
test <- X1[25290:nrow(X1),]

write.table(X, file="C:/Users/admin/Downloads/train.csv", sep =",",
            quote = F, eol="\n\n", row.names = F, col.names = T )
write.table(test, file="C:/Users/admin/Downloads/test.csv", sep =",",
            quote = F, eol="\n\n", row.names = F, col.names = T )
