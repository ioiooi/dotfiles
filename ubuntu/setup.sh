#!/bin/bash
set -euo pipefail

# Execute the individual scripts
./add_repositories.sh
./install_packages.sh
./install_applications.sh
./install_snap_apps.sh
./install_nerd_fonts.sh

echo "Setup completed successfully!"