#!/Users/tergemina/anaconda3/bin/python


'''
		 FILE: parsePictures20201210.py
		USAGE: ---
  DESCRIPTION: ---
	  OPTIONS: ---
 REQUIREMENTS: ---
		 BUGS: ---
		NOTES: ---
	   AUTHOR: Emmanuel Tergemina
 ORGANIZATION: Department of Plant Developmental Biology, Max Planck Institute for Plant Breeding Research
	  VERSION: 1.0
	  CREATED: 20201217
	 REVISION: ---
'''

import os
import glob
import re


path2logFiles='/path2logFiles/'
path2sampleList='/path2sampleList.txt'
path2imageList='/path2imageList.txt'
path2groupList='/path2groupList.txt'

group={}
for line in open(path2groupList, 'r'):
	tmp=line.strip().split()
	group[tmp[0]] = tmp[1]

sample={}
for line in open(path2sampleList,'r'):
	if not "Sample" in line:
		tmp=line.strip().split()
		var='{}_Plant{}'.format(tmp[1],tmp[2][3:])
		sample[var] = tmp[0]

image={}
for line in open(path2imageList,'r'):
	tmp=line.strip().split()
	image[tmp[0]] = tmp[1]

output = open('analysis20201210.txt','wt')
output.write('Tray\tPosition\tSample\tGroup\tRed\tGreen\tBlue\tArea\tPerim\tMajor\n')
for file in glob.glob(path2logFiles + '*.txt'):
	base=os.path.basename(file)
	index1=re.search('Plant_',base).end()
	index2=re.search('.txt',base).start()
	position=base[index1:index2]
	tray=image[base[:8]]
	geno='{}{}'.format(tray,base[8:index2])
	genotype=sample[geno]
	for line in open(file,'r'):
		if not 'Red' in line:
			output.write('{}\t{}\t{}\t{}\t{}'.format(tray[5:],position,genotype,group[genotype],line))
output.close()
