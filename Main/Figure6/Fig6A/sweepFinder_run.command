#!/bin/bash
#

###
# Take care of the recombination map
###
vcf_map="Path to a .map file"
#
# Find the following program in the folder ./jsfs/java:
#
java -Xmx4G -classpath ~/java/lib/junit.jar:~/java/lib/jbzip2-0.9.1.jar:~/java/lib/args4j-2.0.12.jar:~/java/lib/commons-compress-1.0.jar:~/java/lib/gson-1.6-javadoc.jar:~/java/lib/gson-1.6-sources.jar:~/java/lib/gson-1.6.jar:bin c.e.data_processing.Build_recom_rate_infile_chromoPainter ${vcf_map}
#
# Take care of the sweeping Finder
#
wholeGen="Path to a whole genome input file"
spectFile="Path to results on spectFile"

./SweepFinder2 -f ${wholeGen} ${spectFile}

# Loop through the 5 chromosomes:
 for c in {0..4}
  do
   echo ${c}
   for winSize in 10000 50000 100000
    do
    echo ${winSize}
    sweepSnp="Path to single chromosome SweepFinder input file"
    sweepRecMap=${vcf_map}_forSweepFinder.map
    ###
    #		Old sweepFinder
    ###    
    outFile=${sweepSnp}_result_old_${c}_${winSize}.txt
    ./SweepFinder2 -lg ${winSize} ${sweepSnp} ${spectFile} ${outFile}
    #
    ###		New SweepFinder
    outFile=${sweepSnp}_result_new_${c}_${winSize}.txt
    ./SweepFinder2 -lrg ${winSize} ${sweepSnp} ${spectFile} ${sweepRecMap} ${outFile}
    done
  done
 
