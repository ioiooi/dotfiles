#!/bin/bash
set -euo pipefail

# Clean up what the package managers leave behind
#
# Removes old snap revisions, downloaded package files, packages nothing
# depends on any more and the configuration files of removed packages.
#
# Run it by hand; nothing calls it. apt lists what it is about to remove and
# asks first. The snap step and 'apt clean' do not ask, as they only touch what
# is already inactive.
#
# Usage:
#   ./cleanup.sh

# A step that fails, or an apt prompt answered with "n", skips that step. It
# should not end the script.
skipped() {
  echo "Skipped: $1"
}

echo "Removing old snap revisions..."
if command -v snap >/dev/null 2>&1; then
  # LC_ALL=C so the Notes column reads "disabled" in every locale.
  mapfile -t revisions < <(LC_ALL=C snap list --all | awk '$NF ~ /disabled/ { print $1, $3 }')

  for revision in "${revisions[@]}"; do
    read -r name number <<< "$revision"
    sudo snap remove "$name" --revision="$number" || skipped "$name revision $number"
  done

  if (( ${#revisions[@]} == 0 )); then
    echo "None found."
  fi
else
  echo "snap is not installed."
fi

echo "Removing downloaded package files..."
sudo apt clean || skipped "apt clean"

echo "Removing packages nothing depends on any more..."
sudo apt autoremove --purge || skipped "apt autoremove"

echo "Removing configuration files of removed packages..."
mapfile -t leftover < <(dpkg -l | awk '/^rc/ { print $2 }')

if (( ${#leftover[@]} )); then
  sudo apt purge "${leftover[@]}" || skipped "apt purge"
else
  echo "None found."
fi

echo "Cleanup completed!"
