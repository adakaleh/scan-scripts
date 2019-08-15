#!/bin/sh

# go to the directory where this script is located
cd `dirname "$0"`

# include the config file
. ./config.sh

# make required directories
mkdir -p img/orig
if [ -n "$compressed_image_format" ]; then
  mkdir img/compressed
fi

cd img/orig

echo
echo Press Enter to scan the current page
echo Enter a letter to go to the previous page
echo Enter a number to go to the specified page
echo

i=$first_page
while [ $i -le $last_page ]; do

  echo "Prepare page $i and press Enter"
  read input
  # if $input is a number
  if [ "$input" -eq "$input" 2>/dev/null ]; then
    # go to specified page
    i=$input
    continue
  # else if $input is set
  elif [ ! -z "$input" ]; then
    # repeat the previous page
    i=`expr $i - 1`
    continue
  fi
  page=`printf %03.f $i`

  scanimage --device $device --mode $mode --progress --format=pnm --resolution $resolution -x $width -y $length > $page.pnm

  # compress image
  if [ -n "$compressed_image_format" ]; then
    if [ -n "$compressed_image_quality" ]; then
      quality="-quality $compressed_image_quality"
    fi
    if [ -n "$rotate" ]; then
      rotate="-rotate $rotate"
    fi
    convert $quality $rotate $page.pnm ../compressed/$page.$compressed_image_format
  fi

  i=`expr $i + 1`
done
