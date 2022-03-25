library(dplyr)
library(agricolae)
df = read.csv(file = 'FigS25.csv',header = TRUE,sep='\t')
df$X4stats = paste(df$Sample,df$Condition,sep='_')
kru = kruskal(df$Ratio_N, df$X4stats, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru
test=lm(Ratio_N ~ CNV + IRT1 + Condition, df)
summary(test)
