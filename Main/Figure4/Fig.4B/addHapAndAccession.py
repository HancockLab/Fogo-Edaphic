#!/usr/bin/python
#===============================================================================
#
#         FILE: addHapAndAccession.py
#
#        USAGE: ./addHapAndAccession.py
#
#  DESCRIPTION: add hap and accession columns to dataframe
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES:
#       AUTHOR: Emmanuel Tergemina
# ORGANIZATION: Department of Plant Developmental Biology, Max Planck Institute for Plant Breeding Research
#      VERSION: 1.0
#      CREATED: 20191004
#     REVISION: ---
#===============================================================================
from __future__ import division
import glob
import os
import re
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import scipy.cluster.hierarchy as sch


Fogo = []
with open('/srv/biodata/irg/grp_hancock/VCF/fogos_clean_19-04-23.txt', 'r') as f:
	for line in f:
		Fogo.append(line.strip())

d = {}
with open('/srv/biodata/irg/grp_hancock/VCF/idsToPlants_19-06-17.txt', 'r') as f:
	for line in f:
		if not '#' in line:
			# print line.strip()
			tmp1 = line.strip().split()
			if tmp1[0] in Fogo:
				d[tmp1[0]] = tmp1[1]

file = '/srv/netscratch/irg/grp_hancock/Manu/4test/output/copyNumber/windows/202104/TDcopyNumberWindowSize800WindowStep400VS3000singleCopy'
path2BP = '/home/tergemina/CVI_Project/computer/NRAMP1hap/BPfromVCF.txt'
path2output = '/srv/netscratch/irg/grp_hancock/Manu/4test/output/copyNumber/windows/202104/'
output = open(path2output + 'TDcopyNumberWindowSize800WindowStep400VS3000singleCopy_4graph','wt')
output.write('SeqID\tAccession\tGenomecoverage\tWindowcoverage\tTDcopy\tHaplotype\n')

for line in open(file,'r'):
	tmp2 = line.strip().split()
	if tmp2[0] in d.keys():
		accession = d[tmp2[0]]
		for i in open(path2BP, 'r'):
			tmp3 = i.strip().split()
			# print tmp3[0]
			if tmp3[0] == accession:
				output.write(tmp2[0] + '\t' + accession + '\t' + '\t'.join(tmp2[1:len(tmp2)]) + '\t' + tmp3[3] + '\n')
				# print tmp2[0], accession, tmp3[0], tmp3[3]
output.close()















