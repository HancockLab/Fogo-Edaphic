#!/usr/bin/python
#===============================================================================
#
#         FILE: NRAMP1copyNumber2surrounding.py
#
#        USAGE: ./NRAMP1copyNumber2surrounding.py
#
#  DESCRIPTION: create ratio window step-size to surrounding region
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



#os.system('samtools depth -r chr1:30360000-30384000 21225.sorted.bam > cnvTmp.txt')

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

path2bam = '/srv/netscratch/irg/grp_hancock/Manu/4test/bams/'
# path2bam = '/srv/netscratch/dep_coupland/grp_hancock/Manu/4test/testBams/'
path2output = '/srv/netscratch/irg/grp_hancock/Manu/4test/output/copyNumber/windows/202104/'
path2BP = '/home/tergemina/CVI_Project/computer/NRAMP1hap/BPfromVCF.txt'
path2genomeCoverage = '/srv/netscratch/irg/grp_hancock/Manu/4test/output/copyNumber/windows/coverageGenome/'
path2NRAMP1Coverage = '/srv/netscratch/irg/grp_hancock/Manu/4test/output/copyNumber/windows/coverageNRAMP1/'
bsub_setting = 'bsub -q normal '
logFiles = '/srv/netscratch/irg/grp_hancock/Manu/4test/output/copyNumber/windows/202104/logFiles/'

windowStep = input('WindowStep?\n')
windowSize = input('WindowSize?\n')
surrounding = input('Which surrounding region size?\n')

outputName = path2output + 'TDcopyNumberWindowSize' + str(windowSize) + 'WindowStep' + str(windowStep) + 'VS' + str(surrounding)
output = open(outputName, 'wt')
output.write('Accession\tSurroundingcoverage\tWindowcoverage\tTDcopy\n')

#Import the bam files source
for bam in glob.glob(path2bam + '*.sorted.bam'):
	start = 0
	end = 0
	base=os.path.basename(bam)
	index = re.search('.sorted.bam',base).start()
	accession = base[:index]

	#Extract the break points for accession
	for line in open(path2BP,'r'):
		tmp1 = line.strip().split()
		# print tmp1
		if tmp1[0] == d[accession] and str(tmp1[1]) != 'Na':
			start = int(tmp1[1])
			end = int(tmp1[2])
	if start != 0:
		#Extract coverage information between breakpoints for accession
		nramp1Coverage = []
		up = []
		down = []
		for line in open(path2NRAMP1Coverage + accession + '_30350000-30400000_coverage','r'):
			tmp1 = line.strip().split()
			nramp1Coverage.append(tmp1)
			if start - int(surrounding) <= int(tmp1[1]) <= start:
				up.append(int(tmp1[2]))
			elif end <= int(tmp1[1]) <= end + int(surrounding):
				down.append(int(tmp1[2]))

		upCoverage = sum(up)/len(up)
		downCoverage = sum(down)/len(down)
		surroundingCoverage = (upCoverage + downCoverage) / 2
		print surroundingCoverage

		tandemDuplication = end - start
		for i in range(tandemDuplication):
			position = i + start
			if position % int(windowStep) == 0 and position < end - int(windowSize):
				tmp1 = []
				for j in nramp1Coverage:
					if position <= int(j[1]) <= position + windowSize:
						tmp1.append(int(j[2]))
				coverage = sum(tmp1)/len(tmp1)
				ratio = coverage/surroundingCoverage
				# print accession, str(ratio)
				output.write(accession + '\t' + str(surroundingCoverage) + '\t' + str(coverage) + '\t' + str(ratio) + '\n')
output.close()

	# # for i in range(end-start):
	#     print i
		# if i % int(windowStep) == 0 and i < end - int(windowSize):
		#     print i











	# print bsub_setting + '-o ' + logFiles + accession + '_std.out -e ' + logFiles + accession + '_std.err ' + '"samtools depth -r chr1:' + str(start) + '-' + str(end) + ' ' + bam +  ' > ' + path2output + accession + '_30350000-30400000_coverage"')
	# os.system(bsub_setting + '-o ' + logFiles + accession + '_std.out -e ' + logFiles + accession + '_std.err ' + '"samtools depth -r chr1:' + str(start) + '-' + str(end) + ' ' + bam +  ' > ' + path2output + accession + '_30350000-30400000_coverage"')




















