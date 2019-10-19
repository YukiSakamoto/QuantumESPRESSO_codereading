#!/usr/bin/sh

ext=png

for file in `ls *.dot`
do
	echo "${file} === dot ===> `basename ${file} .dot`.${ext}"
	dot -T ${ext} ${file} -o `basename ${file} .dot`.${ext}
done;

