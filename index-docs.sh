#!/bin/bash -x

curl 'http://localhost:8983/solr/gettingstarted/update?rowid=id&header=false&fieldnames=id_ti,long_data_ls,string_data_ss&f.long_data_ls.split=true&f.string_data_ss.split=true&f.long_data_ls.separator=%20&f.string_data_ss.separator=%20&commit=true' -H 'Content-Type: application/csv'  --data-binary @- < input/random_docs.csv
