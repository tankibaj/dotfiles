#!/usr/bin/env bash

is_macOS() {
  if [ "$(uname -s)" == "Darwin" ]; then
    return 0
  else
    return 1
  fi
}

is_macOS ||
  {
    echo "[ERROR] This script can be run only on macOS"
    exit 1
  }

echo "Setting up dotfiles....."

DOTFILES=$HOME/.dotfiles
ZSH=$HOME/.oh-my-zsh

# Remove old files and directories if exist
if [[ -d $DOTFILES ]]; then
  sudo rm -rf $DOTFILES
fi

if [[ -d $ZSH ]]; then
  sudo rm -rf $ZSH
fi

if [[ -e $HOME/.p10k.zsh ]]; then
  sudo rm -f $HOME/.p10k.zsh
fi

if [[ -L $HOME/.zshrc ]]; then
  sudo rm -f $HOME/.zshrc
fi

# Check for Homebrew and install if don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Clone Dotfiles
git clone git@github.com:tankibaj/dotfiles.git $DOTFILES

# Backup existing .zshrc before install Oh My Zsh
cp $HOME/.zshrc $HOME/.zshrc.original

# Clone Oh My Zsh
git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH

# Clone PowerLeve10K theme
git clone https://github.com/romkatv/powerlevel10k.git $ZSH/themes/powerlevel10k

# Clone PowerLeve10K plugins for autosuggestion and syntax highlighting:
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting

# Symlinks the .zshrc file from the .dotfiles
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Update Homebrew recipes
brew update

# Install all contents from Brewfile
brew bundle install

# # Set default MySQL root password and auth type.
# brew services restart mysql
# mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY '123123'; FLUSH PRIVILEGES;"

# # Install PHP extensions with PECL
# pecl install mysql json

# # Install global Composer packages
# /usr/local/bin/composer global require laravel/installer laravel/valet

# # Install Laravel Valet
# $HOME/.composer/vendor/bin/valet install

# # Create a Sites directory
# mkdir $HOME/Documents/Sites
