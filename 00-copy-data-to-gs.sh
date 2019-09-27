#!/bin/bash

download_dir="downloads/"
upload_dir="gs://carto-storage/downloads/shapefiles"

gsutil -m cp -r -d $download_dir $upload_dir

# all_files=$(find $download_dir -type f -print)

# for f in $all_files
# do
#     gsutil cp $f $upload_dir
# done

# city boundary data
city_dir="libs/city-boundary-files"
upload_city_dir="gs://carto-storage/libs/city-boundary-files"

gsutil -m cp -r $city_dir $upload_city_dir

# sizes

sz_dir="libs/sizes"
upload_sz_dir="gs://carto-storage/libs/sizes"

gsutil -m cp -r $sz_dir $upload_sz_dir
