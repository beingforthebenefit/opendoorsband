# Dockerfile
FROM jekyll/jekyll:latest

# Use apk instead of apt-get, because the base is Alpine Linux
RUN apk update && apk add --no-cache \
  imagemagick \
  optipng \
  inotify-tools

# Copy our scripts into the container
COPY process_images.sh /usr/local/bin/process_images.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/process_images.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]