#!/bin/bash

IFS=$'\n'       # make newlines the only separator
set -f          # disable globbing
input_data_file=$1
INPUT=$(tail -n +2 $input_data_file)
start=$(date +'%s')
color_schemas=staging-schemas2.csv

for i in $INPUT
do
   geofabrik_file=$(echo $i | cut -d "," -f1)
   country_code=$(echo $i | cut -d "," -f2)
   country_name=$(echo $i | cut -d "," -f3)
   state_name=$(echo $i | cut -d "," -f4)
   state_code=$(echo $i | cut -d "," -f5)
   country_code_2=$(echo $i | cut -d "," -f7)
   state_code_2=$(echo $i | cut -d "," -f10)
   country_code_3=$(echo $i | cut -d "," -f12)
   state_code_3=$(echo $i | cut -d "," -f15)
   
   echo $geofabrik_file $country_code $country_name \"$state_name\" $state_code
   # ./process-state-file.sh $geofabrik_file $country_code $country_name \"$state_name\" $state_code
   # ./01-download-files-states.sh $geofabrik_file $country_code $state_code
   # ./02-extract-state-city-boundaries.sh $geofabrik_file $country_code "$state_name" $state_code
   # ./03-create-templates-states.sh $geofabrik_file $country_code $state_code 1350 1050 $country_code_2 $state_code_2 $country_code_3 $state_code_3
   # ./04-print-states.sh $geofabrik_file $country_code $state_code 1350 1050
   # ./03-create-templates-states.sh $geofabrik_file $country_code $state_code 2700 1050 $country_code_2 $state_code_2 $country_code_3 $state_code_3
   # ./04-print-states.sh $geofabrik_file $country_code $state_code 2700 1050
   ./03-create-templates-states.sh $geofabrik_file $country_code $state_code 3543 4724 $country_code_2 $state_code_2 $country_code_3 $state_code_3 $color_schemas
   ./04-print-states.sh $geofabrik_file $country_code $state_code 3543 4724 $color_schemas
   # ./03-create-templates-states.sh $geofabrik_file $country_code $state_code 5906 8268 $country_code_2 $state_code_2 $country_code_3 $state_code_3
   # ./04-print-states.sh $geofabrik_file $country_code $state_code 5906 8268
   # ./03-create-templates-states.sh $geofabrik_file $country_code $state_code 7205 10748 $country_code_2 $state_code_2 $country_code_3 $state_code_3
   # ./04-print-states.sh $geofabrik_file $country_code $state_code 7205 10748
   # ./03-create-templates-states.sh $geofabrik_file $country_code $state_code 8268 11811 $country_code_2 $state_code_2 $country_code_3 $state_code_3
   # ./04-print-states.sh $geofabrik_file $country_code $state_code 8268 11811

done
./remove_temp_files.sh

echo "Took $(($(date +'%s') - $start)) seconds"
