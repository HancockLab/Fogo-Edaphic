#!/bin/bash
path2output='/path2output/'

for i in ${path2output}*_TD
do
	TD=`basename $i _TD`
	grep ChrID ${path2output}${TD}_TD > ${path2output}${TD}_TD_head
done
