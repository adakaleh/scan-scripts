#!/bin/sh

# go to the directory where this script is located
cd "$(dirname "$0")"

# include the config file
. ./config.sh

if [ ! -d "img/orig" ]; then
  echo 'img/orig directory not present. Use scan.sh first.'
  exit
fi

# make required directories
mkdir img/ocr
mkdir text-raw

# get rotation argument for unpaper
if [ $rotate -eq 90 ]; then
  rotation='--pre-rotate 90'
elif [ $rotate -eq 180 ]; then
  rotation='--pre-mirror v,h'
elif [ $rotate -eq 270 ]; then
  rotation='--pre-rotate -90'
else
  rotation=''
fi

# convert images
cd img
for f in orig/*; do
  # Get page number from file name
  i=$(echo "$f" | tr -d orig/ | tr -d .pnm)
  echo "preparing page $i"
  unpaper $rotation "orig/$i.pnm" "ocr/unpapered-$i.pnm"
  convert "ocr/unpapered-$i.pnm" "ocr/prepared-$i.tif"
  rm "ocr/unpapered-$i.pnm"
done
cd ..

# OCR
for f in img/ocr/*; do
  # Get page number from file name
  i=$(echo "$f" | tr -d img/ocr/prepared- | tr -d .tif)
  echo "doing OCR on page $i"
  tesseract -l "$language" "img/ocr/prepared-$i.tif" "text-raw/page-$i"
done
