#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
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

# Install Python 3.8
if ! command_exists python3.8; then
    echo "Installing Python 3.8..."
    sudo apt-get update
    sudo apt-get install -y python3.8 python3.8-venv python3.8-distutils
else
    echo "Python 3.8 is already installed. Skipping installation."
fi

# Set up symlink for python -> python3.8
if [ -L /usr/bin/python ]; then
    echo "Removing existing symlink for python..."
    sudo rm /usr/bin/python
fi

echo "Creating symlink for python -> python3.8..."
sudo ln -s /usr/bin/python3.8 /usr/bin/python

# Verify installation and symlink
if [ "$(python --version 2>&1)" = "Python 3.8."* ]; then
    echo "Python is now symlinked to Python 3.8."
    python --version
else
    echo "Something went wrong. Verify the Python installation and symlink."
    exit 1
fi

# Cleanup
echo "Script execution completed."
