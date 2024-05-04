# Use an existing image as a base
FROM jekyll/builder:latest

# Set the working directory inside the container
WORKDIR /srv/jekyll

# Copy the contents of your Jekyll project into the container
COPY . .

# Expose the default Jekyll port (4000)
EXPOSE 4000

# Start the Jekyll server
CMD ["jekyll", "serve", "--host", "0.0.0.0"]
