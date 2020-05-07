# Scan & OCR scripts

This is a very productive scanning and OCR setup, intended to speed up the scanning process and produce a CBZ file and an archive of extracted text as fast as possible. Just follow these steps:

1. install the [required packages](#required-packages)
2. plug in your scanner
3. edit `config.sh` according to your needs (see [Usage](#usage))
4. run `./1-scan.sh`
5. run `./2-ocr.sh`
6. run `./3-bundle.sh`

This setup was inspired by [How to scan and OCR like a pro with open source tools](https://www.linux.com/learn/how-scan-and-ocr-pro-open-source-tools). The article also explains a few things not included in these scripts, like how to remove page numbers and unnecessary line feeds. Add these parts in if you need to.

## Required packages

In Debian:

`sudo apt install sane sane-utils imagemagick unpaper tesseract-ocr`

Also, install the Tesseract language package(s) you need. Select from:

* `apt search tesseract-ocr-`
* https://packages.debian.org/search?keywords=tesseract-ocr-

If you have an old version of Debian, install the newer Tesseract language package(s) from [backports](https://backports.debian.org/Instructions/). Example (for Debian 9): add `deb https://deb.debian.org/debian stretch-backports main` to `/etc/apt/sources.list`, then run:

`sudo apt -t stretch-backports install tesseract-ocr-eng`

## Usage

Before using the scripts, you must edit `config.sh` according to your needs. You need to change at least the following options:

1. `device`: run `scanimage -L` to find the device id. Ex: `device='genesys:libusb:001:004'`.
2. `width` and `height`: measure the pages' width and height in millimeters. Images will be cropped to this size automatically.
3. `first_page` and `last_page`. `first_page` can be a negative number, if needed (see below).

### Naming convention

For clarity, we want file names to match page numbers: `001.pnm` for page 1, etc. As for the unnumbered pages (covers, inserts, folds, etc), we must name them in a way that preserves page order. This is especially important when generating CBZ files, in which page order is determined by file names. We have two main situations:

1. The cover and first few pages might not be numbered. In this case, set `first_page` to a negative number. Before reaching page 1, files will be named `000_1.pnm`, `000_2.pnm`, etc.
2. In case of other unnumbered pages (inserts, folds, etc), skip them on the first run and scan them separately, using the command `./1-scan.sh filename_without_extension`. For ordering to be consistent, name the files as in the following examples:
    - If there is an insert between pages 45 and 46, use this convention: `045_0.pnm, 045_1.pnm, 045_2.pnm, 046.pnm`. So after the first run, rename `045.pnm` to `045_0.pnm`, then scan the insert by running `./1-scan.sh 045_1` and `./1-scan.sh 045_2`.
    - If leaf 45/46 is folded and actually contains 4 pages, use this convention: `045_1.pnm, 045_2.pnm, 046_1.pnm, 046_2.pnm`. So after the first run, rename `045.pnm` to `045_1.pnm` and `046.pnm` to `046_1.pnm`, then scan the extra pages in the fold by running `./1-scan.sh 045_2` and `./1-scan.sh 046_2`.
    - If leaf -1/0 (the front cover) is folded and actually contains 4 pages, use this convention: `000_1_1.pnm, 000_1_2.pnm, 000_2_1.pnm, 000_2_2.pnm`. So after the first run, rename `000_1.pnm` to `000_1_1.pnm` and `000_2.pnm` to `000_2_1.pnm`, then scan the extra pages in the fold by running `./1-scan.sh 000_1_2` and `./1-scan.sh 000_2_2`.

**Important**: you must do all renaming before running `./2-ocr.sh`!
