#!/usr/bin/python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser
import csv
from utilities import ensure_dir

parser = ArgumentParser()
parser.add_argument("-c", "--country_dir", help="Directory to the country shape files")
parser.add_argument("-e", "--country_dir2", help="Second directory to the country shape files", default = "")
parser.add_argument("-f", "--country_dir3", help="Third directory to the country shape files", default = "")
parser.add_argument("-w", "--water_dir", help="Directory to water shape files")

parser.add_argument("-s", "--schema", help="Color schema csv file")

parser.add_argument("-i", "--input_file", help="Input empty template file")
parser.add_argument("-d", "--output_dir",  help="Output template dir")
parser.add_argument("-o", "--output_file", help="Output template file name")
parser.add_argument("-x", "--map_width", type=int, help="Map width, used as a stroke width modifier")

parser.add_argument("-q", "--quiet",
                    action="store_false", dest="verbose", default=True,
                    help="don't print status messages to stdout")

if __name__ == "__main__":

    args = parser.parse_args()

    with open(args.schema) as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            replacements = {
                '[geofabrik_country_dir]': args.country_dir, 
                '[geofabrik_country_dir_2]': args.country_dir2, 
                '[geofabrik_country_dir_3]': args.country_dir3, 
                '[water_polygons_dir]': args.water_dir, 
                '[background_color]': row['background'],
                '[roads_color]': row['road'],
                '[rail_color]': row['road'],
                '[water_color]': row['water'],
                '[size0.1]': str(round(0.1 * (args.map_width / 800.0), 2)),
                '[size0.2]': str(round(0.2 * (args.map_width / 800.0), 2)),
                '[size0.3]': str(round(0.3 * (args.map_width / 800.0), 2)),
                '[size0.4]': str(round(0.4 * (args.map_width / 800.0), 2)),
                '[size0.45]': str(round(0.45 * (args.map_width / 800.0), 2)),
                '[size0.7]': str(round(0.7 * (args.map_width / 800.0), 2))
                }

            output_file = args.output_dir + "/" + row['name'] + "/" + args.output_file
            ensure_dir(output_file)
            with open(args.input_file) as infile, open(output_file, 'w') as outfile:
                for line in infile:
                    for src, target in replacements.iteritems():
                        # print(src, target)
                        line = line.replace(src, target)
                    outfile.write(line)