#! /bin/bash -l

############################################
################   RELATE   ################
############################################

RELATE="/path_to_RELATE/Relate"

bp=10707874

## Relate
${RELATE}/bin/Relate \
--mode All \
--haps chr4_Fogo_2SantoAntao_haploid.haps \
--sample chr4_Fogo_2SantoAntao_haploid.sample \
--map chr4_recmap.map \
--memory 20 --coal FO_relate_popsize.coal -m 1.55189e-09 \
-o  chr4_relate

# SampleBranchLengths (--format a)
${RELATE}/scripts/SampleBranchLengths/SampleBranchLengths.sh \
-i chr4_relate \
-o chr4_relate_resample200 \
-m 1.55189e-09 \
--coal FO_relate_popsize.coal \
--format a \
--num_samples 200 \
--first_bp ${bp} \
--last_bp ${bp} \
--seed 1 

# SampleBranchLengths (CLUES)
${RELATE}/scripts/SampleBranchLengths/SampleBranchLengths.sh \
-i chr4_relate \
-o chr4_relate_resample200_CLUES \
-m 1.55189e-09 \
--coal FO_relate_popsize.coal \
--format b \
--num_samples 200 \
--first_bp ${bp} \
--last_bp ${bp} \
--seed 1 

## TreeViewMutation
${RELATE}/scripts/TreeView/TreeViewMutation.sh \
--haps chr4_Fogo_2SantoAntao_haploid.haps \
--sample chr4_Fogo_2SantoAntao_haploid.sample \
--anc chr4_relate.anc \
--mut chr4_relate.mut \
--poplabels fogos_2SantoAntao_poplabels.txt \
--bp_of_interest ${bp} \
--years_per_gen 1 \
-o treeview_mutation_IRT1

## TreeViewSample
${RELATE}/scripts/TreeView/TreeViewSample.sh \
--haps chr4_Fogo_2SantoAntao_haploid.haps \
--sample chr4_Fogo_2SantoAntao_haploid.sample \
--anc chr4_relate_resample200.anc \
--mut chr4_relate_resample200.mut \
--dist chr4_relate_resample200.dist \
--poplabels fogos_2SantoAntao_poplabels.txt \
--bp_of_interest ${bp} \
--years_per_gen 1 \
-o treeview_sample_IRT1


############################################
################   CLUES    ################
############################################

clues_inference="/path_to_clues/clues"
timeBins="/path_to_timebins/timebins_3epochs.txt"

## Inference of selection and allele frequency trajectory for IRT1 (Chr4:10707874)
python ${clues_inference}/inference.py \
--times chr4_relate_resample200_CLUES \
--popFreq 0.99 \
--tCutoff 5000 \
--timeBins ${timeBins} \
--coal FO_relate_popsize.coal \
--sMax 1 \
--df 100 \
--dom 0 \
--out chr4_IRT1_inference
