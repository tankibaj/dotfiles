#!/bin/sh

echo "Setting up Mac"

# Remove .dotfiles directory if exist
rm -rf $HOME/.dotfiles

# Clone Dotfiles
DOTFILES=$HOME/.dotfiles
git clone git@github.com:tankibaj/dotfiles.git $DOTFILES
cd $DOTFILES

# Check for Homebrew and install if don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
#brew update

# Install all our dependencies with bundle (See Brewfile)
#brew tap homebrew/bundle
#brew bundle

# Set default MySQL root password and auth type.
#brew services restart mysql
#mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY '123123'; FLUSH PRIVILEGES;"

# Install PHP extensions with PECL
#pecl install mysql json

# Install global Composer packages
#/usr/local/bin/composer global require laravel/installer laravel/valet

# Install Laravel Valet
#$HOME/.composer/vendor/bin/valet install

# Create a Sites directory
#mkdir $HOME/sites

# Create a github repo directory
#mkdir $HOME/Documents/github

# Backup existing .zshrc before install Oh My Zsh
cp $HOME/.zshrc $HOME/.zshrc.backup

# Install Oh My Zsh
rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -f $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Load new .zshrc
source $HOME/.zshrc

# Upgrade oh_my_zsh
upgrade_oh_my_zsh

# Clone Github repositories
./clone.sh
