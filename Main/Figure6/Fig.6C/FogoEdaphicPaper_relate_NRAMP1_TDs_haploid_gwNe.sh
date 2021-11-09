#! /bin/bash -l

############################################
################   RELATE   ################
############################################

RELATE="/path_to_RELATE/Relate"

## Relate
${RELATE}/bin/Relate \
--mode All \
--haps chr1_Fogo_2SantoAntao_haploid.haps \
--sample chr1_Fogo_2SantoAntao_haploid.sample \
--map chr1_recmap.map \
--memory 20 --coal FO_relate_popsize.coal -m 1.42794e-09  \
-o  chr1_relate

# SampleBranchLengths (--format a)
for i in {30363708,30369728}; do ${RELATE}/scripts/SampleBranchLengths/SampleBranchLengths.sh \
-i chr1_relate \
-o chr1_relate_resample200_${i} \
-m 1.42794e-09 \
--coal Fogo_2SantoAntao_relate_popsize.coal \
--format a \
--num_samples 200 \
--first_bp ${i} \
--last_bp ${i} \
--seed 1; done

# SampleBranchLengths (for CLUES)
for i in {30363708,30369728}; do ${RELATE}/scripts/SampleBranchLengths/SampleBranchLengths.sh \
-i chr1_relate \
-o chr1_relate_resample200_CLUES_${i} \
-m 1.42794e-09 \
--coal Fogo_2SantoAntao_relate_popsize.coal \
--format b \
--num_samples 200 \
--first_bp ${i} \
--last_bp ${i} \
--seed 1; done

## TreeViewMutation
for i in {30363708,30369728}; do ${RELATE}/scripts/TreeView/TreeViewMutation.sh \
--haps chr1_Fogo_2SantoAntao_haploid.haps \
--sample chr1_Fogo_2SantoAntao_haploid.sample \
--anc chr1_relate.anc \
--mut chr1_relate.mut \
--poplabels fogos_2SantoAntao_poplabels.txt \
--bp_of_interest ${i} \
--years_per_gen 1 \
-o treeview_mutation_NRAMP1_${i}; done

## TreeViewSample
for i in {30363708,30369728}; do ${RELATE}/scripts/TreeView/TreeViewSample.sh \
--haps chr1_Fogo_2SantoAntao_haploid.haps \
--sample chr1_Fogo_2SantoAntao_haploid.sample \
--anc chr1_relate_resample200_${i}.anc \
--mut chr1_relate_resample200_${i}.mut \
--dist chr1_relate_resample200_${i}.dist \
--poplabels fogos_2SantoAntao_poplabels.txt \
--bp_of_interest ${i} \
--years_per_gen 1 \
-o treeview_sample_NRAMP1_${i}; done


############################################
################   CLUES    ################
############################################

clues_inference="/path_to_clues/clues"
timeBins="/path_to_timebins/timebins_2epochs.txt"

## Inference of selection and allele frequency trajectory for NRAMP1 ATG-TD (30363708)
python ${clues_inference}/inference.py \
--times chr1_relate_resample200_CLUES_30363708 \
--popFreq 0.64 \
--tCutoff 5000 \
--timeBins ${timeBins} \
--coal FO_relate_popsize.coal \
--sMax 1 \
--df 100 \
--dom 0.5 \
--out chr1_NRAMP1_30363708_inference

## Inference of selection and allele frequency trajectory for NRAMP1 AAGACATAA-TD (30369728)
python ${clues_inference}/inference.py \
--times chr1_relate_resample200_CLUES_30369728 \
--popFreq 0.32 \
--tCutoff 5000 \
--timeBins ${timeBins} \
--coal FO_relate_popsize.coal \
--sMax 1 \
--df 100 \
--dom 0.5 \
--out chr1_NRAMP1_30369728_inference
