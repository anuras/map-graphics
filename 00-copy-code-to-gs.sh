#!/bin/bash

gsutil -m cp * gs://carto-storage/workdir
gsutil -m cp color-schemas/* gs://carto-storage/workdir/color-schemas
gsutil -m cp config-files/* gs://carto-storage/workdir/config-files
gsutil -m cp xml_templates/* gs://carto-storage/workdir/xml_templates
## with regards to size these files are considered "code"
gsutil -m cp resources/* gs://carto-storage/workdir/resources
gsutil -m cp -r osmnames/city-boundary-files gs://carto-storage/workdir/osmnames
