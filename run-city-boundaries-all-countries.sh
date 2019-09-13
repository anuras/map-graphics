#!/bin/bash

input_data_file=$1
INPUT=$(tail -n +2 $input_data_file)

for i in $INPUT
do
   geofabrik_file=$(echo $i | cut -d "," -f1)
   country_code=$(echo $i | cut -d "," -f2)
   country_name=$(echo $i | cut -d "," -f3)
   
   ./extract-country-city-boundaries.sh $geofabrik_file $country_code $country_name
done
