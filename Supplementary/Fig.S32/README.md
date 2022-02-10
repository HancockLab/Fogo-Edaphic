# Geographical distribution of the *NRAMP1* haplotypes

## Requirements

#### Software

* R (version 3.6.2)

#### R packages

* ggplot2 (version 3.2.1)
* ggmap (version 3.0.0)
* scatterpie (version 0.1.6)

#### Input

* NRAMP1_map.txt

## Code

```R
df <- read.table("NRAMP1_map.txt", header = T, sep = '\t') #txt file

Map = c(left = -24.41, bottom = 14.915, right = -24.32, top = 15.02) #determine_coordinates
mapacc <- get_stamenmap(Map, zoom = 12, maptype = c("terrain-background")) #download_map

df$radius=df$radius /3
PDF=paste("NRAMP1_haplotype.pdf", sep = "")
pdf(PDF)
ggmap(mapacc) +
	labs(x = 'Longitude', y = 'Latitude') +
	geom_scatterpie(aes(x=long, y=lat, group=population,r=radius),
				data=df, cols=c('freq_salmon','freq_dodgerblue','freq_gray','freq_gold'),color=NA) +
				scale_fill_manual(labels = c('','','',''),
				values = c("dodgerblue", "gold","dimgray","red"))+
				labs(fill = "NRAMP1 haplotype")+
	geom_scatterpie_legend(df$radius, x=-24.385, y=14.94, n=3, labeller= function(x) (x/0.005*10)*3)
dev.off()
```
