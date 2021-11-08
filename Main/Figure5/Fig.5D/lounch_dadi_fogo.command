#!/bin/bash
#


for sfs in "List of paths to JSFS for all population pairs"
do
	results=${sfs}_dadiResults
	mkdir -p ${results}
	for r in {0.199}
	do	
		python simple_unfolded.py ${r} 'pop_split' ${results} ${sfs} 
   		python simple_unfolded.py ${r} 'exp' ${results} ${sfs}
  		python simple_unfolded.py ${r} 'im' ${results} ${sfs}
		python simple_unfolded.py ${r} 'bottleneck' ${results} ${sfs}
	done
done

