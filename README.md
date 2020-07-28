# Setting up Mac

## Setup SSH Key

First of all, copy your ssh private and public key to `~/.ssh`

Make sure that ssh agent is running.

```bash
eval $(ssh-agent -s)
```

Add your SSH private key to the ssh-agent.

```bash
ssh-add ~/.ssh/id_rsa
```

Test git ssh connection

```bash
ssh -T git@github.com
```



## Install macOS Command Line Tools 

```bash
xcode-select --install
```



## Start the installation

#### via curl

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tankibaj/dotfiles/master/install.sh)"
```

#### via wget

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/tankibaj/dotfiles/master/install.sh)"
```

## zshrc

#### Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles

```bash
rm -f $HOME/.zshrc && ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc
```

#### Source .zshrc

```bash
source $HOME/.zshrc
```


## PowerLeve10K and Plugin

#### Install PowerLeve10K theme

```bash
rm -f $HOME/.p10k.zsh && git clone https://github.com/romkatv/powerlevel10k.git $ZSH/themes/powerlevel10k
```

#### Download PowerLeve10K Plugins for autosuggestion and syntax highlighting:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH/plugins/zsh-autosuggestions && \
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/plugins/zsh-syntax-highlighting
```
