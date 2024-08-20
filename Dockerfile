# Use the Ruby 3.3 base image
FROM mcr.microsoft.com/devcontainers/ruby:3.3

# Create and set the workspace directory
RUN mkdir /workspace
WORKDIR /workspace

# Install dependencies to add the deadsnakes PPA (which provides newer Python versions)
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa

# Install Python 3.10 and pip for Python 3.10
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-venv \
    python3.10-dev \
    python3-pip

# Optional: Set Python 3.10 as the default python3 and pip3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 \
    && update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3 1

# Verify the installation
RUN python3 --version && pip3 --version
