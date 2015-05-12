#!/bin/bash

# usage:  do-3-runs.sh [stats field param] [out files basename]
#
# example do-3-runs.sh '{!key=k cardinality=0.7}long_data_ls' long_cardinality=7

set -x
set -o errexit
set -o nounset

for number in {1..3}; do
    ./run-queries.pl "${1}" < input/queries.tsv > output/${2}.${number}.tsv
    sleep 10
done

join output/${2}.1.tsv output/${2}.2.tsv > output/tmp 
join output/${2}.3.tsv output/tmp > output/${2}.merged.tsv
./crunch-stats.pl output/${2}.merged.tsv > output/${2}.plotdata.tsv
