#!/bin/bash
set -u
set -x

name=lcs

for i in $(seq 10);do
    str=$(echo $RANDOM | md5sum | cut -c-10 | tr "0-9" "a-z")
    touch ./lcs/${str}_${name}.html
done
