#!/bin/bash

# Check and install packages
#
# This script checks a list of specified packages and installs them if they are not already installed.
#
# Usage: Modify the 'packages' array with the desired package names.
#        Run the script with 'sudo' permissions to install the packages.
#
# Example:
#   sudo ./package_installer.sh

# Function to check if a package is installed
package_installed() {
  local package_name=$1

  if dpkg -s "$package_name" >/dev/null 2>&1 || which "$package_name" >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

# Function to install a package
install_package() {
  local package_name=$1

  if ! package_installed "$package_name"; then
    echo "Installing $package_name..."
    sudo apt install -y "$package_name"
  else
    echo "$package_name is already installed."
  fi
}

sudo apt update

# List of packages to check and install
packages=("git" "curl" "wget" "jq" "tree" "htop" "ack" "mawk" "vim")

# Check and install packages
for package in "${packages[@]}"; do
  install_package "$package"
done
