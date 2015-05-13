# expects 'fieldtype' variable to be defined on command line
#
# example: gnuplot -e 'fieldtype="long"' plot.gnuplot

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
datafile(base) = "output/".base.".plotdata.tsv"

### plot the (real) value counts

set output 'output/'.fieldtype.'_num_values.png'

set xlabel "Num Values Expected (# Docs * 3)"
set ylabel "Num Values"

set title "Number of Values Found (".fieldtype." field)" noenhanced

plot datafile(fieldtype."_countdistinct") using (x3($1)):2 title "countDistinct" ls 1, \
     datafile(fieldtype."_cardinality=7") using (x3($1)):2 title "cardinality=0.7" ls 2, \
     datafile(fieldtype."_cardinality=5") using (x3($1)):2 title "cardinality=0.5" ls 3, \
     datafile(fieldtype."_cardinality=true") using (x3($1)):2 title "cardinality=true (0.3)" ls 4

### plot the relative error of the value counts

set output 'output/'.fieldtype.'_rel_error.png'

set xlabel "Num Values Expected (# Docs * 3)"
set ylabel "Relative Error"

set title "Compared to Expected: Relative Error of Value Counts (".fieldtype." field)" noenhanced

plot datafile(fieldtype."_countdistinct") using (x3($1)):(relerr(x3($1), $2)) title "countDistinct" ls 1, \
     datafile(fieldtype."_cardinality=7") using (x3($1)):(relerr(x3($1), $2)) title "cardinality=0.7" ls 2, \
     datafile(fieldtype."_cardinality=5") using (x3($1)):(relerr(x3($1), $2)) title "cardinality=0.5" ls 3, \
     datafile(fieldtype."_cardinality=true") using (x3($1)):(relerr(x3($1), $2)) title "cardinality=true (0.3)" ls 4

### plot the the timing data

# crop some of the really noisy data (not enough warming in particular) so detail is more clear
set yrange [0:2]

set output 'output/'.fieldtype.'_timing.png'

set xlabel "Num Values Expected (# Docs * 3)"
set ylabel "Req Time (sec)"

set title "Request Time (".fieldtype." field)" noenhanced

plot datafile(fieldtype."_countdistinct") using (x3($1)):3:4 with errorbars title "countDistinct" ls 1, \
     datafile(fieldtype."_cardinality=7") using (x3($1)):3:4 with errorbars title "cardinality=0.7" ls 2, \
     datafile(fieldtype."_cardinality=5") using (x3($1)):3:4 with errorbars title "cardinality=0.5" ls 3, \
     datafile(fieldtype."_cardinality=true") using (x3($1)):3:4 with errorbars title "cardinality=true (0.3)" ls 4
