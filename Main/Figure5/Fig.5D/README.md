###
# Scripts to perform demographic inference based on the JSFS, with dadi (Gutenkunst et al. 2009)
###


### lounch_dadi_fogo.command
Lounches jobs to run dadi inference for the Fogo populations. Calls simple_unfolded.py

### simple_unfolded.py
Called by the previous script: actually runs dadi

### orgnise_dadi_results_fogo.R
Summarises results from dadi and outputs a table of optimised paramaeters, likelihoods, AIC for each model

### uncert_dadi.py
Script to run uncertainties in dadi
