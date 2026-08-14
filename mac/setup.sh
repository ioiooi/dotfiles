#!/bin/bash
set -euo pipefail

# The scripts below are called by relative path, so run from this directory
# regardless of where setup.sh was invoked from.
cd "$(dirname "${BASH_SOURCE[0]}")"

# Execute the individual scripts
./install_homebrew.sh
./install_packages.sh
./install_casks.sh
./install_nerd_fonts.sh
./cleanup.sh

echo "Setup completed successfully!"
