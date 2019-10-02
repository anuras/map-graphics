#!/bin/bash

# 5. download generated maps
country=ca
version=v1
res=3543_4724
color=Azure

this_dir=$(pwd)
states="ab bc mb nb nl ns on qb sk"
for state in $states
do
    gs_output_dir="gs://carto-storage/output/"$country/$state/$version/$res/$color
    local_dir=$this_dir/output/$country/$state/$version/$res/$color
    mkdir -p $local_dir
    gsutil -m cp -r $gs_output_dir/* $local_dir
done
