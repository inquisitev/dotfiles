#!/bin/bash

# Build the Docker image
sudo docker build -t chezmoi-setup .

# Run the Docker container with a TTY and SSH forwarding
sudo docker run -it --rm chezmoi-setup /bin/bash
