#!/bin/bash

set -e

# Function to print messages
print_message() {
  echo "--------------------------------------------"
  echo "$1"
  echo "--------------------------------------------"
}

# Step 1: Update Package Index
print_message "Updating package index..."
sudo apt-get update -y

# Step 2: Install Dependencies
print_message "Installing required dependencies (curl, unzip)..."
sudo apt-get install -y curl unzip

# Step 3: Download the AWS CLI v2 Installer
print_message "Downloading AWS CLI v2 installer..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Step 4: Unzip the Installer
print_message "Unzipping AWS CLI installer..."
unzip awscliv2.zip

# Step 5: Install AWS CLI
print_message "Installing AWS CLI..."
sudo ./aws/install

# Step 6: Verify Installation
print_message "Verifying AWS CLI installation..."
aws --version

# Step 7: Clean Up
print_message "Cleaning up installation files..."
rm -rf awscliv2.zip aws

print_message "AWS CLI installation complete!"
