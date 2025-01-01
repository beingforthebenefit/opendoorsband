#!/usr/bin/env bash
#
# optimize_and_scale_images.sh
#
# 1. Scales down JPG and PNG images so that neither width nor height
#    exceeds MAX_DIM.
# 2. Strips metadata (for JPG and PNG).
# 3. Optimizes JPGs (quality, progressive/interlaced).
# 4. Optimizes PNGs (lossless with optipng).
#
# Requirements:
#   - ImageMagick (for mogrify)
#   - OptiPNG (for PNG optimization)
#
# Usage:
#   1. Install dependencies if needed:
#      macOS (Homebrew):  brew install imagemagick optipng
#      Ubuntu/Debian:     sudo apt-get update && sudo apt-get install imagemagick optipng
#   2. Make it executable:
#      chmod +x optimize_and_scale_images.sh
#   3. Run the script:
#      ./optimize_and_scale_images.sh
#
# NOTE: This script overwrites the original images. Backup if needed.

set -euo pipefail

################################
#  CONFIGURATION
################################
MAX_DIM="1200"     # max width/height
JPEG_QUALITY="85"  # compression level for JPG (1–100)
PNG_OPTIM="-o7"    # optipng optimization level (0–7)

################################
#  SCALE + OPTIMIZE JPG
################################
for jpg_file in ./*.jpg; do
  [ -e "$jpg_file" ] || continue
  echo "Processing JPG: $jpg_file"

  # 1. Scale down to MAX_DIM (maintaining aspect ratio)
  # 2. Strip metadata
  # 3. Convert to progressive/interlaced
  # 4. Set quality to JPEG_QUALITY
  mogrify \
    -resize "${MAX_DIM}x${MAX_DIM}>" \
    -strip \
    -interlace Plane \
    -sampling-factor 4:2:0 \
    -quality "$JPEG_QUALITY%" \
    "$jpg_file"
done

################################
#  SCALE PNG
################################
for png_file in ./*.png; do
  [ -e "$png_file" ] || continue
  echo "Processing PNG (scaling): $png_file"

  # Scale down to MAX_DIM and strip metadata
  mogrify \
    -resize "${MAX_DIM}x${MAX_DIM}>" \
    -strip \
    "$png_file"
done

################################
#  OPTIMIZE PNG (lossless)
################################
for png_file in ./*.png; do
  [ -e "$png_file" ] || continue
  echo "Optimizing PNG (optipng): $png_file"
  optipng $PNG_OPTIM "$png_file"
done

echo "All images have been scaled and optimized!"