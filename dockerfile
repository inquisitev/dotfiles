# Use an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    unzip \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

# Install Snap
RUN apt-get update && apt-get install -y \
    snapd \
    && rm -rf /var/lib/apt/lists/*

# Enable snapd service (necessary for Docker images)
RUN systemctl enable snapd

# Install chezmoi
RUN curl -fsLS get.chezmoi.io | sh

COPY token token

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo '%l6ti0g0 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN useradd -m l6ti0g0
USER l6ti0g0
RUN mkdir -p /home/l6ti0g0/
RUN mkdir -p /home/l6ti0g0/.ssh

RUN gh auth login -h "github.deere.com" -p "ssh" --skip-ssh-key --with-token < token
RUN gh auth setup-git
RUN ssh-keyscan -H github.deere.com >> ~/.ssh/known_hosts
RUN ssh-keygen -t rsa -b 3072 -f ~/.ssh/id_ed25519
RUN gh ssh-key add ~/.ssh/id_ed25519.pub
RUN gh repo clone github.deere.com/l6ti0g0/private-dotfiles /home/l6ti0g0/.local/share/private-dotfiles
ADD . /home/l6ti0g0/.local/share/chezmoi

RUN chezmoi apply || echo "failed"

