#!/usr/bin/env bash
#
# process_images.sh
#
# 1. Reads unmodified images from ORIG_DIR (defaults to ./assets/img/photos/originals).
# 2. Outputs optimized/scaled images to OUT_DIR (defaults to ./assets/img/photos).
# 3. Creates 100x100 thumbnail files named with "-thumb" suffix for JPG images.
# 4. Leaves the originals untouched.
#
# Requirements:
#   - ImageMagick (convert)
#   - OptiPNG (for PNG optimization)
#
# Note: This script overwrites images that already exist in the OUT_DIR
#       (but never overwrites originals in ORIG_DIR).
#
# Usage Examples:
#   ./process_images.sh
#   ./process_images.sh /my/originals /my/output
#
#   You can customize the default directories below as needed.

set -euo pipefail

################################
#  CONFIGURATION
################################
MAX_DIM="1200"        # max width/height for large images
JPEG_QUALITY="85"     # compression level for JPG (1–100)
PNG_OPTIM="-o7"       # optipng optimization level (0–7)
THUMB_SIZE="100"      # thumbnail dimension (100x100 for JPG)

################################
#  INPUT DIRECTORIES
################################
# Defaults: 
#   ORIG_DIR  = ./assets/img/photos/originals
#   OUT_DIR   = ./assets/img/photos

ORIG_DIR="${1:-./assets/img/photos/originals}"
OUT_DIR="${2:-./assets/img/photos}"

# Make sure the output directory exists
mkdir -p "$OUT_DIR"

# Check that the originals directory exists
if [ ! -d "$ORIG_DIR" ]; then
  echo "ERROR: '$ORIG_DIR' is not a valid directory."
  exit 1
fi

echo "Reading originals from: $ORIG_DIR"
echo "Writing processed images to: $OUT_DIR"
echo

################################
#  HELPER: PROCESS JPG FUNCTION
################################
process_jpg() {
  local src_file="$1"
  local base_name
  base_name="$(basename "$src_file")"

  # Output file in OUT_DIR
  local out_file="$OUT_DIR/$base_name"

  echo "Processing JPG: $src_file -> $out_file"
  # Create a scaled+optimized JPG using 'convert' (so we don't overwrite the original).
  convert "$src_file" \
    -resize "${MAX_DIM}x${MAX_DIM}>" \
    -strip \
    -interlace Plane \
    -sampling-factor 4:2:0 \
    -quality "${JPEG_QUALITY}%" \
    "$out_file"

  # Generate thumbnail (100x100, cropped)
  local filename_no_ext="${base_name%.*}"            # e.g. "photo"
  local thumb_file="$OUT_DIR/${filename_no_ext}-thumb.jpg"

  echo "  Generating JPG thumbnail: $thumb_file"
  convert "$src_file" \
    -resize "${THUMB_SIZE}x${THUMB_SIZE}^" \
    -gravity center \
    -extent "${THUMB_SIZE}x${THUMB_SIZE}" \
    "$thumb_file"
}

################################
#  HELPER: PROCESS PNG FUNCTION
################################
process_png() {
  local src_file="$1"
  local base_name
  base_name="$(basename "$src_file")"

  local out_file="$OUT_DIR/$base_name"

  echo "Processing PNG: $src_file -> $out_file"
  # Scale + strip metadata
  convert "$src_file" \
    -resize "${MAX_DIM}x${MAX_DIM}>" \
    -strip \
    "$out_file"

  # Optimize PNG (lossless)
  echo "  Optimizing PNG with optipng"
  optipng $PNG_OPTIM "$out_file"
}

################################
#  MAIN SCRIPT
################################

# Find all JPG and PNG in the originals directory (non-recursive).
# If you want recursion, replace the loops with something like:
#   find "$ORIG_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | while read -d $'\0' file; do ...
# For now, we'll do top-level only.

shopt -s nullglob  # allows for empty matches without an error

# Process all JPG in ORIG_DIR
for file in "$ORIG_DIR"/*.jpg; do
  [ -e "$file" ] || continue  # skip if none
  process_jpg "$file"
done

# Process all PNG in ORIG_DIR
for file in "$ORIG_DIR"/*.png; do
  [ -e "$file" ] || continue  # skip if none
  process_png "$file"
done

shopt -u nullglob

echo
echo "All images processed successfully!"
echo "Originals left intact in:   $ORIG_DIR"
echo "Optimized versions in:      $OUT_DIR"