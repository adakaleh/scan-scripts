#!/bin/sh

# Generate CBZ file and do OCR cleanup
# Resulting files:
# - text/
# - <current_directory_name> + .cbz
# - <current_directory_name>_text + .zip

# go to the directory where this script is located
cd "$(dirname "$0")"

# include the config file
. ./config.sh

# Get current directory name
basename="$(basename "$PWD")"

# Compress images
if [ -d img/orig ]; then
  if [ -n "$compressed_image_format" ]; then
    echo Compressing images...
    mkdir img/compressed
    if [ -n "$compressed_image_quality" ]; then
      quality="-quality $compressed_image_quality"
    fi
    if [ ! $rotate -eq 0 ]; then
      rotation="-rotate $rotate"
    fi
    for f in img/orig/*; do
      page=$(echo "$f" | tr -d img/orig/ | tr -d .pnm)
      convert $quality $rotation "img/orig/$page.pnm" "img/compressed/$page.$compressed_image_format"
    done
  fi
fi

# Make CBZ file
if [ -d img/compressed ]; then
  echo CBZ-ing...
  cd img/compressed
  zip -q -0 "../../$basename.cbz" ./*
  cd ../..
fi

# Clean and merge text files
if [ -d text-raw ]; then
  echo Handling text...
  cp -r text-raw text
  cd text

  for f in page-*; do
    # remove blank spaces from beginning and end of each page
    # we use Python here, for its handy strip() function
    # TODO: maybe loop through files inside python instead of invoking it multiple times
    #  - https://stackoverflow.com/questions/11968976/list-files-only-in-the-current-directory
    python3 -c "fi = open('${f}', 'r')
text = fi.read().strip()
fi.close()
fo = open('${f}', 'w')
fo.write(text)
fo.close()"

    # Romanian-specific fixes
    if [ "$language" = 'ron' ]; then
      # fix diacritics and quotation marks
      sed -i -E '
        s/ã/ă/g; s/Ã/Ă/g;
        s/ş/ș/g; s/Ş/Ș/g;
        s/ţ/ț/g; s/Ţ/Ț/g;
        s/“/”/g' "$f"
    fi

    # Get page number from file name
    pag=$(echo "$f" | tr -d page- | tr -d .txt)

    # Merge text files
    {
      printf "===== %s =====\\n\\n" "$pag"
      cat "$f"
      printf "\\n\\n\\n"
    } >> complete.txt

  done

  # Zip
  zip -q "../${basename}_text.zip" ./*

  cd ..
fi

echo Done.
