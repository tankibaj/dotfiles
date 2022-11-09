#=========================================================================
#      ---------------| Directories |---------------
#=========================================================================
alias ~="cd $HOME"
alias dotfiles="$HOME/.dotfiles"

if [[ "$(uname -s)" == "Linux" ]]; then
  alias workspace='cd ~/workspace'
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  alias doc="cd $HOME/documents"
  alias dl="cd $HOME/downloads"
  alias app="cd /applications"
  alias workspace="cd $HOME/documents/workspace"
  alias site="cd $HOME/documents/workspace/sites"
  alias snippets="cd $HOME/documents/workspace/snippets"
  alias repos="cd $HOME/repos"
  alias github="cd $HOME/repos/github"
  alias gitlab="cd $HOME/repos/gitlab"
  alias gitlab="cd $HOME/repos/gitea"
fi
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
#      ---------------| rsync |---------------
#=========================================================================
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
    sudo lsof -nP -iTCP -sTCP:LISTEN
  elif [ $# -eq 1 ]; then
    sudo lsof -nP -iTCP -sTCP:LISTEN | grep -i --color=auto $1
  else
    echo "Usage: listening [port/appname]"
  fi
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Git |---------------
#=========================================================================
if [ -x "$(command -v git)" ]; then
  alias clone='git clone'
  alias add='git add .'
  alias commit='git commit -m'
  alias status='git status'
  alias log='git log'
  alias push='git push -u'
  alias pull='git pull'
  alias nah='git reset --hard && git clean -df'
  alias nahto='git reset --hard'
  alias nahtomain='git fetch --all && git reset --hard origin/main'
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
fi

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
if [ -x "$(command -v terraform)" ]; then
  alias tinit='terraform init'
  alias fmt='terraform fmt'
  alias validate='terraform validate'
  alias plan='terraform fmt && terraform validate && terraform plan'
  alias apply='terraform apply'
  alias output='terraform output'
  alias state='terraform state'
  alias show='terraform show'
  alias tws='terraform workspace'
fi
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Kubernetes |---------------
#=========================================================================
if [ -x "$(command -v kubectl)" ]; then
  alias kctl='kubectl'
  alias k='kubectl'
  alias pod-lens='kubectl pod-lens'
  alias node-shell='kubectl node-shell'
  alias open-svc='kubectl open-svc'
  alias watch-all="watch kubectl get all,ing,pvc $@"
  alias watch-pod="watch kubectl get pod $@"
  alias watch-pv="watch kubectl get pv,pvc $@"
  alias watch-ing="watch kubectl get ing $@"
  alias get-all="kubectl get all,pvc,ing,secret,cm $@"
  alias get-events="kubectl get events --sort-by='.metadata.managedFields[0].time'"
  alias get-pod="kubectl get pod $@"
  alias get-pv="kubectl get pv $@"
  alias get-pvc="kubectl get pvc $@"
  alias get-ing="kubectl get ing $@"
  alias get-secret="kubectl get secret $@"
  alias get-cmap="kubectl get cm $@"
fi

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
if [ -x "$(command -v vagrant)" ]; then
  alias vssh="vagrant ssh"
  alias vup="vagrant up"
  alias vsuspend="vagrant suspend"
  alias vresume="vagrant resume"
  alias vreload="vagrant reload"
  alias reloadp="vagrant reload --provision"
  alias vhalt="vagrant halt"
  alias globalstatus="vagrant global-status"
  alias box-list='vagrant box list'
  alias box-remove='vagrant box remove'
  alias box-add='vagrant box add'
fi

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
if [ -x "$(command -v docker)" ]; then
  alias dls='docker container list --all --format "table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
  alias dps="docker ps --all --format 'table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}\t{{.Ports}}'"
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
fi
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

#=========================================================================
#      ---------------| Archive |---------------
#=========================================================================
# Extract archive
extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar) tar xf $1 ;;
    *.tar.bz2) tar xjvf $1 ;;
    *.tar.gz) tar xzvf $1 ;;
    *.tar.xz) tar xvf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.gz) gunzip $1 ;;
    *.zip) unzip $1 ;;
    *) echo "'$1' cannot be extracted with this method!!!" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Linux |---------------
#=========================================================================
# Manage Package
if [ -x "$(command -v apt)" ]; then
  alias update='sudo apt update'
  alias upgrade='sudo apt dist-upgrade'
  alias install='sudo apt install'
  alias autoremove='sudo apt autoremove'
fi

# Systemctl
if [ -x "$(command -v systemctl)" ]; then
  alias ctlrestart='sudo systemctl restart'    # Start or restart one or more units
  alias ctlstatus='sudo systemctl status'      # Show runtime status of one or more units
  alias ctlstop='sudo systemctl stop'          # Stop (deactivate) one or more units
  alias ctlstart='sudo systemctl start'        # Start (activate) one or more units
  alias ctlreload='sudo systemctl reload'      # Reload one or more units
  alias ctlenable='sudo systemctl enable'      # Enable one or more unit files
  alias ctldisable='sudo systemctl disable'    # Disable one or more unit files
  alias ctlkill='sudo systemctl kill'          # Send signal to processes of a unit
  alias ctlclean='sudo systemctl clean'        # Clean runtime, cache, state, logs or configuration of unit
  alias ctlisactive='sudo systemctl is-active' # Check whether units are active
  alias ctlisfailed='sudo systemctl is-failed' # Check whether units are failed
fi

# Basic functions
ips() {
  if [[ $(ip -4 addr | grep inet | grep -vEc '127(\.[0-9]{1,3}){3}') -eq 1 ]]; then
    echo
    ip -4 addr | grep -w inet | grep -vE '127(\.[0-9]{1,3}){3}' | awk '{ print "\033[0;31m"$7"\033[0m"": ""\033[0;33m"$2"\033[0m"}'
  else
    echo
    ip -4 addr | grep -w inet | grep -vE '127(\.[0-9]{1,3}){3}' | awk '{ print "\033[0;31m"$7"\033[0m"": ""\033[0;33m"$2"\033[0m"}' | nl -s '| '
  fi
}

# Cloud-init
alias cloud-init-output='less +F /var/log/cloud-init-output.log'
alias cloud-init-status='sudo cloud-init status --wait --long'
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]

#=========================================================================
#      ---------------| Libvirt |---------------
#=========================================================================
if [ -x "$(command -v virsh)" ]; then
  alias vls='sudo virsh list --all'
  alias vlssnap='sudo virsh snapshot-list'
  alias vlspool='sudo virsh pool-list'
  alias vlsnet='sudo virsh net-list'
  alias vlsvol='sudo virsh vol-list'
  alias vinfo='sudo virsh dominfo'
  alias vshutdown='sudo virsh shutdown'
  alias vstart='sudo virsh start'
  alias vautostart='sudo virsh autostart'
  alias vreboot='sudo virsh reboot'
  alias vreset='sudo virsh reset'
  alias vcreate='sudo virsh create'
  alias vdump='sudo virsh dumpxml'
  alias vedit='sudo virsh edit'
fi

# Delte KVM instance
vDestroy() {
  if [ -z $1 ]; then
    echo "Instance name required!!"
  fi
  sudo virsh shutdown $1
  sudo virsh destroy $1
  sudo virsh undefine $1
  sudo rm -rfv /var/lib/libvirt/pool/default/$1.qcow2
  if [ -f /var/lib/libvirt/images/$1-seed.qcow2 ]; then
    sudo rm -rfv /var/lib/libvirt/images/$1-seed.qcow2
  fi
}

# Create KVM Screenshot
vCreateScreenshot() {
  if [ -z $1 ]; then
    echo "Instance name required!!"
  fi
  if [ -z $2 ]; then
    echo "Screenshot name required!!"
  fi
  sudo virsh snapshot-create-as --domain $1 --name $2 --description $2
}

# Revert KVM Screenshot
vRevertScreenshot() {
  if [ -z $1 ]; then
    echo "Instance name required!!"
  fi
  if [ -z $2 ]; then
    echo "Screenshot name required!!"
  fi
  sudo virsh snapshot-revert --domain $1 --snapshotname $2 --running
}

# Delte KVM Screenshot
vDeleteScreenshot() {
  if [ -z $1 ]; then
    echo "Instance name required!!"
  fi
  if [ -z $2 ]; then
    echo "Screenshot name required!!"
  fi
  sudo virsh snapshot-delete --domain $1 --snapshotname $2
}
#[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]
