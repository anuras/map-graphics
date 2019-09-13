#!/bin/bash

input_data_file=$1
INPUT=$(tail -n +2 $input_data_file)
color_schemas=staging-schemas2.csv

for i in $INPUT
do
   geofabrik_file=$(echo $i | cut -d "," -f1)
   country_code=$(echo $i | cut -d "," -f2)
   country_name=$(echo $i | cut -d "," -f3)
   
   # ./process-country-file.sh $geofabrik_file $country_code $country_name
   echo $geofabrik_file $country_code

   ./01-download-files-countries.sh $geofabrik_file $country_code
   ./02-extract-country-city-boundaries.sh $geofabrik_file $country_code
   # ./03-create-templates-countries.sh $geofabrik_file $country_code 1350 1050
   # ./04-print-countries.sh $geofabrik_file $country_code 1350 1050
   # ./03-create-templates-countries.sh $geofabrik_file $country_code 2700 1050
   # ./04-print-countries.sh $geofabrik_file $country_code 2700 1050
   ./03-create-templates-countries.sh $geofabrik_file $country_code 3543 4724 $color_schemas
   ./04-print-countries.sh $geofabrik_file $country_code 3543 4724 $color_schemas
   # ./03-create-templates-countries.sh $geofabrik_file $country_code 5906 8268
   # ./04-print-countries.sh $geofabrik_file $country_code 5906 8268
   # ./03-create-templates-countries.sh $geofabrik_file $country_code 7205 10748
   # ./04-print-countries.sh $geofabrik_file $country_code 7205 10748
   # ./03-create-templates-countries.sh $geofabrik_file $country_code 8268 11811
   # ./04-print-countries.sh $geofabrik_file $country_code 8268 11811

done

./remove_temp_files.sh