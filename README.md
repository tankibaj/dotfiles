Your dotfiles are how you personalize your system. These are mine.

Every time I set up a new macOS and Ubuntu machine, I manually copied my .bashrc file to each machine. It was a real mess. So, I decided to execute a single command on a new machine to pull down all of my dotfiles and install all the tools I commonly use. That’s why I have created this dotfiles repository. It helps me to automate the setup process and maintain aliases.


### Prerequisite

#### macOS

- [xCode](https://developer.apple.com/downloads/index.action?=xcode)

The easiest way to install xCode is the command line. Type `xcode-select --install` on terminal.


### Install dotfiles

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tankibaj/dotfiles/main/install)"
```
