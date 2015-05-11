#!/usr/bin/perl -l
#
# usage: perl gen-random-docs-csv.pl 1000
# -> generates 1000 docs with uniqueKey and 2 other fields
# -> each field contains the exact same 3 "long" values seperated by a space
#    (so they can be index both as numeric & string values w/o needing to muck with schema)
#
# Example of how to index...
#
#   perl gen-random-docs-csv.pl 1000 > data.csv
#   curl 'http://localhost:8983/solr/gettingstarted/update?rowid=id&header=false&fieldnames=id_ti,long_data_ls,string_data_ss&f.long_data_ls.split=true&f.string_data_ss.split=true&f.long_data_ls.separator=%20&f.string_data_ss.separator=%20&commit=true' -H 'Content-Type: application/csv'  --data-binary @- < data.csv
#

use strict;
use warnings;
use integer;

my $MAX_VAL = (2**63)-1;

my $num_docs = shift;
die "Need to specify a number of documents" unless $num_docs;

while ($num_docs--) {
    my $field_value = join ' ', map { sprintf("%d", rand( $MAX_VAL )) } (1..3);
    print qq{$num_docs,"$field_value","$field_value"};
}

