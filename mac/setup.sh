#!/bin/bash

#./brew.sh

# Execute the individual scripts
./install_homebrew.sh
./install_packages.sh
./install_casks.sh
./install_nerd_fonts.sh
./cleanup.sh

echo "Setup completed successfully!"
