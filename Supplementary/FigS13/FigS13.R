library(dplyr)
library(agricolae)
image = read.csv(file = 'FigS13A-B.csv',header = TRUE,sep='\t')
#FigS13A
kru_image_Greenness = kruskal(image$Greenness, image$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_image_Greenness
#FigS13B
kru_image_Area = kruskal(image$Area.cm2., image$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_image_Area

photosynq = read.csv(file = 'FigS13C-D.csv',header = TRUE,sep='\t')
#FigS13C
kru_photosynq_Phi2 = kruskal(photosynq$Phi2, photosynq$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_photosynq_Phi2
#FigS13D
kru_photosynq_RelativeChloro = kruskal(photosynq$RelativeChlorophyll, photosynq$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_photosynq_RelativeChloro

ionome = read.csv(file = 'FigS13E-F.csv',header = TRUE,sep='\t')
#FigS13E
kru_ionome_Fe = kruskal(ionome$Fe, ionome$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_ionome_Fe
#FigS13F
kru_ionome_Mn = kruskal(ionome$Mn, ionome$Sample, alpha=0.05, p.adj=c("bonferroni"), group=TRUE)
kru_ionome_Mn
