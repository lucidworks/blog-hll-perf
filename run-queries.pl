#!/usr/bin/perl

# usage: ./run-queries.pl [stats field param] < queries.tsv > results.tsv
#
# example: ./run-queries.pl '{!key=k countDistinct=true}long_data_ls' < input/queries.tsv > output/countDistinct_long.tsv
#
# NOTE: key MUST be k, and only one stat can be computed (ie: don't use calcDistinct, use countDistinct)

use strict;
use warnings;
use LWP::Simple;
use JSON;
use URI;
use Time::HiRes qw(gettimeofday tv_interval);
$| = 1;

my $sf = shift || die "you must specify a stats.field param";
my $uri = URI->new('http://localhost:8983/solr/gettingstarted/select');

# baseline params & warming query
my $params = {
    'fl' => 'id',
    'wt' => 'json',
    'start' => 0,
    'rows' => 0,
    'q' => 'id:1',       # simple warming query
    'stats' => 'true',
    'stats.field' => $sf,
};
$uri->query_form($params);

get($uri) || die "warming query failed";

for (<stdin>) {
    chomp;
    my ($range_size, $q) = split /\t/;

    $params->{'q'} = $q;
    $uri->query_form($params);

    my $timer_start = [gettimeofday];
    my $rawdata = get($uri);
    my $timer_end = [gettimeofday];

    my $data = decode_json($rawdata);

    # sanity check response
    die "Not enough docs matched: $rawdata" unless $range_size == $data->{'response'}->{'numFound'};
    
    my @values = values %{ $data->{'stats'}->{'stats_fields'}->{'k'} };
    die "Too many stat values: $rawdata" unless 1 == scalar @values;

    print STDOUT $range_size, "\t", $values[0], "\t", tv_interval($timer_start, $timer_end), "\n";
} 
