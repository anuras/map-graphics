#!/usr/bin/python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser
import csv
from utilities import *
import time

parser = ArgumentParser()
parser.add_argument("-q", "--quiet",
                    action="store_false", dest="verbose", default=True,
                    help="don't print status messages to stdout")
parser.add_argument("-l", "--label",
                    action="store_false", dest="label", default=True,
                    help="Don't fade the label background on the map")

# parser.add_argument("-n", "--north", type=float, help="Bounding box north")
# parser.add_argument("-e", "--east", type=float, help="Bounding box east")
# parser.add_argument("-s", "--south", type=float, help="Bounding box south")
# parser.add_argument("-w", "--west", type=float, help="Bounding box west")
parser.add_argument("-w", "--width", type=int, help="Map width")
parser.add_argument("-t", "--height", type=int, help="Map height")

parser.add_argument("-d", "--directory", type=str, help="Mapnik xml input file directory")
parser.add_argument("-f", "--filename",  type=str, help="Mapnik xml input file name")
parser.add_argument("-s", "--schema", type=str, help="Color schema csv file")
parser.add_argument("-i", "--inputdata", type=str, help="Csv file with inputs")
parser.add_argument("-o", "--output", type=str, help="Output file name prefix")

if __name__ == "__main__":

    args = parser.parse_args()
    padding = int(args.width * 0.01)
    width_no_pad = args.width - padding - padding
    height_no_pad = args.height - padding - padding

    with open(args.schema) as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                data = {
                    'name': row['name'],
                    'background_color': row['background'],
                    'roads_color': row['road'],
                    'water_color': row['water'],
                    'text': row['text']
                    }
                xml_file = args.directory + "/" + row['name'] + "/" + args.filename
                mmap = loadMap(xml_file, width_no_pad, height_no_pad)

                start_time = time.time()
                with open(args.inputdata) as csvfile:
                    reader = csv.DictReader(csvfile)
                    for rrow in reader:
                        if ((rrow['north'] != rrow['south']) & (rrow['west'] != rrow['east'])):
                            print("Printing:" + rrow['name'].decode('utf-8'))
                            # ns, ew = heightLengthKm(float(rrow['west']), float(rrow['south']), float(rrow['east']), float(rrow['north']))
                            # if (ns >= ew): # assuming args.height > args.width
                            #     height = args.height
                            #     width = args.width
                            # else:
                            #     height = args.width
                            #     width = args.height
                            size_extension = str(argswidth) + "_" + str(args.height)
                            output_file = args.output + "/" + size_extension + "/" + row['name'] + "/" + rrow[''] + '_' + rrow['name'] + ".png"
                            output_file_labeled = args.output + "/" + size_extension + "/" + row['name'] + "/" + rrow[''] + '_' + rrow['name'] + "_labeled.png"
                            ensure_dir(output_file)
                            new_west, new_south, new_east, new_north = fitToSize(float(rrow['west']), float(rrow['south']), float(rrow['east']), float(rrow['north']), width_no_pad, height_no_pad)
                            renderBox(mmap, output_file, new_north, new_east, new_south, new_west)
                            add_label(output_file, rrow['name'].decode('utf-8').upper(), output_file, row['text'], row['background'], padding, args.label)
                        else:
                            print("Invalid coordinates, skipping:" + rrow['name'].decode('utf-8'))
                print("--- %s seconds elapsed for %s, %s (%s x %s)---" % (time.time() - start_time, args.directory, row['name'], str(args.width), str(args.height)))