#!/bin/bash

download_dir="downloads/"
upload_dir="gs://carto-storage/downloads/shapefiles"

gsutil -m cp -r -d $download_dir $upload_dir

# all_files=$(find $download_dir -type f -print)

# for f in $all_files
# do
#     gsutil cp $f $upload_dir
# done