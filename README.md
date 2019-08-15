# Scan & OCR scripts

This very productive setup was inspired by [How to scan and OCR like a pro with open source tools](https://www.linux.com/learn/how-scan-and-ocr-pro-open-source-tools). The article also explains a few things not included in these scripts, like how to remove page numbers and unnecessary line feeds. Add these parts in if you need to.

Before using the scripts, measure the pages' width and height and change `config.sh` according to your needs.

## Required packages

In Debian:

`sudo apt install sane sane-utils imagemagick unpaper tesseract-ocr`

Also, install the Tesseract language package(s) you need. Select from:

* `apt search tesseract-ocr-`
* https://packages.debian.org/search?keywords=tesseract-ocr-

If you have an old version of Debian, install the newer Tesseract language package(s) from [backports](https://backports.debian.org/Instructions/). Example (for Debian 9): add `deb https://deb.debian.org/debian stretch-backports main` to `/etc/apt/sources.list`, then run:

`sudo apt -t stretch-backports install tesseract-ocr-eng`
