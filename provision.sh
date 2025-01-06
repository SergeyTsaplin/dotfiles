#!/bin/bash

_default_dotfiles_repo_url="https://github.com/SergeyTsaplin/dotfiles.git"
_default_hb_script_url="https://raw.githubusercontent.com/Homebrew/install/d86c784131599c29f5c9aba111b40c43c917d9c3/install.sh"
DOTFILES_REPO_URL=${DOTFILES_REPO_URL:-$_default_dotfiles_repo_url}
HOMEBREW_INSTALLATION_SCRIPT_URL=${HOMEBREW_INSTALLATION_SCRIPT_URL:-$_default_hb_script_url}
INSTALL_EXTRAS=${INSTALL_EXTRAS:-false}
INSTALL_MISE_TOOLS=${INSTALL_MISE_TOOLS:-false}
_extra_casks="rancher"
_mise_global_tools="python pre-commit uv jq yq"

xcode-select --install

# Install Homebrew
/bin/bash -c "$(curl -fsS ${HOMEBREW_INSTALLATION_SCRIPT_URL})"

# Install Homebrew packages
brew update && brew upgrade
brew install mc mise fish git-lfs
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
brew install --cask font-fira-code-nerd-font wezterm
if [ "$INSTALL_EXTRAS" = true ]; then
    brew install --cask $_extra_casks
fi

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo ".cfg" >> .gitignore
echo ".cfg" >> README.md
git clone --bare $DOTFILES_REPO_URL $HOME/.cfg
config checkout
config config --local status.showUntrackedFiles no

if [ "$INSTALL_MISE_TOOLS" = true ]; then
    mise use -g ${_mise_global_tools}
fi
