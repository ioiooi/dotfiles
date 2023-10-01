#!/bin/bash

# Install command-line tools using Homebrew.
brew update
brew upgrade

BREW_PREFIX=$(brew --prefix)

# Install core utilities
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install moreutils
brew install moreutils

# Install findutils
brew install findutils

# Install gnu-sed
brew install gnu-sed

# Install bash and bash-completion2
brew install bash
brew install bash-completion2

# Set brew-installed bash as default shell
if ! grep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install wget
brew install wget

# Install other tools
brew install vim
brew install grep
brew install openssh
brew install ack
brew install git
brew install git-lfs
brew install rename
brew install trash
brew install tree
brew install jq
brew install tldr
brew install htop
