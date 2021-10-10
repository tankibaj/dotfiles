#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles
ZSH=$HOME/.oh-my-zsh

installDotfiles() {
  echo
  echo
  echo "Setting up dotfiles....."
  echo
  echo

  cleaUp                                                                           # Remove old files and directories if exist
  git clone https://github.com/tankibaj/dotfiles.git $DOTFILES                     # Clone Dotfiles
  brewBundle                                                                       # Install all contents from Brewfile
  backupSHRC                                                                       # Backup existing .zshrc or .bashrc before install Oh My Zsh
  git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH                            # Clone Oh My Zsh
  git clone https://github.com/romkatv/powerlevel10k.git $ZSH/themes/powerlevel10k # Clone PowerLeve10K theme

  # Clone PowerLeve10K plugins for autosuggestion and syntax highlighting:
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting
  ln -s $DOTFILES/.zshrc $HOME/.zshrc # Symlinks the .zshrc file from the .dotfiles

  # Global gitignore
  ln -s $DOTFILES/.gitignore $HOME/.gitignore
  git config --global core.excludesfile $HOME/.dotfiles/.gitignore
}

backupSHRC() {
  if [[ -e $HOME/.zshrc ]]; then
    cp $HOME/.zshrc $HOME/.zshrc.original
  fi

  if [[ -e $HOME/.bashrc ]]; then
    cp $HOME/.bashrc $HOME/.bashrc.original
  fi
}

brewBundle() {
  # Check for Homebrew and install if don't have it
  if test ! $(which brew); then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  brew update                                   # Update Homebrew recipes
  brew bundle install --file=$DOTFILES/Brewfile # Install all contents from Brewfile
}

cleaUp() {
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
}

if [[ "$(uname -s)" == "Darwin" ]]; then
  if [[ ! -d $DOTFILES ]]; then
    installDotfiles
  else
    echo
    read -p "[INFO] Dotfiles already installed. Do you want to reinstall? [y/N]: " confirmation
    echo
    until [[ "$confirmation" =~ ^[yYnN]*$ ]]; do
      echo
      echo "[ERROR] invalid selection."
      echo
      read -p "[INFO] Dotfiles already installed. Do you want to reinstall? [y/N]: " confirmation
      echo
    done
    if [[ "$confirmation" =~ ^[yY]$ ]]; then
      installDotfiles
    fi
  fi
else
  echo
  echo "[ERROR] This script can be run only on macOS"
  echo
  exit 1
fi
