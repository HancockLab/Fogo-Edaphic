#!/bin/bash
path2ref='/path2ref/TAIR10_all.fa'
path2bam='/path2bam/'
path2output='/path2output/'
path2delly='/path2delly/delly '



for i in $path2bam*.sorted.bam
do
	sra=`basename $i .sorted.bam`
	$path2delly call -o ${path2output}${sra}.bcf -g $path2ref -t DUP $path2bam$i
done

