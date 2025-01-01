#!/usr/bin/env bash
# generate_thumbnails.sh
#
# Generates 100x100 square thumbnails for all .jpg images
# in the current directory, cropping to make them square.

set -euo pipefail

# Loop through all .jpg files in the current directory
for file in ./*.jpg; do
  # If no .jpg files exist, skip
  [ -e "$file" ] || continue

  # Remove extension to build the output filename
  base="${file%.*}"

  # Use ImageMagick to resize and crop the image to 100x100
  convert "$file" -resize 100x100^ -gravity center -extent 100x100 "${base}-thumb.jpg"
done

echo "All thumbnails generated."