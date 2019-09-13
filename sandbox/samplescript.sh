#!/bin/bash

echo $1
if [ -z "$2" ]; then
  echo "second argument is empty"
fi
if [ -z "$2" ] && [ -z "$3" ]; then
  echo "second and third arguments are empty"
fi
if [ -z "$2" ] || [ -z "$3" ]; then
  echo "second or third arguments are empty"
fi

if [ ! -z "$2" ] && [ -z "$3" ]; then
  echo "second arguments is not empty but third is"
fi