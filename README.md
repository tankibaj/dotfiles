## Install macOS Command Line Tools 

```bash
xcode-select --install
```


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


## Install dotfile

#### via curl

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/tankibaj/dotfiles/master/install.sh)"
```

#### via wget

```bash
sh -c "$(wget -O- https://raw.githubusercontent.com/tankibaj/dotfiles/master/install.sh)"
```


## Zshrc

#### Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles

```bash
rm -f $HOME/.zshrc && \
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc && \
source $HOME/.zshrc
```

## Powerlevel10k configuration wizard

```bash
p10k configure
```
