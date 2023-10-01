#!/bin/bash

# This script installs various Linux applications using modern package management techniques.
# It includes functions to check for package installation and install packages using .deb files or package repositories.
#
# Note: This script assumes the user has sudo privileges and is intended
#       for Debian-based Linux distributions.
#
# Example:
#   sudo ./install_applications.sh

# Install required tools
function install_required_tools() {
  echo "Installing required tools..."
  sudo apt update
  sudo apt install -y wget curl gpg
  echo "Required tools installed."
}

# Function to check if a package is installed
package_installed() {
  local package_name=$1

  # Check if the package is installed using dpkg
  if dpkg -l | grep -q "^ii  $package_name"; then
    echo "Package $package_name is installed (verified via dpkg)."
    return 0
  fi

  # Check if the package's binary exists in PATH
  if command -v "$package_name" >/dev/null 2>&1; then
    echo "Package $package_name is installed (verified via PATH)."
    return 0
  fi

  echo "Package $package_name is not installed."
  return 1
}

# Install a .deb package from a given URL
install_deb_package() {
  local package_name=$1
  local download_url=$2

  echo "Installing $package_name..."
  wget -q "$download_url" -O "$package_name.deb"
  sudo dpkg -i "$package_name.deb"
  sudo apt install -f -y
  rm "$package_name.deb"
  echo "$package_name installed successfully!"
}

# Install Visual Studio Code
install_vscode() {
  local package_name="code"
  if ! package_installed "$package_name"; then
    local vscode_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    install_deb_package "$package_name" "$vscode_url"
  else
    echo "Visual Studio Code is already installed."
  fi
}

# Install Insomnia
install_insomnia() {
  local package_name="insomnia"
  if ! package_installed "$package_name"; then
    local insomnia_url="https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website"
    install_deb_package "$package_name" "$insomnia_url"
  else
    echo "$package_name is already installed."
  fi
}

# Install Slack
install_slack() {
  local package_name="slack-desktop"
  if ! package_installed "$package_name"; then
    local slack_url=$(wget -qO - "https://slack.com/downloads/instructions/ubuntu" | grep -io '<a [^>]*href="[^"]*' | grep -i 'slack-desktop' | grep -io 'https://.*\.deb')
    if [ -n "$slack_url" ]; then
      install_deb_package "$package_name" "$slack_url"
    else
      echo "Error: Failed to retrieve Slack download URL."
    fi
  else
    echo "$package_name is already installed."
  fi
}

# Install Spotify
install_spotify() {
  local package_name="spotify-client"
  if ! package_installed "$package_name"; then
    echo "Installing $package_name..."
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    echo "Refreshing repository sources..."
    sudo apt update
    sudo apt install -y "$package_name"
  else
    echo "$package_name is already installed."
  fi
}

# Ensure required tools are installed
install_required_tools

# Install applications
install_vscode
install_insomnia
install_slack
install_spotify

echo "Installation completed!"
