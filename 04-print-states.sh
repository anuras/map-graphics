#!/bin/bash

geofabrik_file=$1
country_code=$2
state_code=$3
map_width=$4
map_height=$5
this_dir=$(pwd)
template_dir=$this_dir/xml_templates/generated_templates/$country_code/$state_code/
template_name="colored_template_"$map_width"_"$map_height".xml"
color_schemas=$this_dir/color-schemas/staging-schemas2.csv
# color_schemas=$this_dir/color-schemas/production-schemas.csv
# color_schemas=$this_dir/color-schemas/$6
output_directory=$this_dir/output/$country_code/$state_code/
city_boundary_dir=$this_dir/osmnames/city-boundary-files/$country_code/$state_code/
city_boundary_file=$city_boundary_dir$state_code".tsv"

mkdir -p $output_directory
if [[ $(wc -l < $city_boundary_file) -ge 2 ]]
then
    echo "Printing maps for "$country_code", "$state_code
    python printer.py -d $template_dir -f $template_name -s $color_schemas -i $city_boundary_file -w $map_width -t $map_height -o $output_directory
else
    echo "Input file "$city_boundary_file" empty, skipping"
fi