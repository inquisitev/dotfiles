# Dockerfile for initializing an Ubuntu 20.04 environment with chezmoi setup

# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y curl git sudo gnupg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add a non-root user for security
RUN useradd -ms /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user
USER devuser
WORKDIR /home/devuser

# Run the chezmoi setup command when the container starts
# Install chezmoi and add it to PATH
RUN sh -c "$(curl -fsLS get.chezmoi.io)" && \
    echo 'export PATH="$PATH:/home/devuser/.local/bin"' >> /home/devuser/.bashrc

COPY . /home/devuser/.local/share/chezmoi
# Run the chezmoi setup command when the container starts
CMD ["/bin/bash", "-i", "-c", "~/bin/chezmoi init --apply"]
