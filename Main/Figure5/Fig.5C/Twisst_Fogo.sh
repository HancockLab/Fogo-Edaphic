##################################################################################################
############## Inferred phylogenetic weighting in Fogo population using twisst ###############
##################################################################################################

vcftools="/path_to_vcftools/vcftools"
parseVCF="/path_to_genomics_general/VCF_processing/parseVCF.py"
phyml_sliding_windows="/path_to_genomics_general/phylo/phyml_sliding_windows.py"
twisst="/path_to_twisst/twisst.py"

############# LD prunning

# linkage pruning - i.e. output a list of SNPs to be pruned out
$vcftools --gzvcf CVI_SHORE_filtered.vcf.gz --plink --out CVI_SHORE_filtered
sed -i 's/^0\t/1\t/g' CVI_SHORE_filtered.map

# filter for LD in 50 kb windows, shifting by 10 kb with LD threshold 0.1
$plink --file CVI_SHORE_filtered \
--indep-pairwise 50 10 0.1 \
--out CVI_SHORE_filtered --noweb --silent
sed -i 's/:/\t/g' CVI_SHORE_filtered.prune.in

# Output pruned file in vcf format
$vcftools --gzvcf CVI_SHORE_filtered.vcf.gz \
--out CVI_SHORE_filtered.pruning \
--positions CVI_SHORE_filtered.prune.in \
--stdout --recode | gzip > CVI_SHORE_filtered.LDpruned.vcf.gz

### Parse the VCF and convert to geno format
python $parseVCF -i CVI_SHORE_filtered.LDpruned.vcf.gz > CVI_SHORE_filtered_LDpruned.geno

## get neighbour joining trees for 50 SNPs window
python $phyml_sliding_windows \
-T 10 \
-g CVI_SHORE_filtered_LDpruned.geno \
--prefix CVI_SHORE_filtered_LDpruned \
-w 50 --windType sites --model GTR --optimise n

######## perform Twisst [with SantoAntao as an outgroup]
python $twisst \
-t CVI_SHORE_filtered_LDpruned.trees.gz \
-w CVI_SHORE_filtered_LDpruned.data.tsv \
-g Inferno -g MonteVelha -g Lava -g SantoAntao \
--outgroup SantoAntao \
--method complete \
--groupsFile $CVI_ids_twisst \
--outputTopos CVI_SHORE_filtered_LDpruned_topologies.trees

#######################################################################################################################################
