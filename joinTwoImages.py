#!/usr/bin/python
# -*- coding: utf-8 -*-

from argparse import ArgumentParser
import csv
from utilities import *

parser = ArgumentParser()
parser.add_argument("-q", "--quiet",
                    action="store_false", dest="verbose", default=True,
                    help="don't print status messages to stdout")

parser.add_argument("-f", "--input_1",  type=str, help="First image")
parser.add_argument("-s", "--input_2", type=str, help="Second image")
parser.add_argument("-o", "--output", type=str, help="Output image")

if __name__ == "__main__":

    args = parser.parse_args()
    ensure_dir(args.output)
    join_images(args.input_1, args.input_2, args.output)