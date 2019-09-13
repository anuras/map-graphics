#!/bin/bash

gsutil -m cp gs://carto-storage/workdir/* ./
gsutil -m cp gs://carto-storage/workdir/color-schemas/* color-schemas/
gsutil -m cp gs://carto-storage/workdir/config-files/* config-files/
gsutil -m cp gs://carto-storage/workdir/xml_templates/* xml_templates/ 
## with regards to size these files are considered "code"
gsutil -m cp gs://carto-storage/workdir/resources/* resources/
gsutil -m cp -r gs://carto-storage/workdir/osmnames/city-boundary-files osmnames