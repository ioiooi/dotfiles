#!/bin/bash

# Install Snap Apps
#
# This script installs specified Snap applications if they are not already installed.
#
# Usage: Modify the 'snap_apps' array with the desired application names.
#        Run the script with 'sudo' permissions to install the applications.
#
# Note: This script uses the 'snap' package manager. Make sure 'snapd' is installed on your system.
#
# Example:
#   ./install_snap_apps.sh

# Install required dependencies
install_snap_package_manager() {
  if ! command -v snap >/dev/null 2>&1; then
    echo "Installing snapd..."
    sudo apt update
    sudo apt install -y snapd
    echo "Snapd has been successfully installed."
  else
    echo "Snapd is already installed."
  fi
}

# Function to check if a Snap app is installed
snap_app_installed() {
  local app_name=$1

  if snap list | grep -q "^$app_name"; then
    return 0
  else
    return 1
  fi
}

# Function to install a Snap app
install_snap_app() {
  local app_name=$1

  if snap_app_installed "$app_name"; then
    echo "$app_name is already installed via snap."
  else
    echo "Installing $app_name via snap..."
    sudo snap install "$app_name" --classic
    echo "$app_name has been successfully installed via snap."
  fi
}

# Check and install snap package manager
install_snap_package_manager

# List of snap apps to be installed
snap_apps=("code" "phpstorm" "slack" "spotify" "insomnia" "node" "tldr")

# Install snap apps
for app in "${snap_apps[@]}"; do
  install_snap_app "$app"
done

echo "Snap app installation completed!"
