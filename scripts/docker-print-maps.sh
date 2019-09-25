#!/bin/bash

country_code=$1
version=$2

if [ -z "$country_code" ] && [ -z "$version" ]; then
    echo "Country code or version not provided, exiting."
    exit 1
fi

this_dir=$(pwd)
# cp {scripts/*.py,scripts/*.sh} ./
color_schemas=$this_dir/libs/color-schemas/$version/color-schemas.csv
size_file=$this_dir/libs/sizes/$version/sizes.csv
get_sizes=$(tail $size_file -n +2)
template_dir=$this_dir/input/templates/$country_code/$version/
city_boundary_file=$this_dir/libs/city-boundary-files/$country_code/$version/"cities.tsv"
output_directory=$this_dir/output/$country_code/$version/

for sizing in $get_sizes
do
    w=$(echo $sizing | cut -d"," -f1)
    h=$(echo $sizing | cut -d"," -f2)
    template_name="colored_template_"$w"_"$h".xml"

    echo "Printing maps: "$w"x"$h
    python printer.py -d $template_dir -f $template_name -s $color_schemas -i $city_boundary_file -w $w -t $h -o $output_directory
done
