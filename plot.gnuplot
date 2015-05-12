set terminal png size 800,600 enhanced font "Helvetica,12"
set key top left

# same style for every line, just diff colors
set style line 1 pointtype 1
set style line 2 pointtype 1
set style line 3 pointtype 1
set style line 4 pointtype 1
set style line 5 pointtype 1
set style line 6 pointtype 1

x3(x) = (3 * x)
relerr(expected,observed) = abs(expected - observed) / expected

### plot the (real) value counts

set output 'output/long_num_values.png'

set xlabel "Num Values Expected (# Docs * 3)"
set ylabel "Num Values"

set title "Number of Values Found (long field)" noenhanced

plot "output/long_countdistinct.plotdata.tsv" using (x3($1)):2 title "countDistinct" ls 1, \
     "output/long_cardinality=true.plotdata.tsv" using (x3($1)):2 title "cardinality=true (0.3)" ls 2, \
     "output/long_cardinality=5.plotdata.tsv" using (x3($1)):2 title "cardinality=0.5" ls 3, \
     "output/long_cardinality=7.plotdata.tsv" using (x3($1)):2 title "cardinality=0.7" ls 4

### plot the relative error of the value counts

set output 'output/long_rel_error.png'

set xlabel "Num Values Expected (# Docs * 3)"
set ylabel "Relative Error"

set title "Compared to Expected: Relative Error of Value Counts (long field)" noenhanced

plot "output/long_countdistinct.plotdata.tsv" using (x3($1)):(relerr(x3($1), $2)) title "countDistinct" ls 1, \
     "output/long_cardinality=true.plotdata.tsv" using (x3($1)):(relerr(x3($1), $2)) title "cardinality=true (0.3)" ls 2, \
     "output/long_cardinality=5.plotdata.tsv" using (x3($1)):(relerr(x3($1), $2)) title "cardinality=0.5" ls 3, \
     "output/long_cardinality=7.plotdata.tsv" using (x3($1)):(relerr(x3($1), $2)) title "cardinality=0.7" ls 4

### plot the the timing data

set output 'output/long_timing.png'

set xlabel "Num Values Expected (# Docs * 3)"
set ylabel "Req Time (sec)"

set title "Request Time (long field)" noenhanced

plot "output/long_countdistinct.plotdata.tsv" using (x3($1)):3:4 with errorbars title "countDistinct" ls 1, \
     "output/long_cardinality=true.plotdata.tsv" using (x3($1)):3:4 with errorbars title "cardinality=true (0.3)" ls 2, \
     "output/long_cardinality=5.plotdata.tsv" using (x3($1)):3:4 with errorbars title "cardinality=0.5" ls 3, \
     "output/long_cardinality=7.plotdata.tsv" using (x3($1)):3:4 with errorbars title "cardinality=0.7" ls 4
