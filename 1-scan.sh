#!/bin/sh

# go to the directory where this script is located
cd "$(dirname "$0")"

# include the config file
. ./config.sh

# make required directories
mkdir -p img/orig

cd img/orig || exit

# scan filename can be supplied as an argument
if [ ! -z "$1" ]; then
  scanimage --device "$device" --mode "$mode" --progress --format=pnm --resolution $resolution -x $width -y $length > "$1.pnm"
  exit
fi

echo
echo Press Enter to scan the current page
echo Enter a letter to go to the previous page
echo Enter a number to go to the specified page
echo

i=$first_page
while [ $i -le $last_page ]; do

  echo "Prepare page $i and press Enter"
  read -r input
  # if $input is a number
  if [ "$input" -eq "$input" 2>/dev/null ]; then
    # go to specified page
    i=$input
    continue
  # else if $input is set
  elif [ ! -z "$input" ]; then
    # repeat the previous page
    i=$((i - 1))
    continue
  fi

  if [ $i -lt 1 ]; then
    # -3 -> 000_1
    # -2 -> 000_2
    # -1 -> 000_3
    #  0 -> 000_4
    page=$((-first_page + 1 + i))
    page="000_$page"
  else
    #  1 -> 001
    page=$(printf %03.f $i)
  fi

  scanimage --device "$device" --mode "$mode" --progress --format=pnm --resolution $resolution -x $width -y $length > "$page.pnm"

  i=$((i + 1))
done
