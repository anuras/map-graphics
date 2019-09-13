#!/bin/bash

geofabrik_file=$1
country_code=$2
city_boundary_dir=$(pwd)/osmnames/city-boundary-files/$country_code
city_boundary_file=$city_boundary_dir/$country_code".tsv"
filter_cities=75

mkdir -p $city_boundary_dir

if [ ! -f $city_boundary_file ]; then
  echo "Extracting city data: "$city_boundary_file
  ./country-city-extract.sh $country_code $city_boundary_file $filter_cities
else
  echo "File found, skipping: "$city_boundary_file
fi
  