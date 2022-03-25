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

### Plot
cm=1/2.54
#### Fig 1D
figure='Fig1D'
PDF=paste(figure,".pdf", sep = "")
pdf(PDF,width=10*cm, height = 7*cm)
fviz_pca_biplot(PCA_CVIvsMO,  repel = TRUE ,
                col.ind = df_CVIvsMO_pop$Population,
                addEllipses = TRUE, label = "var",
                col.var = "black",
                legend.title = "Population",
                palette = c('#FFA405','#A7E99C','#0075DC'),
                labelsize=2,
                pointsize = 1,
                arrowsize = 0.2,
                title='') + 
                theme(axis.title = element_text(size = 8),
                      axis.text = element_text(size = 6),
                      legend.title = element_text(size = 8),
                      legend.text=element_text(size=6),
                      legend.key.size = unit(0.4, "cm"),
                      legend.key.width = unit(0.4,"cm")) +
              theme_classic()
dev.off()


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






















