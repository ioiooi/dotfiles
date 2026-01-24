#!/bin/bash
set -euo pipefail

# Add Third-Party Repositories
#
# This script adds third-party repositories to an Ubuntu system to access newer versions of programs or missing packages.
#
# Usage: ./add_repositories.sh
#
# Note: Always exercise caution when adding third-party repositories. Make sure they come from reputable sources.
#
# Example:
#   ./add_repositories.sh

# Install required tools
function install_required_tools() {
  sudo apt update
  sudo apt install wget gpg software-properties-common
}

# Version Control and Development Tools
function add_git_repository() {
  sudo add-apt-repository ppa:git-core/ppa
}

# IDEs and Editors
function add_vscode_repository() {
  # Microsoft GPG key fingerprint: BC52 8686 B50D 79E3 39D3 721C EB3E 94AD BE12 29CF
  echo "Adding Microsoft VS Code repository (verify key fingerprint: BC52 8686 B50D 79E3 39D3 721C EB3E 94AD BE12 29CF)"
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  rm -f packages.microsoft.gpg
}

# Development Libraries and Runtimes
function add_openjdk_repository() {
  sudo add-apt-repository ppa:openjdk-r/ppa
}

function add_php_repository() {
  sudo add-apt-repository ppa:ondrej/php
}

# Web Servers and Server Software
function add_nginx_repository() {
  sudo add-apt-repository ppa:nginx/stable
}

function add_apache_repository() {
  sudo add-apt-repository ppa:ondrej/apache2
}

# Additional Tools
function add_nvidia_drivers_repository() {
  sudo add-apt-repository ppa:graphics-drivers/ppa
}

function add_spotify_repository() {
  curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
}

function add_insomnia_repository() {
  echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" | sudo tee -a /etc/apt/sources.list.d/insomnia.list
}

function add_symfony_repository() {
  local tmp_script=$(mktemp)
  curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' -o "$tmp_script"
  echo "Downloaded Symfony setup script to $tmp_script - review before execution if needed"
  sudo -E bash "$tmp_script"
  rm -f "$tmp_script"
}

# Update package list
function update_package_list() {
  sudo apt update
}

# Ensure required tools are installed
install_required_tools

# Add repositories
add_git_repository
add_vscode_repository
add_openjdk_repository
add_php_repository
add_nginx_repository
add_apache_repository
add_nvidia_drivers_repository
add_spotify_repository
add_insomnia_repository
add_symfony_repository

# Update package list
update_package_list
