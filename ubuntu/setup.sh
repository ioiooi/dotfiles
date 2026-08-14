#!/bin/bash
set -euo pipefail

# The scripts below are called by relative path, so run from this directory
# regardless of where setup.sh was invoked from.
cd "$(dirname "${BASH_SOURCE[0]}")"

# Execute the individual scripts
./add_repositories.sh
./install_packages.sh
./install_applications.sh
./install_snap_apps.sh
./install_nerd_fonts.sh
./configure_desktop.sh

echo "Setup completed successfully!"