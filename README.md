# My .dotfiles

## How to provision a new Mac

The provision script will install all the necessary software and synchronize the config files.

```bash
/bin/bash -c "$(curl -fsS https://raw.githubusercontent.com/SergeyTsaplin/dotfiles/refs/heads/main/provision.sh)"
```

## How to setup on a old Mac

> **NOTE:** Skip the following steps if the `provision.sh` has been used 

### Requirements

* homebrew
* git

### Setup

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

```bash
echo ".cfg" >> .gitignore
echo ".cfg" >> README.md
```

```bash
git clone --bare https://github.com/SergeyTsaplin/dotfiles.git $HOME/.cfg
```

```bash
config config --local status.showUntrackedFiles no
```

```bash
config checkout
```

### Setup fish shell

```bash
brew install fish
```

```bash
echo /usr/local/bin/fish | sudo tee -a /etc/shells
chsh -s /usr/local/bin/fish
```
