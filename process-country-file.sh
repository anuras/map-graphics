#!/bin/bash

geofabrik_file=$1
country_code=$2
country_name=$3
lcase_country_name=$(echo "$country_name" | tr '[:upper:]' '[:lower:]')
this_dir=$(pwd)
shp_download_dir=$this_dir/downloads/shp/$country_code/
city_boundary_dir=$this_dir/osmnames/city-boundary-files/$country_code
city_boundary_file=$city_boundary_dir/$lcase_country_name".tsv"
water_shapefile_dir=$this_dir/downloads/water-polygons/water-polygons-split-4326
input_template=xml_templates/render_template.xml
template_dir=xml_templates/generated_templates/$country_code
template_name=colored_template.xml
color_schemas=color-schemas/production-schemas.csv
map_width=800
map_height=800
output_directory=generated_maps/$country_code/
filter_cities=10

mkdir -p $shp_download_dir
mkdir -p $city_boundary_dir
mkdir -p $template_dir
mkdir -p $output_directory

local_geo_file=$shp_download_dir$(basename $geofabrik_file)

if [ ! -f $local_geo_file ]; then
    echo "File not found! Downloading."
    wget $geofabrik_file  -P $shp_download_dir
fi
unzip -n $local_geo_file -d $shp_download_dir
if [ ! -f $city_boundary_file ]; then
    echo "Extracting city data"
    ./country-city-extract.sh $country_code $city_boundary_file $filter_cities
fi
# add template check (separate template creation)
echo "Creating templates for "$country_name
python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template -d $template_dir -o $template_name -s $color_schemas
echo "Printing maps for "$country_name
echo "30x40cm"
python printer.py -d $template_dir -f $template_name -s $color_schemas -i $city_boundary_file -w 3543 -t 4724 -o $output_directory
echo "50x70cm"
python printer.py -d $template_dir -f $template_name -s $color_schemas -i $city_boundary_file -w 5906 -t 8268 -o $output_directory
echo "61x91cm"
python printer.py -d $template_dir -f $template_name -s $color_schemas -i $city_boundary_file -w 7205 -t 10748 -o $output_directory
echo "70x100cm"
python printer.py -d $template_dir -f $template_name -s $color_schemas -i $city_boundary_file -w 8268 -t 11811 -o $output_directory
