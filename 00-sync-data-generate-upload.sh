#!/bin/bash

gsurl="gs://carto-storage/"
gsshpurl="gs://carto-storage/downloads/shapefiles/shp"
localinput="input"

# 0. take in config params
country="lt"
# 1. sync city data
# 2. sync shapefile data & extract
gscountryurl=$gsshpurl/$country
localcntrdir=$localinput/$country
mkdir $localcntrdir
gsutil -m rsync -d -r $gscountryurl $localcntrdir
#unzip files

# 3. generate
docker run 
# 4. upload generated maps