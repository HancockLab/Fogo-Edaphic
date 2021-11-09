#!/usr/bin/python
from __future__ import division
import glob
import os
import re
import numpy as np
import pandas as pd
import scipy.cluster.hierarchy as sch

Fogo = []
with open('./fogos_clean_2021-01-18.txt', 'r') as f:
	for line in f:
		Fogo.append(line.strip())

d = {}
with open('./idsToPlants_19-04-18.txt', 'r') as f:
	for line in f:
		if not '#' in line:
			# print line.strip()
			tmp1 = line.strip().split()
			if tmp1[0] in Fogo:
				d[tmp1[0]] = tmp1[1]

path2bam = '/path2bam/'
path2output = '/path2output/'
path2NRAMP1hap = '/path2NRAMP1hap/NRAMP1_hap.txt'
path2NRAMP1coverage = '/path2NRAMP1coverage/'


windowStep = 400
windowSize = 800
surrounding = 3000

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
	for line in open(path2NRAMP1hap,'r'):
		tmp1 = line.strip().split()
		if tmp1[0] == d[accession] and str(tmp1[1]) != 'Na':
			start = int(tmp1[1])
			end = int(tmp1[2])
	if start != 0:
		#Extract coverage information between breakpoints for accession
		nramp1Coverage = []
		up = []
		down = []
		for line in open(path2NRAMP1coverage + accession + '_30350000-30400000_coverage','r'):
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
				output.write(accession + '\t' + str(surroundingCoverage) + '\t' + str(coverage) + '\t' + str(ratio) + '\n')
output.close()