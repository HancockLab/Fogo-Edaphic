#!/bin/bash
path2config='/path2config/'
path2bam='/path2bam/'
path2ref='/path2ref/TAIR10_all.fas'
path2output='/path2output/'
path2snpEff='/path2snpEff/'
path2pindel='/path2pindel/'

for i in $path2bam*.sorted.bam
do
    sra=`basename $i .sorted.bam`
    echo "${path2bam}${sra}.sorted.bam    250 ${sra}"> ${path2config}'config_'${sra}
    ${path2pindel}pindel -f $path2ref -i ${path2config}'config_'${sra} -c ALL -o ${path2output}${sra} -T 20
done