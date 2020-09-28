#!/bin/bash

geofabrik_file=$1
country_code=$2
map_width=$3
map_height=$4
country_code_2=$5
country_code_3=$6
this_dir=$(pwd)
shp_download_dir=$this_dir/input/geofiles/$country_code/
shp_download_dir_2=$this_dir/input/geofiles/$country_code_2/
shp_download_dir_3=$this_dir/input/geofiles/$country_code_3/
water_shapefile_dir=$this_dir/input/water-polygons/water-polygons-split-4326
input_template=$this_dir/xml_templates/render_template_w_sizing.xml
input_template_2=$this_dir/xml_templates/render_template_w_sizing_2_sources.xml
input_template_3=$this_dir/xml_templates/render_template_w_sizing_3_sources.xml
template_dir=$this_dir/xml_templates/generated_templates/$country_code
# color_schemas=$this_dir/color-schemas/staging-schemas.csv
color_schemas=$this_dir/color-schemas/staging-schemas2.csv
template_name="colored_template_"$map_width"_"$map_height".xml"

mkdir -p $template_dir

echo "Creating templates for "$country_code
python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template -d $template_dir -o $template_name -s $color_schemas -x $map_width


if [ -z "$country_code_2" ] && [ -z "$country_code_3" ]; then
  echo "Creating templates for "$country_code
  python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template -d $template_dir -o $template_name -s $color_schemas -x $map_width
fi
if [ ! -z "$country_code_2" ] && [ -z "$country_code_3" ]; then
  echo "Creating templates for "$country_code" and "$country_code_2
  python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template_2 -d $template_dir -o $template_name -s $color_schemas -x $map_width -e $shp_download_dir_2
fi
if [ ! -z "$country_code_2" ] && [ ! -z "$country_code_3" ]; then
  echo "Creating templates for "$country_code", "$country_code_2" and "$country_code_3
  python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template_3 -d $template_dir -o $template_name -s $color_schemas -x $map_width -e $shp_download_dir_2 -f $shp_download_dir_3
fi