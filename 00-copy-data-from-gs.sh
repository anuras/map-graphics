#!/bin/bash

gsutil -m cp -r gs://carto-storage/downloads/shapefiles/ downloads/
gsutil -m cp -r gs://carto-storage/downloads/water-polygons/* downloads/water-polygons/