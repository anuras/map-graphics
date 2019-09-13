#!/bin/bash

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
input_data_file=$1
INPUT=$(tail -n +2 $input_data_file)

for i in $INPUT
do
   geofabrik_file=$(echo $i | cut -d "," -f1)
   country_code=$(echo $i | cut -d "," -f2)
   country_name=$(echo $i | cut -d "," -f3)
   state_name=$(echo $i | cut -d "," -f4)
   state_code=$(echo $i | cut -d "," -f5)
   
   # echo $geofabrik_file $country_code $country_name \"$state_name\" $state_code
   ./extract-state-city-boundaries.sh $geofabrik_file $country_code $country_name \"$state_name\" $state_code
done
