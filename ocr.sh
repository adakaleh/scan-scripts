#!/bin/sh

# go to the directory where this script is located
cd `dirname "$0"`

# include the config file
. ./config.sh

if [ ! -d "img/orig" ]; then
  echo 'img/orig directory not present. Use scan.sh first.'
  exit
fi

# make required directories
mkdir img/ocr
mkdir text

# get rotation argument for unpaper
if [ $rotate -eq 90 ]; then
  rotate='--pre-rotate 90'
elif [ $rotate -eq 180 ]; then
  rotate='--pre-mirror v,h'
elif [ $rotate -eq 270 ]; then
  rotate='--pre-rotate -90'
else
  rotate=''
fi

# convert images
cd img
for i in `seq --format=%03.f $first_page $last_page`; do
  echo preparing page $i
  unpaper $rotate orig/$i.pnm ocr/unpapered-$i.pnm
  convert ocr/unpapered-$i.pnm ocr/prepared-$i.tif
  rm ocr/unpapered-$i.pnm
done
cd ..

# OCR
for i in `seq --format=%03.f $first_page $last_page`; do
  echo doing OCR on page $i
  tesseract -l $language img/ocr/prepared-$i.tif text/page-$i
done

# merge text files
cat text/page-*.txt > text/complete.txt
