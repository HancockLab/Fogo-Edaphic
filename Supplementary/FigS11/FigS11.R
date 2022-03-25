library(dplyr)
library(car)
library(lsmeans)
library(Rmisc)
df = read.csv(file = 'FigS11.csv',header = TRUE,sep='\t')
df = mutate(df,Location = factor(Genotype, levels=unique(Genotype)))
#FigS11
model_1 = lm(Greenness ~ Genotype,data=df)
posthoc_1 = lsmeans(model_1,"Genotype",adjust = "tukey")
cld(posthoc_1,alpha   = 0.05,Letters = letters,adjust="tukey")

df2 = subset(df,Genotype!='F13-8' & Genotype!='Col-0')
model_2 = lm(Greenness ~ IRT1 + NRAMP1 + IRT1:NRAMP1, data=df2)
#TableS8
summary(model_2)
#TableS9
anova(model_2)
