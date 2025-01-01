#!/usr/bin/env bash
#
# optimize_images.sh
#
# Optimizes JPG and PNG images in the current directory.
# - Strips metadata
# - Reduces quality of JPGs (to 85%)
# - Losslessly compresses PNGs (optipng -o7)
#
# Requirements:
#   - ImageMagick (for mogrify)
#   - OptiPNG (for PNG optimization)
#
# Usage:
#   1. Install the dependencies if not already installed:
#      macOS (Homebrew): brew install imagemagick optipng
#      Ubuntu/Debian:    sudo apt-get update && sudo apt-get install imagemagick optipng
#   2. Make the script executable:
#      chmod +x optimize_images.sh
#   3. Run the script:
#      ./optimize_images.sh
#
#   Note: This script overwrites the original files, so be sure to back up if needed.

set -euo pipefail

# Optimization settings
JPEG_QUALITY="85"    # Adjust as desired (1-100)
PNG_OPTIMIZATION="-o7" # OptiPNG optimization level (0-7)

# Optimize all JPG files in the directory
for jpg_file in ./*.jpg; do
  # Skip if no JPG files exist
  [ -e "$jpg_file" ] || continue

  echo "Optimizing JPG: $jpg_file"
  mogrify \
    -strip \
    -interlace Plane \
    -sampling-factor 4:2:0 \
    -quality "$JPEG_QUALITY%" \
    "$jpg_file"
done

# Optimize all PNG files in the directory
for png_file in ./*.png; do
  # Skip if no PNG files exist
  [ -e "$png_file" ] || continue

  echo "Optimizing PNG: $png_file"
  optipng $PNG_OPTIMIZATION "$png_file"
done

echo "Image optimization complete!"