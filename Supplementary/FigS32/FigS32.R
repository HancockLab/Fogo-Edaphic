library(ggplot2)
library(ggmap)
library(ggrepel)
library(maps)
library(rworldmap)
library(mapproj)
library(scatterpie)

df <- read.table("FigS32.csv", header = T, sep = '\t') #txt file

Map = c(left = -24.41, bottom = 14.915, right = -24.32, top = 15.02) #determine_coordinates
mapacc <- get_stamenmap(Map, zoom = 12, maptype = c("terrain-background")) #download_map

df$Radius=df$Radius /3
PDF=paste("FigS32.pdf", sep = "")
pdf(PDF)
ggmap(mapacc) +
  labs(x = 'Longitude', y = 'Latitude') +
  geom_scatterpie(aes(x=Longitude, y=Latitude, group=Population,r=Radius),
                  data=df, cols=c('Ancestral_Freq','AAGACATAA_TD_Freq','ATG_TD_Freq','CT_TD_Freq'),color=NA) +
                scale_fill_manual(labels = c('','','',''),
                values = c("#3573B9", "#F1BB7B","#5B1A18","#FD6467"))+
                labs(fill = "NRAMP1 haplotype")+
  geom_scatterpie_legend(df$Radius, x=-24.385, y=14.94, n=3, labeller= function(x) (x/0.005*10)*3)
dev.off()
