#!/bin/bash
#
# install_nerd_fonts.sh
# This script downloads and installs Nerd Fonts on an Ubuntu system.
# Nerd Fonts are patched fonts that include popular programming glyphs.
# You can choose different versions by modifying the nerd_font_urls array.
# For more information and font options, visit: https://www.nerdfonts.com
#
# Usage: ./install_nerd_fonts.sh

# Nerd Fonts download URLs
nerd_font_urls=(
  "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.tar.xz"
)

# Directory to store downloaded and extracted fonts
FONT_DIR="$HOME/.local/share/fonts"

# Create a temporary directory for downloading and extraction
TMP_DIR="$(mktemp -d)"

# Download and install Nerd Fonts from the URLs in the array
for url in "${nerd_font_urls[@]}"; do
  echo "[-] Downloading and installing Nerd Fonts from: $url"
  wget -O "$TMP_DIR/nerd-fonts.tar.xz" "$url"
  tar -xf "$TMP_DIR/nerd-fonts.tar.xz" -C "$TMP_DIR"
  mkdir -p "$FONT_DIR"
  cp -R "$TMP_DIR/"* "$FONT_DIR"
  fc-cache -fv
done

# Clean up temporary directory
echo "[-] Cleaning up..."
rm -rf "$TMP_DIR"

echo "[-] Nerd Fonts installation done!"
