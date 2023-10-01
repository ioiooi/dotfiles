#!/usr/bin/env bash

# Install homebrew if it's missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
echo 'Be sure to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.'
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
echo 'Add `$(brew --prefix findutils)/libexec/gnubin` to `$PATH` if you would prefer these be the defaults.'
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
echo 'Be sure to add `$(brew --prefix gnu-sed)/libexec/gnubin` to `$PATH`.'
brew install gnu-sed
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget

# Install more recent versions of some macOS tools.
echo 'If you would like to map vi so it opens the brew-installed vim: ln -s /usr/local/bin/vim /usr/local/bin/vi'
brew install vim
brew install grep
brew install openssh

# Install other useful binaries.
brew install ack
#brew install exiv2
brew install git
brew install git-lfs
brew install rename
brew install trash
brew install tree
brew install jq
brew install tldr
brew install htop

# Install casks
brew install --cask iterm2
brew install --cask visual-studio-code
brew install --cask insomnia
brew install --cask slack
brew install --cask spotify
brew install --cask notunes
brew install --cask spectacle

# Install nerd fonts
brew tap homebrew/cask-fonts
brew install --cask font-fira-code-nerd-font
brew install --cask font-dejavu-sans-mono-nerd-font
brew install --cask font-jetbrains-mono-nerd-font

# Remove outdated versions from the cellar.
brew cleanup
