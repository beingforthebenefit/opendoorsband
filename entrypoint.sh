#!/usr/bin/env bash
set -e

# 1) Run image processing script once at container start
echo "Running initial image processing..."
/usr/local/bin/process_images.sh

# 2) Start a background watcher on the originals folder
#    Whenever a JPG or PNG is created/modified/deleted, re-run the script.
/usr/bin/inotifywait -m -r -e create,modify,delete --format '%w%f' /srv/jekyll/assets/img/photos/originals |
while read FILE; do
  # Basic check: only react if it's a .jpg or .png
  if [[ "$FILE" =~ \.(jpg|png)$ ]]; then
    echo "Detected change in $FILE; re-processing images..."
    /usr/local/bin/process_images.sh
    echo "Done processing."
  fi
done &

# 3) Finally, run Jekyll in the foreground
#    (the & above means the watcher is in the background, so Jekyll can still run)
bundle install
jekyll serve --watch --force_polling --incremental