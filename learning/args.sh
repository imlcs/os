#!/bin/bash
set -u
set -x

for parameter in $*
do
	echo $parameter
done
echo "-------------------"
echo $#
