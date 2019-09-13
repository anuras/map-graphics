#!/bin/bash

input=/home/arunas/maps/workdir/generated_maps/lt/1350_1050/Green-White/1_Vilnius.png
output=/home/arunas/maps/workdir/generated_maps/lt/dbl_1350_1050/Green-White/1_Vilnius.png
python joinTwoImages.py -f $input -s $input -o $output

input=/home/arunas/maps/workdir/generated_maps/lt/1350_1050/Accesible-beige/1_Vilnius.png
output=/home/arunas/maps/workdir/generated_maps/lt/dbl_1350_1050/Accesible-beige/1_Vilnius.png
python joinTwoImages.py -f $input -s $input -o $output