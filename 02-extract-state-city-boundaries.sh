#!/bin/bash

geofabrik_file=$1
country_code=$2
state_name=$3
state_code=$4
city_boundary_dir=$(pwd)/osmnames/city-boundary-files/$country_code/$state_code/
city_boundary_file=$city_boundary_dir$state_code".tsv"
filter_cities=75

mkdir -p $city_boundary_dir

if [ ! -f $city_boundary_file ]; then
  echo "Extracting city data: "$city_boundary_file
  ./state-city-extract.sh $country_code $city_boundary_file "$state_name" $filter_cities
else
  echo "File found, skipping: "$city_boundary_file
fi
  