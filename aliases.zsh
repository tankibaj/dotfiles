#=========================================================================
#      ---------------| Directories |---------------
#=========================================================================
alias ~="cd $HOME"
alias dotfiles="$HOME/.dotfiles"
alias doc="cd $HOME/documents"
alias dl="cd $HOME/downloads"
alias app="cd /applications"
alias site="cd $HOME/documents/workspace/sites"
alias snippets="cd $HOME/documents/workspace/snippets"
alias github="cd $HOME/documents/workspace/github"
alias gitlab="cd $HOME/documents/workspace/gitlab"
alias workspace="cd $HOME/documents/workspace"
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| List & Size |---------------
#=========================================================================
if [ -x "$(command -v exa)" ]; then
  alias ls='exa --long --group --icons --binary'
  alias ls.='exa --long --group --icons --binary --all'
  alias tree='exa --tree --icons'
  alias tree.='exa --tree --icons --all'
else
  alias ls='ls -lhF'
  alias ls.='ls -lhFa'
  alias tree='tree'
fi
alias tree-="tree"
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
alias subl="open -a /Applications/Sublime\ Text.app"
alias idea="open -a IntelliJ\ IDEA"
alias vsc='open -a /Applications/Visual\ Studio\ Code.app'
alias typora='open -a /Applications/Typora.app'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| File Editing |---------------
#=========================================================================
alias edit-aliases='open -a /Applications/Sublime\ Text.app ~/.dotfiles/aliases.zsh'
alias edit-zshrc='open -a /Applications/Sublime\ Text.app ~/.dotfiles/.zshrc'
alias edit-path='open -a /Applications/Sublime\ Text.app ~/.dotfiles/path.zsh'
alias edit-hosts='open -a /Applications/Sublime\ Text.app /etc/hosts'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Terminal |---------------
#=========================================================================
alias terminal-reload='source ~/.dotfiles/.zshrc'
alias vbrestart='sudo "/Library/Application Support/VirtualBox/LaunchDaemons/VirtualBoxStartup.sh" restart'

copyit() {
  cat $1 | pbcopy && echo 'Copied to clipboard'
}

# See all paths, one element per line. If an argument is supplied, grep fot it.
pathls() {
  test -n "$1" && {
    echo $PATH | perl -p -e "s/:/\n/g;" | grep -i "$1"
  } || {
    echo $PATH | perl -p -e "s/:/\n/g;"
  }
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| SSH |---------------
#=========================================================================
alias sshconfig="vim ~/.ssh/config"
alias sshclr='ssh-keygen -R'
alias ssh-host-ls="grep '^Host' $HOME/.ssh/config | sed 's/Host //' | sort -u"

# List all keys in ~/.ssh directory
ssh-id-ls() {
  for file in ~/.ssh/*.pub; do
    printf "%s %s\n" "$(ssh-keygen -lf "$file" | awk '{$1=""}1')" "$file"
  done | column -t | grep --color=auto "$line" || echo "$line"
}

# List added keys
ssh-add-ls() {
  while read -r line; do
    for file in ~/.ssh/*.pub; do
      printf "%s %s\n" "$(ssh-keygen -lf "$file" | awk '{$1=""}1')" "$file"
    done | column -t | grep --color=auto "$line" || echo "$line"
  done < <(ssh-add -l | awk '{print $2}')
}

# Add all private keys in ~/.ssh directory
alias ssh-add-all='grep -slR "PRIVATE" ~/.ssh/ | xargs ssh-add --apple-use-keychain'

rcp() {
  if [[ $# -eq 2 ]]; then
    rsync -avzh --stats --progress $1 $2
  else
    echo "Usage: rcp <source> <destination>"
  fi
}

rdl() {
  if [[ $# -eq 1 ]]; then
    rsync -avzh --stats --progress $1 ~/downloads
  else
    echo "Usage: rdl <source>"
  fi
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

listening() {
  if [ $# -eq 0 ]; then
    sudo lsof -i -P | grep LISTEN
  elif [ $# -eq 1 ]; then
    sudo lsof -i -P | grep LISTEN | grep -i --color=auto $1
  else
    echo "Usage: listening [port/appname]"
  fi
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Git |---------------
#=========================================================================
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
alias tinit='terraform init'
alias fmt='terraform fmt'
alias validate='terraform validate'
alias plan='terraform fmt && terraform validate && terraform plan'
alias apply='terraform apply'
alias output='terraform output'
alias state='terraform state'
alias show='terraform show'
alias tws='terraform workspace'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Kubernetes |---------------
#=========================================================================
alias kctl='kubectl'
alias k='kubectl'
alias kx='kubectx'
alias kns='kubens'
klogs() {
  if [[ $# -eq 2 ]]; then
    kubectl logs -f -n $1 $(kubectl get po -n $1 | egrep -o "$2[a-zA-Z0-9-]+")
  else
    echo "Usage: klogs <namespace> <pod prefix>"
    echo "Example: klogs <kube-system> <aws-load-balancer-controller>"
  fi
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Vagrant |---------------
#=========================================================================
alias vssh="vagrant ssh"
alias up="vagrant up"
alias suspend="vagrant suspend"
alias resume="vagrant resume"
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
alias dls='docker container list --all --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
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
#      ---------------| Youtube download |---------------
#=========================================================================
ydl() {
  if [ $# = 2 ]; then
    path='$HOME/Downloads/%(title)s-%(id)s.%(ext)s'
    # path='%(title)s.%(ext)s'
    back="&& cd -"
    case $1 in
    mp3) youtube-dl --ignore-errors --output $path --extract-audio --audio-format mp3 $2 ;;
    m4a) youtube-dl --ignore-errors --output $path --extract-audio --audio-format m4a $2 ;;
    wav) youtube-dl --ignore-errors --output $path --extract-audio --audio-format wav $2 ;;
    aac) youtube-dl --ignore-errors --output $path --extract-audio --audio-format aac $2 ;;
    audio) youtube-dl --ignore-errors --output $path --extract-audio --audio-format best $2 ;;
    video) youtube-dl -f bestvideo+bestaudio --output $path $2 ;;
    playlist) youtube-dl -f bestvideo+bestaudio --yes-playlist --output $path $2 ;;
    *) echo "Usage: ydl audio url" ;;
    esac
  else

    local -r flagsTable=$(
      printf "%s\n" \
        "ydl video youtube-url      Download audio and video with best quality" \
        "ydl audio youtube-url      Download only audio" \
        "ydl playlist youtube-url   Download playlist" \
        "ydl mp3 youtube-url        Download only audio in mp3 format" \
        "ydl m4a youtube-url        Download only audio in m4a format" \
        "ydl wav youtube-url        Download only audio in wav format" \
        "ydl aac youtube-url        Download only audio in aac format"

    )
    echo -e "$flagsTable"
  fi
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Markdown |---------------
#=========================================================================
alias toc='gh-md-toc'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
