#=========================================================================
#      ---------------| Directories |---------------
#=========================================================================
alias ~="cd $HOME"
alias doc="cd $HOME/documents"
alias dl="cd $HOME/downloads"
alias app="cd /applications"
alias site="cd $HOME/documents/sites"
alias snippets="cd $HOME/documents/snippets"
alias github="cd $HOME/documents/github"
alias dotfiles="$HOME/.dotfiles"
alias workspace="cd $HOME/documents/workspace"
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| List & Size |---------------
#=========================================================================
alias ls='ls -lhF'
alias ls.='ls -lhFa'
alias size="du -sh"
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Prompt & Confirmation |---------------
#=========================================================================
alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias ln='ln -iv'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Open Application |---------------
#=========================================================================
alias subl="open -a /Applications/Sublime\ Text.app ./"
alias phps='open -a PhpStorm ./'
alias vsc='open -a /Applications/Visual\ Studio\ Code.app ./'
alias typora='open -a /Applications/Typora.app ./'

# Open Chrome from the command line.
function chrome() {
    URL=$1
    if [[ $1 != http* ]]; then
        URL="http://$1"
    fi
    /usr/bin/open -a '/Applications/Google Chrome.app' "$URL"
}

# Open Safari from the command line.
function safari() {
    URL=$1
    if [[ $1 != http* ]]; then
        URL="http://$1"
    fi
    /usr/bin/open -a '/Applications/Safari.app' "$URL"
}

# Google things from the command line.
function google() {
    QUERY=$(rawurlencode "$*")
    chrome "https://www.google.com/search?client=safari&rls=en&q=$QUERY&ie=UTF-8&oe=UTF-8"
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| File Editing |---------------
#=========================================================================
alias aliases='open -a /Applications/Sublime\ Text.app ~/.dotfiles/aliases.zsh'
alias zshrc='open -a /Applications/Sublime\ Text.app ~/.dotfiles/.zshrc'
alias path='open -a /Applications/Sublime\ Text.app ~/.dotfiles/path.zsh'
alias hosts='open -a /Applications/Sublime\ Text.app /etc/hosts'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Terminal |---------------
#=========================================================================
alias terminal-reload='source ~/.dotfiles/.zshrc'
alias ssh-copy="cat ~/.ssh/id_rsa.pub | pbcopy && echo 'SSH Public Key Copied To Clipboard'"
alias ssh-config="subl ~/.ssh/config"
alias ssh-update='ssh-keygen -R'
alias vbrestart='sudo "/Library/Application Support/VirtualBox/LaunchDaemons/VirtualBoxStartup.sh" restart'

copyit() {
    cat $1 | pbcopy && echo 'Copied To Clipboard'
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Network Utility |---------------
#=========================================================================
alias fdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo 'DSN Flushed'"
alias myip="curl https://ipecho.net/plain"
alias whoisme="curl -s "http://ifconfig.co/json" | jq -r '.'"
alias ipv6="curl -s ipv6.icanhazip.com"

whoisip() {
    curl -s http://ip-api.com/json/$1 | jq -r '.'
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| HomeBrew |---------------
#=========================================================================
alias app-upgrade='brew upgrade && brew cask upgrade'
alias cask-list='brew cask list'
alias cask-upgrade='brew cask upgrade'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Git |---------------
#=========================================================================
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
alias bls='git branch -a'
alias checkout='git checkout'
alias checkoutnew='git checkout -b'
alias brm='git branch -D'
alias setorigin='git remote set-url origin'
alias origin='git remote show origin'
alias rls='git remote -v'
alias remoterm='git remote remove'
alias remoteren='git remote rename'
alias commit-count='git rev-list --count'
alias grm='rm -rf .git*'
alias git-remove='rm -rf .git*'
alias repo="gh repo"
alias merge="git merge"

gls() {
    if [[ $# -eq 1 ]]; then
        curl -s https://api.github.com/users/$1/repos | jq '.[]|["name: "+.name,"url: "+.html_url,"clone: "+.clone_url,"ssh: "+.ssh_url]'
    else
        echo "Usage: gls <github username>"
    fi
}

gio() {
    if [[ $# -eq 2 ]]; then
        curl https://git.io/ -i -F "url=$1" -F "code=$2"
    else
        echo "Usage: gio <url> <code>"
    fi
}

#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Terraform |---------------
#=========================================================================
alias fmt='terraform fmt'
alias validate='terraform validate'
alias plan='terraform plan'
alias apply='terraform apply'
alias state='terraform state'
alias show='terraform show'
alias tws='terraform workspace'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Vagrant |---------------
#=========================================================================
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

destroy() {
    if [ -e .vagrant ]; then
        vagrant destroy
    elif [ -e .terraform ]; then
        terraform destroy
    else
        echo "This action isn't allowed to run in this directory"
    fi
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Docker |---------------
#=========================================================================
alias dpsa='docker ps -a'
alias dps='docker ps'
alias dstart='docker start'
alias dsa='docker ps -aq | xargs docker stop'
alias dstop='docker stop'
alias drma='docker ps -aq | xargs docker rm -f'
alias drm='docker rm -f'
alias drmi='docker rmi -f'
alias drmia='docker images -aq | xargs docker rmi -f'
alias dit='docker exec -it'
alias dlogs='docker logs'
alias di='docker images'
alias dc='docker-compose'
alias dcupd='docker-compose up -d'
alias dcup='docker-compose up'
alias dcdown='docker-compose down'
alias dcbuild='docker-compose build'
alias dins='docker inspect'
alias dip="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Laravel |---------------
#=========================================================================
alias artisan='php artisan'
alias lara='composer create-project laravel/laravel'
alias env='php artisan env'
alias laraKey='php artisan key:generate'
alias mf='php artisan migrate:fresh'
alias mfs='php artisan migrate:fresh --seed'
alias mrf='php artisan migrate:refresh'
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
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Youtube download |---------------
#=========================================================================
alias ydl='cd ~/Downloads && youtube-dl -f bestvideo+bestaudio'
alias ydl-mp3='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format mp3'
alias ydl-m4a='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format m4a'
alias ydl-wav='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format wav'
alias ydl-aac='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format aac'
alias ydl-audio='cd ~/Downloads && youtube-dl --ignore-errors --output "%(title)s.%(ext)s" --extract-audio --audio-format best'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Nginx |---------------
#=========================================================================
alias nginxError='tail -n 100 /usr/local/var/log/nginx/error.log'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Markdown |---------------
#=========================================================================
alias toc='gh-md-toc'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Composer |---------------
#=========================================================================
alias autodump='composer dump-autoload'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------|  Others Function |---------------
#=========================================================================

# See all paths, one element per line. If an argument is supplied, grep fot it.
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

# URL encoding function taken from https://stackoverflow.com/a/10660730
function rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o

    for ((pos = 0; pos < strlen; pos++)); do
        c=${string:$pos:1}
        case "$c" in
        [-_.~a-zA-Z0-9]) o="${c}" ;;
        *) printf -v o '%%%02x' "'$c" ;;
        esac
        encoded+="${o}"
    done
    echo "${encoded}"  # You can either set a return variable (FASTER)
    REPLY="${encoded}" #+or echo the result (EASIER)... or both... :p
}

jenkinsvalid() {
    if [ -f $1 ]; then
        ssh jenkins java -jar jenkins-cli.jar -s http://jenkins.test:8080/ -auth @/home/naim/.jenkins_token declarative-linter <$1
    else
        echo "$1 doesn't exist!!"
    fi
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
