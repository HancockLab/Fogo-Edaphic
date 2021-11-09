#!/usr/bin/python

"""		  FILE: mergeDelly.py
		 USAGE: ---
   DESCRIPTION: ---
	   OPTIONS: ---
  REQUIREMENTS: ---
		  BUGS: ---
		 NOTES: ---
		AUTHOR: Emmanuel Tergemina
  ORGANIZATION: Department of Plant Developmental Biology, Max Planck Institute for Plant Breeding Research
	   VERSION: 1.0
	   CREATED: 20200502
	  REVISION: ---
"""
import glob
import os

path2bcf='/path2bcf/'
path2delly='/path2delly/delly'


files = []
for file in glob.glob(path2bcf+ '*.bcf'):
	files.append(file)
string = ' '.join(files)
os.system(path2delly + ' merge ' + string -)

