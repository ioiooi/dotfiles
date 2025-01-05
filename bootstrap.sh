#!/usr/bin/env bash

# Get the directory of this script
cd "$(dirname "${BASH_SOURCE[0]}")"

# Core files that should always be included
FILES_TO_INCLUDE=(
  ".aliases"
  ".bash_profile"
  ".bash_prompt"
  ".bashrc"
  ".exports"
  ".functions"
  "git/.gitconfig"
  "git/.git-templates"
  "git/.gitignore"
)

# OS-specific configurations
if [[ -f "ubuntu/.linux_config" && "$(uname -s)" == "Linux" ]]; then
  FILES_TO_INCLUDE+=("ubuntu/.linux_config")
  echo "Including Linux configuration"
fi

if [[ -f "mac/.mac_config" && "$(uname -s)" == "Darwin" ]]; then
  FILES_TO_INCLUDE+=("mac/.mac_config")
  echo "Including macOS configuration"
fi

# Setup backup directory
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +'%Y%m%d_%H%M%S')"
mkdir -p "$BACKUP_DIR"
echo "Created backup directory: $BACKUP_DIR"

createBackup() {
  local file="$1"
  if [[ -e "$file" ]]; then
    cp -r "$file" "$BACKUP_DIR/$(basename "$file")"
    echo "Backed up: $file"
  fi
}

copyFilesToHome() {
  echo "Starting file copy process..."
  
  for item in "${FILES_TO_INCLUDE[@]}"; do
    local destination="$HOME/$(basename "$item")"
    echo "Processing: $item"
    
    if [[ -e "$destination" ]]; then
      createBackup "$destination"
    fi
    
    cp -r "$item" "$HOME/"
    echo "Copied: $item -> ~"
  done
  
  # Source bash_profile if it exists
  if [[ -f "$HOME/.bash_profile" ]]; then
    source "$HOME/.bash_profile"
    echo "Sourced .bash_profile"
  fi
}

function askForConfirmation() {
  read -p "This may overwrite existing files and directories in your home directory. Are you sure? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    copyFilesToHome
  else
    echo "Operation cancelled by user."
    exit 0
  fi
}

function main() {
  askForConfirmation
}

echo "Starting the script..."
main "$1"
unset -f createBackup copyFilesToHome askForConfirmation main
unset FILES_TO_INCLUDE BACKUP_DIR
echo "Script execution completed."
