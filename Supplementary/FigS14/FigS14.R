library(dplyr)
library(agricolae)
df = read.csv(file = 'FigS14.csv',header = TRUE,sep='\t')
standard = df %>% filter(Condition == 'Standard')
Fe = df %>% filter(Condition == 'Fe')
#FigS14A
kru_standard_Greenness = kruskal(standard$Greenness, standard$Genotype, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_standard_Greenness
#FigS14B
kru_Fe_Greenness = kruskal(Fe$Greenness, Fe$Genotype, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_Fe_Greenness
#FigS14C
kru_standard_Area = kruskal(standard$Area..cm2., standard$Genotype, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_standard_Area
#FigS14D
kru_Fe_Area = kruskal(Fe$Area..cm2., Fe$Genotype, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_Fe_Area

