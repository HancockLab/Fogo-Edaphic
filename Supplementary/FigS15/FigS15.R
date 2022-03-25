library(dplyr)
library(agricolae)
df = read.csv(file = 'FigS15.csv',header = TRUE,sep='\t')
kru_FeShoot = kruskal(df$Fe.Leaf, df$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_FeShoot
kru_FeRoot = kruskal(df$Fe.Root, df$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_FeRoot
kru_MnShoot = kruskal(df$Mn.Leaf, df$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_MnShoot
kru_MnShoot = kruskal(df$Mn.Root, df$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_MnShoot

