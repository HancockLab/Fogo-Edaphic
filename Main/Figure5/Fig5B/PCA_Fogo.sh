#############################################################################
################# Population structure within Fogo (PCA) ################
#############################################################################

bcftools="/path_to_bcftools/bcftools"
plink="/path_to_plink/plink"

################### Remove non-biallelic SNPs, filtering for quality, and filtered out missing data
$bcftools view -m2 -M2 -v snps -i 'MIN(FMT/DP)>3 & MIN(FMT/GQ)>25 & F_MISSING=0' CVI_SHORE.vcf -Oz > CVI_SHORE_filtered.vcf.gz

################### Subset for Fogo population
$bcftools view -S $Fogo_ids CVI_SHORE_filtered.vcf.gz -Oz > Fogo_SHORE_filtered.vcf.gz

# linkage pruning - i.e. output a list of SNPs to be pruned out
$plink --gzvcf Fogo_SHORE_filtered.vcf --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out Fogo_SHORE_filtered

# prune and create pca
$plink --gzvcf Fogo_SHORE_filtered.vcf --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract Fogo_SHORE_filtered.prune.in \
--make-bed --pca --out Fogo_SHORE_filtered

# >>>>>>>>>>>>>>>>>>>>>>>>>>>> In R
# load packages
#---------------------
library(tidyverse)
library(ggplot2)
library(dplyr)
library(data.table)
library(ggthemes)
#---------------------

# read in data
pca <- read_table2("Fogo_SHORE_filtered.eigenvec", col_names = FALSE)
eigenval <- scan("Fogo_SHORE_filtered.eigenval")
cols <- read.table("color.txt", header = T, sep = "\t", dec = ".")
# sort out the pca data
pca <- pca[,-1]
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))
# remake data.frame
PCA <- as.tibble(data.frame(cols, pca))
# convert to percentage variance explained
pve <- data.frame(PC = 1:20, pve = eigenval/sum(eigenval)*100)
# make plot
a <- ggplot(pve, aes(PC, pve)) + geom_bar(stat = "identity")
a + ylab("Percentage variance explained (%)") + theme_light()

# save plot
pdf(file = "percentage_variance_explained.pdf",width = 10, height = 5)
a + ylab("Percentage variance explained (%)") + theme_light()
dev.off()

#----
setEPS()
postscript("PC1vsPC2_ByRegion.eps",width=8, height = 10)
#----
ggplot(PCA, aes(PC1, PC2, color = ByRegion)) +
  geom_point(size=3) + 
  xlab("PC1") + 
  ylab("PC2") +
  theme_light()+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())+
  scale_colour_manual(values = c("#009E73", "#E69F00", "#D55E00"))+ theme(axis.text=element_text(size=17), axis.title=element_text(size=17))+ 
  theme(legend.text = element_text(size = 10))+ scale_x_reverse()+ 
theme(legend.position=c(.85,.1), legend.box.background = element_rect(colour = "black"))+ labs(color='Region')+ 
  theme(legend.title=element_blank(), legend.text=element_text(size=17))
#----
dev.off()
#----
#######################################################################################################################################