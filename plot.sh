#!/bin/bash

set -x
set -o errexit
set -o nounset

gnuplot -e 'fieldtype="long"' plot.gnuplot

gnuplot -e 'fieldtype="string"' plot.gnuplot
