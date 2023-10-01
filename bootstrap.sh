#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE[0]}")"
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

if [[ -f "ubuntu/.linux_config" && "$(uname -s)" == "Linux" ]]; then
  FILES_TO_INCLUDE+=("ubuntu/.linux_config")
fi

if [[ -f "mac/.mac_config" && "$(uname -s)" == "Darwin" ]]; then
  FILES_TO_INCLUDE+=("mac/.mac_config")
fi

BACKUP_DIR="$HOME/.dotfiles_backup"
mkdir -p "$BACKUP_DIR"

function createBackup() {
  local file="$1"
  local timestamp="$(date +'%Y-%m-%d_%H:%M:%S')"
  local backup_file="$BACKUP_DIR/$(basename "$file").backup_${timestamp}"

  if [[ ! -e "$backup_file" ]]; then
    cp -r "$file" "$backup_file"
    echo "Backup created: $backup_file"
  else
    echo "Backup already exists: $backup_file"
  fi
}

function copyFilesToHome() {
  echo "Copying files to the home directory..."
  for item in "${FILES_TO_INCLUDE[@]}"; do
    local destination="$HOME/$(basename "$item")"

    echo "$item"
    echo "$destination"

    if [[ -e "$destination" ]]; then
      createBackup "$destination"
    fi

    rsync -ah --no-perms "$item" ~
    echo "Copied: $item"
  done
  echo "Files copied."

  source "$HOME/.bash_profile" && echo "Bash profile sourced."
}

function askForConfirmation() {
  read -p "This may overwrite existing files and directories in your home directory. Are you sure? (y/n) " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    copyFilesToHome
  fi
}

function main() {
  if [[ "$1" == "--force" || "$1" == "-f" ]]; then
    copyFilesToHome
  else
    askForConfirmation
  fi
}

echo "Starting the script..."
main "$1"
unset -f createBackup copyFilesToHome askForConfirmation main
unset FILES_TO_INCLUDE BACKUP_DIR
echo "Script execution completed."
