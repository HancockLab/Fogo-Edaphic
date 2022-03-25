library("FactoMineR")
library("factoextra")
library("dplyr")
library("corrplot")
library("tibble")

df = read.csv("Fig3C.csv",header=T,sep='\t')
df_CVIvsMO = remove_rownames(df) %>% 
  select(-c(Population)) %>% 
  column_to_rownames(var = "Sample")


df_CVIvsMO_pop = df %>% 
  select(Sample,Population)

PCA_CVIvsMO=PCA(df_CVIvsMO,scale.unit = TRUE,graph = FALSE)

var_CVIvsMO= get_pca_var(PCA_CVIvsMO)

### Plot
cm=1/2.54
#### Fig 3C
figure='Fig3C'
PDF=paste(figure,".pdf", sep = "")
pdf(PDF,width=10*cm, height = 7*cm)
fviz_pca_biplot(PCA_CVIvsMO,  repel = TRUE ,
                col.ind = df_CVIvsMO_pop$Population,
                addEllipses = TRUE, label = "var",
                col.var = "black",
                legend.title = "Population",
                palette = c('#FFA405','#A7E99C','red','red','#0075DC'),
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





















