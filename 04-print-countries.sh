#!/bin/bash

geofabrik_file=$1
country_code=$2
map_width=$3
map_height=$4
this_dir=$(pwd)
city_boundary_dir=$this_dir/osmnames/city-boundary-files/$country_code
city_boundary_file=$city_boundary_dir/$country_code".tsv"
template_dir=$this_dir/xml_templates/generated_templates/$country_code
template_name="colored_template_"$map_width"_"$map_height".xml"
# color_schemas=$this_dir/color-schemas/staging-schemas.csv
color_schemas=$this_dir/color-schemas/production-schemas.csv
color_schemas=$this_dir/color-schemas/$5
output_directory=$this_dir/generated_maps/$country_code/

mkdir -p $output_directory

if [[ $(wc -l < $city_boundary_file) -ge 2 ]]
then
    echo "Printing maps for "$country_code
    python printer.py -d $template_dir -f $template_name -s $color_schemas -i $city_boundary_file -w $map_width -t $map_height -o $output_directory   
else
    echo "Input file "$city_boundary_file" empty, skipping"
fi
