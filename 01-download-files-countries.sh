#!/bin/bash

geofabrik_file=$1
country_code=$2
this_dir=$(pwd)
shp_download_dir=$this_dir/downloads/shp/$country_code/

mkdir -p $shp_download_dir

local_geo_file=$shp_download_dir$(basename $geofabrik_file)

if [ ! -f $local_geo_file ]; then
    echo "File not found! Downloading."
    wget $geofabrik_file  -P $shp_download_dir
fi
unzip -n $local_geo_file -d $shp_download_dir
