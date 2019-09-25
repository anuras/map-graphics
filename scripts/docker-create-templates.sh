#!/bin/bash

country_code=$1
version=$2

if [ -z "$country_code" ] && [ -z "$version" ]; then
    echo "Country code or version not provided, exiting."
    exit 1
fi

this_dir=$(pwd)
# cp {scripts/*.py,scripts/*.sh} ./
shape_dir=$this_dir"/input/geofiles/"$country_code
water_dir=$this_dir"/input/water-polygons/water-polygons-split-4326"
input_template=$this_dir/libs/xml_templates/render_template_w_sizing.xml
color_schemas=$this_dir/libs/color-schemas/$version/color-schemas.csv
size_file=$this_dir/libs/sizes/$version/sizes.csv
get_sizes=$(tail $size_file -n +2)
template_dir=$this_dir/input/templates/$country_code/$version/

for sizing in $get_sizes
do
    w=$(echo $sizing | cut -d"," -f1)
    h=$(echo $sizing | cut -d"," -f2)
    template_name="colored_template_"$w"_"$h".xml"

    echo "Width: "$w
    echo "Height: "$h
    python template_batch_creator.py -c $shape_dir -w $water_dir -i $input_template -d $template_dir -o $template_name -s $color_schemas -x $w
done
