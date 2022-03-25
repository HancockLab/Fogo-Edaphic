#!/usr/bin/python
#===============================================================================#
#		  FILE: parent2F2.py
#		 USAGE: ---
#  DESCRIPTION: Get markers from one parent (considering that Col-0 is used) and collect allele frequency for the F2. In this case with 3536_E
#	   OPTIONS: ---
# REQUIREMENTS: ---
#		  BUGS: ---
#		 NOTES: ---
#	    AUTHOR: Emmanuel Tergemina
# ORGANIZATION: Department of Plant Developmental Biology, Max Planck Institute for Plant Breeding Research
#	   VERSION: 1.0
#	   CREATED: 20191230
#	  REVISION: ---
#===============================================================================

import glob
import sys
import os
import re
import time

start = time.time()

path2vcf = '/path2vcf/'
path2output = '/path2output/'

accession = sys.argv[1]

genome = ([],[],[],[],[])
def chromParser(var):
	index = int(var[0][3])-1
	genome[index].append(var[1])


bad = ['./.','.|.','0/0:0,0','0|0:0,0','*']

output = open(path2output + accession + '-3536_E_AF_GW.txt','wt',0)
output.write('CHROM\tPOSITION\tREF\tALT\tAF\tDP\tSAMPLE\n')
for line in open(path2output + '3536_E.GVCF.GATK.QUAL100.Hm.vcf', 'r'): #This file has been previously filter for QUAL > 100 and Hm (1|1 and 1/1)
	if not '#' in line and not "mitochondria" in line and not "chloroplast" in line:
		tmp1 = line.strip().split()
		nbrAlt = tmp1[4].count(',')
		if nbrAlt == 1:
			depth = tmp1[7].split(';')[0]
			if 'DP' in depth:
				if int(depth[3:]) > 20:
					chromParser(tmp1)



n = 0
chrom = 0
for line in open(path2vcf + accession + '.BP.GATK.vcf', 'r'):
	if not '#' in line and not "mitochondria" in line and not "chloroplast" in line:
		tmp2 = line.strip().split()
		PosF2 = tmp2[1]
		if chrom != int(tmp2[0][3])-1:
			print True
			n = 0
			chrom = int(tmp2[0][3])-1
			if int(PosF2) == int(genome[chrom][n]):
				count = tmp2[4].count(',')
				if count > 2:
					n+=1
				else:
					if '.' in tmp2[9][:3] or tmp2[9][4:7] == '0,0':
						n+=1
					else:
						info = tmp2[len(tmp2)-1].split(':')
						allele = info[1].split(',')
						if int(info[2]) != int(allele[0]) and tmp2[4] == '<NON_REF>':
							n+=1
						else:
							# print '{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(tmp2[0],PosF2, tmp2[3], tmp2[4],float(allele[0])/float(info[2]),info[2],info[1])
							output.write('{}\t{}\t{}\t{}\t{}\t{}\t{}\n'.format(tmp2[0],PosF2, tmp2[3], tmp2[4],float(allele[0])/float(info[2]),info[2],info[1]))
							n+=1
		else:
			if n < len(genome[chrom]):
				if int(PosF2) == int(genome[chrom][n]):
					count = tmp2[4].count(',')
					if count > 2:
						n+=1
					else:
						if '.' in tmp2[9][:3] or tmp2[9][4:7] == '0,0':
							n+=1
						else:
							info = tmp2[len(tmp2)-1].split(':')
							allele = info[1].split(',')
							if int(info[2]) != int(allele[0]) and tmp2[4] == '<NON_REF>':
								n+=1
							else:
								# print '{}\t{}\t{}\t{}\t{}\t{}\t{}'.format(tmp2[0],PosF2, tmp2[3], tmp2[4],float(allele[0])/float(info[2]),info[2],info[1])
								output.write('{}\t{}\t{}\t{}\t{}\t{}\t{}\n'.format(tmp2[0],PosF2, tmp2[3], tmp2[4],float(allele[0])/float(info[2]),info[2],info[1]))
								n+=1
			# else:
			# 	break
output.close()

end=time.time()
print end-start

