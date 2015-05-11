#!/usr/bin/perl -l

# usage ./crunch-stats output/countDistinct_long_joined.tsv > output/countDistinct_long_plotdata.tsv
#
# expects whitespace delimited data..
# - column 0: id for the range/query
# - pairwise columns after that:
#   - odd colums: cardinality of result
#   - even colums: time spent in seconds
#
# Fails fast if cardinality doesn't match for entire record
# generates tab seperated "id, cardinality, mean time, stddev time" for each input record

use warnings;
use strict;

use Statistics::Lite qw(stddev mean);

while (<>) {
    chomp;
    my @data = split;
    my $key = shift @data;
    my $count = $data[0];
    my @times;
    while (@data) {
	die "count's don't match: $key" unless $count == $data[0];
	$count = shift @data;
	push @times, shift @data;
    }
    my $mean = mean @times;
    my $stddev = stddev @times;
    print "$key\t$count\t$mean\t$stddev";
}
