##################################################################################################
############## Inferred phylogenetic weighting in Fogo population using twisst ###############
##################################################################################################

vcftools="/path_to_vcftools/vcftools"
parseVCF="/path_to_genomics_general/VCF_processing/parseVCF.py"
phyml_sliding_windows="/path_to_genomics_general/phylo/phyml_sliding_windows.py"
twisst="/path_to_twisst/twisst.py"

### Parse the VCF and convert to geno format
python $parseVCF -i CVI_SHORE_filtered.vcf.gz > CVI_SHORE_filtered.geno

## Get neighbour joining trees for 50 SNPs window
python $phyml_sliding_windows \
-T 10 \
-g CVI_SHORE_filtered.geno \
--prefix CVI_SHORE_filtered \
-w 50 --windType sites --model GTR --optimise n

######## Perform Twisst [with SantoAntao as an outgroup]
python $twisst \
-t CVI_SHORE_filtered.trees.gz \
-w CVI_SHORE_filtered.data.tsv \
-g Inferno -g MonteVelha -g Lava -g SantoAntao \
--outgroup SantoAntao \
--method complete \
--groupsFile $CVI_ids_twisst \
--outputTopos CVI_SHORE_filtered_topologies.trees