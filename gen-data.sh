#!/bin/bash -x


NUM_DOCS=10000000
RANGE_MULT=1000
MAX_RANGE=500000

mkdir -p input

perl gen-docs.pl $NUM_DOCS > input/sorted_docs.csv
shuf input/sorted_docs.csv > input/random_docs.csv

perl gen-queries.pl $NUM_DOCS $RANGE_MULT $MAX_RANGE > input/queries.tsv
