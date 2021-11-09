bin/bash
output='/path2output/'
for i in $path2bam*.sorted.bam
do
	bam=`basename $i .sorted.bam`
	samtools depth $i -r chr1:30350000-30400000 > ${output}${bam}_30350000-30400000_coverage
done
