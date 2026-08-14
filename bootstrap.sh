#!/usr/bin/env bash

# Must be executed, not sourced: the strict mode and the exits below would
# otherwise apply to the caller's interactive shell.
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  echo "Error: run this script as ./bootstrap.sh instead of sourcing it." >&2
  return 1
fi

set -euo pipefail

# Prevent running as root
if [[ $EUID -eq 0 ]]; then
  echo "Error: Do not run this script as root or with sudo."
  echo "The script will ask for sudo when needed."
  exit 1
fi

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

    createBackup "$destination"

    cp -r "$item" "$HOME/"
    echo "Copied: $item -> ~"
  done

  # git/.gitconfig carries no identity, so git will refuse to commit until this
  # machine-local file exists. See the README.
  if [[ ! -f "$HOME/.gitconfig.local" ]]; then
    echo
    echo "Warning: ~/.gitconfig.local is missing, so git has no name or email."
    echo "Create it with a [user] section before committing."
  fi

  echo
  echo "Done. Open a new shell to pick up the changes."
}

askForConfirmation() {
  read -r -p "This may overwrite existing files and directories in your home directory. Are you sure? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    copyFilesToHome
  else
    echo "Operation cancelled by user."
    exit 0
  fi
}

echo "Starting the script..."
askForConfirmation
echo "Script execution completed."
