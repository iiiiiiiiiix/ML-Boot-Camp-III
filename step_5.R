library(dplyr)
library(psych)

rm(list=ls())

setwd("C:/Users/admin/Downloads")

x <- read.csv("xgb1_1.csv", header = F)
y <- read.csv("xgb2.csv", header = F)

xy <- cbind(x,y)
rm(x,y)

y <- as.data.frame(rowMeans(xy))


write.table(y, file="C:/Users/admin/Downloads/final.csv", sep =",",
            quote = F, eol="\n\n", row.names = F, col.names = F )

# setwd("C:/Users/admin/Dropbox/docs/Data/ml-boot-camp/files")
# x <- read.csv("x_test.csv", sep = ";")
# 
# xy <- cbind(x,y)
# rm(x,y)
# 
# xy <- select(xy, 12, 13)
# res <- xy
# 
# eps = 1e-15
# for ( i in 1:nrow(xy) ) {
#   if ( xy[i,1] == 14 ) {
#     res[i,2] = 1-eps
#   }
# }
# 
# res <- select(res,2)
# 
# write.table(res, file="C:/Users/admin/Downloads/test.csv", sep =",",
#             quote = F, eol="\n\n", row.names = F, col.names = F )
