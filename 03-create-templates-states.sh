#!/bin/bash

geofabrik_file=$1
country_code=$2
state_code=$3
map_width=$4
map_height=$5
country_code_2=$6
state_code_2=$7
country_code_3=$8
state_code_3=$9
this_dir=$(pwd)
shp_download_dir=$this_dir/downloads/shp/$country_code/$state_code/
shp_download_dir_2=$this_dir/downloads/shp/$country_code_2/$state_code_2/
shp_download_dir_3=$this_dir/downloads/shp/$country_code_3/$state_code_3/
water_shapefile_dir=$this_dir//downloads/water-polygons/water-polygons-split-4326
input_template=$this_dir/xml_templates/render_template_w_sizing.xml
input_template_2=$this_dir/xml_templates/render_template_w_sizing_2_sources.xml
input_template_3=$this_dir/xml_templates/render_template_w_sizing_3_sources.xml
template_dir=$this_dir/xml_templates/generated_templates/$country_code/$state_code/
color_schemas=$this_dir/color-schemas/staging-schemas2.csv
# color_schemas=$this_dir/color-schemas/production-schemas.csv
# color_schemas=$this_dir"/color-schemas/"${10}
template_name="colored_template_"$map_width"_"$map_height".xml"

mkdir -p $template_dir

if [ -z "$state_code_2" ] && [ -z "$state_code_3" ]; then
  echo "Creating templates for "$state_code
  python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template -d $template_dir -o $template_name -s $color_schemas -x $map_width
fi
if [ ! -z "$state_code_2" ] && [ -z "$state_code_3" ]; then
  echo "Creating templates for "$state_code" and "$state_code_2
  python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template_2 -d $template_dir -o $template_name -s $color_schemas -x $map_width -e $shp_download_dir_2
fi
if [ ! -z "$state_code_2" ] && [ ! -z "$state_code_3" ]; then
  echo "Creating templates for "$state_code", "$state_code_2" and "$state_code_3
  python template_batch_creator.py -c $shp_download_dir -w $water_shapefile_dir -i $input_template_3 -d $template_dir -o $template_name -s $color_schemas -x $map_width -e $shp_download_dir_2 -f $shp_download_dir_3
fi