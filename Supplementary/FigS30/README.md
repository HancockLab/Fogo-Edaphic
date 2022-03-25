###
# Scripts to extract joint site frequency spectra (JSFS) from a SNP matrix derived from a vcf file. The JSFS are used for demographic inference with dadi (Gutenkunst et al. 2009)
###


### java/ 
Folder with programs in java. The java programs assume that you have the /java/ folder from GitHub in your home directory, and that the directory structure is the same as in /java/. 
If not so, you will need to change some paths (e.g. to the libraries in ./java/lib/)

To run these java programs, enter the ./java/projects directory and you will find:

matrix_from_vcf.command	
Reads a VCF file (download from EVA) and creates a SNP matrix filtered for coverage and quality.

sfs_lounch_2popsToLyrata.command
Computes Joint and marginal Site Frequency Spactra for two populations, polarised to a population of your choice (can be A. lyrata)


### data/
Contains support files: sample ID lists for the three populations in Fogo, and a mask tio select intergenic regions




