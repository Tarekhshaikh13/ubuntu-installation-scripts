#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install required dependencies
install_dependencies() {
    echo "Installing build dependencies..."
    sudo apt-get update
    sudo apt-get install -y \
        wget build-essential libssl-dev zlib1g-dev \
        libncurses5-dev libncursesw5-dev libreadline-dev \
        libsqlite3-dev libgdbm-dev libdb5.3-dev libbz2-dev \
        libexpat1-dev liblzma-dev tk-dev libffi-dev
}

# Uninstall Python 3.10.12
if command_exists python3.10; then
    echo "Uninstalling Python 3.10.12..."
    sudo apt-get remove --purge -y python3.10 python3.10-venv python3.10-distutils
    sudo apt-get autoremove -y
    sudo apt-get clean
else
    echo "Python 3.10.12 is not installed. Skipping uninstallation."
fi

# Install dependencies for building Python 3.8.12
install_dependencies

# Download and extract Python 3.8.12 source code
PYTHON_VERSION="3.8.12"
PYTHON_TAR="Python-${PYTHON_VERSION}.tgz"
PYTHON_SRC_DIR="Python-${PYTHON_VERSION}"
DOWNLOAD_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/${PYTHON_TAR}"

if [ ! -f "$PYTHON_TAR" ]; then
    echo "Downloading Python ${PYTHON_VERSION}..."
    wget "${DOWNLOAD_URL}"
fi

if [ ! -d "$PYTHON_SRC_DIR" ]; then
    echo "Extracting Python ${PYTHON_VERSION}..."
    tar -xf "$PYTHON_TAR"
fi

# Build and install Python 3.8.12
cd "$PYTHON_SRC_DIR" || exit 1

echo "Configuring Python ${PYTHON_VERSION}..."
./configure --enable-optimizations --with-ensurepip=install

echo "Building Python ${PYTHON_VERSION} (this may take a while)..."
make -j "$(nproc)"

echo "Installing Python ${PYTHON_VERSION}..."
sudo make altinstall

cd ..

# Set up symlink for python -> python3.8
if [ -L /usr/bin/python ]; then
    echo "Removing existing symlink for python..."
    sudo rm /usr/bin/python
fi

echo "Creating symlink for python -> python3.8.12..."
sudo ln -s /usr/local/bin/python3.8 /usr/bin/python

# Verify installation and symlink
if [ "$(python --version 2>&1)" = "Python 3.8."* ]; then
    echo "Python is now symlinked to Python 3.8.12."
    python --version
else
    echo "Something went wrong. Verify the Python installation and symlink."
    exit 1
fi

# Cleanup
echo "Cleaning up source files..."
rm -rf "$PYTHON_SRC_DIR" "$PYTHON_TAR"

echo "Script execution completed."
