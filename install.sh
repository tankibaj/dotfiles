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
cp $HOME/.zshrc $HOME/.zshrc.original

# Install Oh My Zsh
ZSH=$HOME/.oh-my-zsh
rm -rf $ZSH
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH

#### Install PowerLeve10K theme
rm -f $HOME/.p10k.zsh
git clone https://github.com/romkatv/powerlevel10k.git $ZSH/themes/powerlevel10k

#### Download PowerLeve10K Plugins for autosuggestion and syntax highlighting:
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# Load new .zshrc
source $HOME/.zshrc

# Clone Github repositories
# ./clone.sh
