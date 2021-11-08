#!/usr/bin/python
#===============================================================================#
#		  FILE: windowSizeStep4BSA.0.py
#		 USAGE: ---
#  DESCRIPTION: Get the allele frequency median and standard deviation for each chromosome. In this case for 21226
#	   OPTIONS: ---
# REQUIREMENTS: ---
#		  BUGS: ---
#		 NOTES: ---
#	    AUTHOR: Emmanuel Tergemina
# ORGANIZATION: Department of Plant Developmental Biology, Max Planck Institute for Plant Breeding Research
#	  VERSION: 1.0
#	  CREATED: 201912230
#	 REVISION: ---
#===============================================================================
import glob
import os
import re
import time
import numpy as np
import sys

start = time.time()

accession = sys.argv[1]
path2file='/path2file/'
file = path2file + accession + '-3536_E_AF_GW_DP18.txt'
path2output = '/path2output/'




windowStep=5000
windowSize=200000



size = [30427671,19698289,23459830,18585056,26975502]

output = open(path2output + accession + '-3536_E_AF_GW_DP18_AF5000-200000.txt', 'wt',0)
output.write('Chrom\tWindow\tFreq_Mean\tFreq_Median\tSTD\n')
genome = ([],[],[],[],[])

n=0
for line in open(file, 'r'):
	if not 'POSITION' in line:
		tmp1 = line.strip().split()
		if n != int(tmp1[0][3])-1:
			n = int(tmp1[0][3])-1
			genome[n].append((tmp1[1],tmp1[4]))
		elif n == int(tmp1[0][3])-1:
			genome[n].append((tmp1[1],tmp1[4]))



for i in range(len(size)):
	x = 0
	for j in range(1,size[i]):
		if j % int(windowStep) == 0 and j < size[i]- int(windowSize):
			tmp2 = []
			for idx, (position, allele) in enumerate(genome[i], start = x):
				if int(position) < j:
					index = int(idx)
				elif j <= int(position) <= j + int(windowSize):
					tmp2.append(float(allele))
				elif int(position) > j + int(windowSize):
					break
			output.write('{}{}\t{}\t{}\t{}\t{}\t\n'.format('chr',str(i+1),j,np.mean(tmp2),np.median(tmp2),np.std(tmp2)))
		elif j > size[i]- int(windowSize):
			break
output.close()

end=time.time()
print end-start













