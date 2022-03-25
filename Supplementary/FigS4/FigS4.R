library("FactoMineR")
library("factoextra")
library("dplyr")
library("corrplot")
library("tibble")

df = read.csv("Fig1D.csv",header=T,sep='\t')
df_CVIvsMO = remove_rownames(df) %>% 
  filter(Population != 'Mutant') %>%
  select(-c(Population)) %>% 
  column_to_rownames(var = "Sample")


df_CVIvsMO_pop = df %>% 
  filter(Population != 'Mutant') %>%
  select(Sample,Population)

PCA_CVIvsMO=PCA(df_CVIvsMO,scale.unit = TRUE,graph = FALSE)

var_CVIvsMO= get_pca_var(PCA_CVIvsMO)

#### Fig S4A
figure='FigS4A'
PDF=paste(figure,".pdf", sep = "")
pdf(PDF,width=10*cm, height = 10*cm)
fviz_eig(PCA_CVIvsMO, addlabels = FALSE, barfill="gray", geom="bar",barcolor ="black", ylim = c(0, 50), labelsize=30,title='') + 
  theme(axis.title = element_text(size = 16),
        axis.text = element_text(size = 6)) +
  theme_classic()
dev.off()


#### Fig S4B
figure='FigS4B'
PDF=paste(figure,".pdf", sep = "")
pdf(PDF,width=10*cm, height = 10*cm)
fviz_contrib(PCA_CVIvsMO, choice = "var", fill = "grey", color = "black",axes = 1,title="")+ 
  theme(axis.title = element_text(size = 8),
        axis.text = element_text(size = 6))
dev.off()






















