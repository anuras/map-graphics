#!/bin/bash

gsurl="gs://carto-storage/"
gsshpurl="gs://carto-storage/downloads/shapefiles/shp"
localinput="input/geofiles"
gswaterurl="gs://carto-storage/downloads/water-polygons"
localwater="input/water-polygons"

# 0a take in config params
country="lt"
country="ca/bc"
version="v1"
country=$1
version=$2
sync="off"

# 0b sync libs

gsliburl="gs://carto-storage/libs"
locallibdir="libs"
mkdir -p $locallibdir
if [[ $sync == "on" ]]
then
    gsutil -m rsync -d -r $gsliburl $locallibdir
fi

# 1. sync city data
gscityurl="gs://carto-storage/libs/city-boundary-files/"$country
localcitydir="libs/city-boundary-files/"$country

gsutil -m rsync -d -r $gscityurl $localcitydir

# 2a sync shapefile data & extract
gscountryurl=$gsshpurl/$country
localcntrdir=$localinput/$country
mkdir -p $localcntrdir
if [[ $sync == "on" ]]
then
    gsutil -m rsync -d -r $gscountryurl $localcntrdir
    unzip $localcntrdir/* -d $localcntrdir/
fi

# 2b sync water polygon files
mkdir $localwater
if [[ $sync == "on" ]]
then
    gsutil -m rsync -d -r $gswaterurl $localwater
fi

# 3. generate templates
this_dir=$(pwd)
# docker run -v $this_dir/input/:/wdir/input/:rw -v $this_dir/libs/:/wdir/libs/:rw -v $this_dir/input/docker-create-templates.sh:/wdir/input/docker-create-templates.sh -w /wdir/ --entrypoint "/bin/bash /wdir/docker-create-templates.sh $country $version" anuras/mapnik
# docker run -ti -v $this_dir/input/:/wdir/input/:rw -v $this_dir/libs/:/wdir/libs/:rw -v $this_dir/scripts/:/wdir/scripts/ -w /wdir/ anuras/mapnik /bin/bash
# cp scripts/*.* ./
# /bin/bash docker-create-templates.sh $country $version
docker run -v $this_dir/input/:/wdir/input/:rw -v $this_dir/libs/:/wdir/libs/:rw -v $this_dir/scripts/:/wdir/scripts/ -w /wdir/ anuras/mapnik-templater $country $version

#finish

# 4. generate maps
# docker run -ti -v $this_dir/input/:/wdir/input/:rw -v $this_dir/output/:/wdir/output/:rw -v $this_dir/libs/:/wdir/libs/:rw -v $this_dir/scripts/:/wdir/scripts/ -v $this_dir/libs/resources/:/wdir/resources/ -w /wdir/ anuras/mapnik /bin/bash
# cp scripts/*.* ./
# /bin/bash docker-print-maps.sh lt v1
# /bin/bash docker-print-maps.sh $country $version
# docker run -v $this_dir/input/:/wdir/input/:rw -v $this_dir/output/:/wdir/output/:rw -v $this_dir/libs/:/wdir/libs/:rw -v $this_dir/scripts/:/wdir/scripts/ -v $this_dir/libs/resources/:/wdir/resources/ -w /wdir/ anuras/mapnik /bin/bash docker-print-maps.sh $country $version
# sudo docker run -v $this_dir/input/:/wdir/input/:rw -v $this_dir/output/:/wdir/output/:rw -v $this_dir/libs/:/wdir/libs/:rw -v $this_dir/scripts/:/wdir/scripts/ -v $this_dir/libs/resources/:/wdir/resources/ -w /wdir/ anuras/mapnik cp {scripts/*.py,scripts/*.sh} ./ && docker-print-maps.sh $country $version
docker run -v $this_dir/input/:/wdir/input/:rw -v $this_dir/output/:/wdir/output/:rw -v $this_dir/libs/:/wdir/libs/:rw -v $this_dir/scripts/:/wdir/scripts/ -v $this_dir/libs/resources/:/wdir/resources/ -w /wdir/ anuras/mapnik-printer $country $version


# 5. upload generated maps
output_directory=$this_dir/output/$country/$version
gs_output_dir="gs://carto-storage/output/"$country/$version/
if [[ $sync == "on" ]]
then
    gsutil -m cp -r $output_directory/* $gs_output_dir
fi