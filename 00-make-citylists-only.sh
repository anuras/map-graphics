#!/bin/bash
set -x

country_input_files="europe-countries.csv"
state_input_files="europe-states-france.csv europe-states-germany.csv europe-states-great-britain.csv europe-states-poland.csv europe-states-russia.csv north-america-canada-states.csv north-america-usa-states.csv"
state_country_codes="us fr de gb pl ru ca"
state_country_codes="ca"
input_file_parent_dir="config-files/"
reference_file="config-files/reference-all-states.csv"
this_dir=$(pwd)
filter_cities_n=100

# for f in $country_input_files
# do
#     this_file=$input_file_parent_dir$f
#     INPUT=$(tail -n +2 $this_file)
    
#     for i in $INPUT
#     do
#        geofabrik_file=$(echo $i | cut -d "," -f1)
#        country_code=$(echo $i | cut -d "," -f2)
#        country_name=$(echo $i | cut -d "," -f3)
#        temp_file_name="temp/tempcsvextract_"$country_code".tsv"
#        city_boundary_dir=$this_dir/osmnames/city-boundary-files/$country_code
#        mkdir -p $city_boundary_dir
#        city_boundary_file=$city_boundary_dir/$country_code".tsv"
#        #filter_cities_n country specific?

#        if [ ! -f $city_boundary_file ]; then
#            if [ ! -f $temp_file_name ]; then
#                zcat osmnames/planet-latest_geonames.tsv.gz | awk -F '\t' -v OFS='\t' -v var="$country_code" 'NR == 1 || $16 == var' > $temp_file_name
#            fi
#            Rscript --vanilla city-boundaries.r --input $temp_file_name --output $city_boundary_file --top $filter_cities_n
#            rm $temp_file_name
#        fi
#     done
# done

filter_cities_n=200
for country_code in $state_country_codes
do
    temp_file_name="temp/tempcsvextract_"$country_code".tsv"
    prefilter_file="osmnames/filtered-cities/"$country_code"/"$country_code".csv"
    if [ ! -f $temp_file_name ]; then
           zcat osmnames/planet-latest_geonames.tsv.gz | awk -F '\t' -v OFS='\t' -v var="$country_code" 'NR == 1 || $16 == var' > $temp_file_name
    fi
    city_boundary_dir=$this_dir/osmnames/city-boundary-files/$country_code/
    mkdir -p $city_boundary_dir
    Rscript --vanilla city-boundaries-state.r --input $temp_file_name --output $city_boundary_dir --top $filter_cities_n --reference $reference_file --country_code $country_code --prefilter $prefilter_file
    rm $temp_file_name

done
