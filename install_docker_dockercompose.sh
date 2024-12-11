#!/bin/bash

set -e

# Function to print messages
print_message() {
  echo "--------------------------------------------"
  echo "$1"
  echo "--------------------------------------------"
}

# Step 1: Update and Install Dependencies
print_message "Updating package index and installing dependencies..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Step 2: Add Docker's GPG Key
print_message "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Step 3: Add Docker Repository
print_message "Adding Docker repository..."
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Step 4: Install Docker
print_message "Installing Docker..."
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Step 5: Enable and Start Docker
print_message "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Step 6: Verify Docker Installation
print_message "Verifying Docker installation..."
sudo docker --version

# Step 7: Install Docker Compose
print_message "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="2.25.0"  # Replace with the latest version if needed
sudo curl -L "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Step 8: Apply Executable Permissions to Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Step 9: Verify Docker Compose Installation
print_message "Verifying Docker Compose installation..."
docker-compose --version

# Step 10: Add Current User to Docker Group (Optional)
print_message "Adding current user to the Docker group..."
sudo usermod -aG docker $USER
echo "Please log out and log back in for group changes to take effect."

print_message "Docker and Docker Compose installation complete!"
