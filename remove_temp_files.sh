#!/bin/bash

tmp_files=$(ls temp/)
for f in $tmp_files
do
    rm temp/$f
done