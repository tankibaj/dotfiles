# Basic For Mac OS
alias terminal-reload='source ~/.dotfiles/.zshrc'
alias copy-ssh-key="cat ~/.ssh/id_rsa.pub | pbcopy && echo 'SSH Public Key Copied To Clipboard'"
alias fdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo 'DSN Flushed'"
alias ssh-config="subl ~/.ssh/config"
alias myip="curl https://ipecho.net/plain"
alias whoisme="curl -s "http://ifconfig.co/json" | jq -r '.'"
alias ipv6="curl -s ipv6.icanhazip.com"
alias zshrc='open -a /Applications/Sublime\ Text.app ~/.dotfiles/.zshrc'
alias aliases='open -a /Applications/Sublime\ Text.app ~/.dotfiles/aliases.zsh'
alias path='open -a /Applications/Sublime\ Text.app ~/.dotfiles/path.zsh'
alias hosts='open -a /Applications/Sublime\ Text.app /etc/hosts'
alias ls='ls -lhF'
alias ls.='ls -lhFa'
alias size="du -sh"

# Prompt confirmation and explain what is being done
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias ln='ln -iv'


# Open Application
alias subl="open -a /Applications/Sublime\ Text.app ./"
alias phps='open -a PhpStorm ./'
alias vsc='open -a /Applications/Visual\ Studio\ Code.app ./'
alias typora='open -a /Applications/Typora.app ./'


# Directories
alias home="cd ~"
alias docs="cd ~/Documents"
alias dl="cd ~/Downloads"
alias app="cd /Applications"
alias sites="cd ~/sites"
alias snippets="cd ~/Documents/Snippets"
alias github="cd ~/Documents/github"
alias dotfiles='~/.dotfiles'


# Brew
alias app-upgrade='brew upgrade && brew cask upgrade'
alias cask-list='brew cask list'
alias cask-upgrade='brew cask upgrade'


# Git
#alias init='git init'
alias clone='git clone'
alias add='git add .'
alias commit='git commit -m'
alias status='git status'
alias log='git log'
alias push='git push -u'
alias pull='git pull'
alias nah='git reset --hard && git clean -df'
alias nahto='git reset --hard'
alias showallbranch='git branch -a'
alias checkout='git checkout'
alias checkoutnew='git checkout -b'
alias deletebranch='git branch -D'
alias setorigin='git remote set-url origin'
alias origin='git remote show origin'
alias remote='git remote -v'
alias remote-remove='git remote remove'
alias remote-rename='git remote rename'
alias commit-count='git rev-list --count'
alias git-remove='rm -rf .git*'


# Laravel
alias artisan='php artisan'
alias lara='composer create-project laravel/laravel'
alias env='php artisan env'
alias laraKey='php artisan key:generate'
alias mf='php artisan migrate:fresh'
alias mfs='php artisan migrate:fresh --seed'
alias mrf='php artisan migrate:refresh'
alias make='php artisan make'
alias model='php artisan make:model'
alias controller='php artisan make:controller'
alias migrate='php artisan migrate'
alias queue='php artisan queue'
alias route='php artisan route'
alias tinker='php artisan tinker'
alias resource='php artisan nova:resource'
alias getenv="curl -o .env https://raw.githubusercontent.com/laravel/laravel/master/.env.example"
alias laraStart="getenv && composer update && laraKey && phps ."
alias cache-clear='php artisan cache:clear'
alias cache-optimize='php artisan optimize'
alias cache-config='php artisan config:cache'
alias cache-route='php artisan route:cache '
alias cache-view='php artisan view:cache'


# Composer
alias autodump='composer dump-autoload'


# Vagrant
alias vssh="vagrant ssh"
alias up="vagrant up"
alias suspend="vagrant suspend"
alias resume="vagrant resume"
# alias destroy="vagrant destroy"
alias reload="vagrant reload"
alias reloadp="vagrant reload --provision"
alias halt="vagrant halt"
alias globalstatus="vagrant global-status"
alias box-list='vagrant box list'
alias box-remove='vagrant box remove'
alias box-add='vagrant box add'


# Nginx
alias nginxError='tail -n 100 /usr/local/var/log/nginx/error.log'


# Youtube download
alias ydl='cd ~/Downloads && youtube-dl -f bestvideo+bestaudio'
alias ydl-mp3='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format mp3'
alias ydl-m4a='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format m4a'
alias ydl-wav='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format wav'
alias ydl-aac='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format aac'
alias ydl-audio='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format best'


# Markdown
alias toc='gh-md-toc'

# Terraform
alias fmt='terraform fmt'
alias validate='terraform validate'
alias plan='terraform plan'
alias apply='terraform apply'
alias state='terraform state'
alias show='terraform show'
alias workspace='terraform workspace'



#### Basic function ####

# See all paths, one element per line.
# If an argument is supplied, grep fot it.
PATH() {
    test -n "$1" && {
        echo $PATH | perl -p -e "s/:/\n/g;" | grep -i "$1"
    } || {
        echo $PATH | perl -p -e "s/:/\n/g;"
    }
}

gettingStarted() {
    if [ -e GettingStarted.txt ]; then
        egrep '^\s+\$' GettingStarted.txt | sed -e 's@\$@@'
    else
        echo 'GettingStarted does not exist!!'
    fi
}

codeBlock() {
    if [ -e README.md ]; then
        sed -n '/^```/,/^```/ p' <README.md | sed '/^```/ d'
    else
        echo 'README does not exist!!'
    fi
}

codeBlockBash() {
    if [ -e README.md ]; then
        sed -n '/^```bash/,/^```/ p' <README.md | sed '/^```/ d'
    else
        echo 'README does not exist!!'
    fi
}

copyit() {
    cat $1 | pbcopy && echo 'Copied To Clipboard'
}


destroy() {
    if [ -e .vagrant ]; then
        vagrant destroy
    elif [ -e .terraform ]; then
        terraform destroy
    else
        echo "This action isn't allowed to run in this directory"
    fi
}

whoisip() {
    curl -s http://ip-api.com/json/$1 | jq -r '.'
}
