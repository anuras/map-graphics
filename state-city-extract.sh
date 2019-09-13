#!/bin/bash

country_code=$1
output_file=$2
state_name=$3
filter_cities_n=$4
temp_file_name="temp/tempcsvextract_"$country_code".tsv"

echo "Running extract with arguments:"
echo $country_code
echo $output_file
echo $state_name
echo $filter_cities_n
#extract by country
# zcat osmnames/planet-latest_geonames.tsv.gz | awk -F '\t' -v OFS='\t' 'NR == 1 || $16 == "ENVIRON["country_code"]"' > $temp_file_name
# zcat osmnames/planet-latest_geonames.tsv.gz | awk -F $'\t' -v country_code=$country_code 'BEGIN {OFS = FS}{if (NR!=1) {  if ($16 =="country_code")  { print}    } else {print}}' > $temp_file_name
if [ ! -f $temp_file_name ]; then
    zcat osmnames/planet-latest_geonames.tsv.gz | awk -F '\t' -v OFS='\t' -v var="$country_code" 'NR == 1 || $16 == var' > $temp_file_name
fi

Rscript --vanilla city-boundaries.r --input $temp_file_name --output $output_file --state "$state_name" --top $filter_cities_n

#extract by country 2
# awk -F $'\t' -v country_code=$country_code 'BEGIN {OFS = FS}{if (NR!=1) {  if ($16 =="country_code")  { print}    } else {print}}' planet-latest.tsv > countryExtract.tsv

#extract by bounding box
#zcat planet-latest.tsv.gz | awk -F '\t' -v OFS='\t' 'NR == 1 || ($8 > 47.225 && $8 < 47.533 && $7 > 8.275 && $7 < 8.800)' > zurich_switzerland.tsv
