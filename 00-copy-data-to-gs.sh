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
upload_city_dir="gs://carto-storage/libs"

gsutil -m cp -r $city_dir $upload_city_dir

# city_dir="libs/city-boundary-files/ca"
# upload_city_dir="gs://carto-storage/libs/city-boundary-files/ca"

# gsutil -m cp -r $city_dir $upload_city_dir

#libs

lib_dir="libs/*"
upload_lib_dir="gs://carto-storage/libs"

gsutil -m cp -r $lib_dir $upload_lib_dir

# sizes

sz_dir="libs/sizes"
upload_sz_dir="gs://carto-storage/libs"

gsutil -m cp -r $sz_dir $upload_sz_dir

# colors

sz_dir="libs/color-schemas"
upload_sz_dir="gs://carto-storage/libs"

gsutil -m cp -r $sz_dir $upload_sz_dir

