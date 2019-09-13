#!/usr/bin/python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("-c", "--country_dir", help="Directory to the country shape files")
parser.add_argument("-w", "--water_dir", help="Directory to water shape files")

parser.add_argument("-b", "--background", help="Background color")
parser.add_argument("-r", "--roads", help="Road color")
parser.add_argument("-f", "--fill_water", help="Water fill color")

parser.add_argument("-i", "--input_file", help="Input empty template file")
parser.add_argument("-o", "--output_file", help="Output template file")

parser.add_argument("-q", "--quiet",
                    action="store_false", dest="verbose", default=True,
                    help="don't print status messages to stdout")

if __name__ == "__main__":

    args = parser.parse_args()
    replacements = {
        '[geofabrik_country_dir]': args.country_dir, 
        '[water_polygons_dir]': args.water_dir, 
        '[background_color]': args.background,
        '[roads_color]': args.roads,
        '[water_color]': args.fill_water
        }

    with open(args.input_file) as infile, open(args.output_file, 'w') as outfile:
        for line in infile:
            for src, target in replacements.iteritems():
                # print(src, target)
                line = line.replace(src, target)
            outfile.write(line)