#!/bin/sh

# get device: `scanimage -L`
device='genesys:libusb:001:004'

# get mode: `scanimage --help --device yourdevice`
mode='Color' # ex: Color|Gray|Lineart

first_page=1 # can be a negative number, if needed
last_page=100

width=210 # millimeters
length=297 # millimeters

resolution=300 # dpi

rotate=0 # clockwise: 0, 90, 180 or 270

language='eng' # eng, ron, etc (see README)

compressed_image_format='jpg' # 'jpg', 'png', ''

# https://imagemagick.org/script/command-line-options.php#quality
if [ "$compressed_image_format" = 'jpg' ]; then
  compressed_image_quality=75 # 75 = 16:1 compression
elif [ "$compressed_image_format" = 'png' ]; then
  compressed_image_quality=8 # 8 = best compression
fi
