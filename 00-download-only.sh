#!/bin/bash
set -x

country_input_files="europe-countries.csv"
country_input_files=""
state_input_files="europe-states-france.csv europe-states-germany.csv europe-states-great-britain.csv europe-states-poland.csv europe-states-russia.csv north-america-canada-states.csv north-america-usa-states.csv"
state_input_files="north-america-usa-south-north-california.csv"
input_file_parent_dir="config-files/"
this_dir=$(pwd)

for f in $country_input_files
do
    this_file=$input_file_parent_dir$f
    INPUT=$(tail -n +2 $this_file)
    for i in $INPUT
    do
       geofabrik_file=$(echo $i | cut -d "," -f1)
       country_code=$(echo $i | cut -d "," -f2)
       country_name=$(echo $i | cut -d "," -f3)
       shp_download_dir=$this_dir/downloads/shp/$country_code/
       mkdir -p $shp_download_dir
       local_geo_file=$shp_download_dir$(basename $geofabrik_file)
       if [ ! -f $local_geo_file ]; then
            wget "$geofabrik_file" -P $shp_download_dir
       fi

    done
done


for f in $state_input_files
do
    this_file=$input_file_parent_dir$f
    INPUT=$(tail -n +2 $this_file)
    for i in $INPUT
    do
       geofabrik_file=$(echo $i | cut -d "," -f1)
       country_code=$(echo $i | cut -d "," -f2)
       country_name=$(echo $i | cut -d "," -f3)
       state_name=$(echo $i | cut -d "," -f4)
       state_code=$(echo $i | cut -d "," -f5)
       shp_download_dir=$this_dir/downloads/shp/$country_code/$state_code/
       mkdir -p $shp_download_dir
       local_geo_file=$shp_download_dir$(basename $geofabrik_file)
       if [ ! -f $local_geo_file ]; then
            wget "$geofabrik_file" -P $shp_download_dir
       fi

    done
done
