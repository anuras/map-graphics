#!/bin/bash

sudo docker build -f Templater.Dockerfile -t anuras/mapnik-templater .
sudo docker build -f Printer.Dockerfile -t anuras/mapnik-printer .