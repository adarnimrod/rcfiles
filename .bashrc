# shellcheck disable=SC2148
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LANG=en_US.UTF8
export HISTFILE="$HOME/.history"
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export REPREPRO_BASE_DIR="$HOME/Documents/Shore/debian-repository"
export EDITOR=vim
export GOPATH="$HOME/Documents/Golang"
export PATH="$GOPATH/bin:/usr/lib/go/bin/:$PATH"
export PATH="$HOME/Documents/Shore/ssh-ca:$PATH"
export PATH="$HOME/Documents/Shore/ssl-ca:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/Documents/bin:$PATH"
export PYTHONSTARTUP=~/.config/pythonrc/pythonrc.py
export AWS_DEFAULT_PROFILE='shore'
export ANSIBLE_VERBOSITY=2
export ANSIBLE_COMMAND_WARNINGS=True
export ANSIBLE_DEPRECATION_WARNINGS=True
export ANSIBLE_RETRY_FILES_SAVE_PATH=/tmp/
export ANSIBLE_SSH_PIPELINING=True
export ANSIBLE_GATHERING=smart
export ANSIBLE_CACHE_PLUGIN=jsonfile
export ANSIBLE_CACHE_PLUGIN_CONNECTION="$HOME/.ansible/facts"
export ANSIBLE_CALLBACK_WHITELIST=profile_tasks
export LYNX_SAVE_SPACE="$HOME/Downloads"
export LYNX_TEMP_SPACE="$HOME/.cache/lynx"
export VAGRANT_DEFAULT_PROVIDER="virtualbox"
# Blinking
export LESS_TERMCAP_mb=$'\E[01;31m'
# Double bright
export LESS_TERMCAP_md=$'\E[01;35m'
export LESS_TERMCAP_me=$'\E[0m'
# Standout
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
# Underline
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export PS0="\$(__prerun)"
# shellcheck disable=SC1117
export PS1="\[\$(__prompt)\]\u@\h:\w\$ "
export CDPATH="$HOME/Documents:$HOME/Documents/Shore"

alias ll='ls -lha'
alias la='ls -A'
alias l='ls -CF'
alias gcc='gcc --std=c99 -Wall -Wextra -Werror -pedantic'
alias dpkglog="grep -v 'status\\|trigproc\\|configure' /var/log/dpkg.log"
alias deborphan='deborphan -a --no-show-section --ignore-suggests'
alias aptitude='aptitude --display-format %p --quiet'
alias obsolete='aptitude search ?obsolete'
alias missing-recommends="aptitude search '~RBrecommends:~i'"
# shellcheck disable=SC2142
alias deinstalled="dpkg --get-selections | awk '\$2==\"deinstall\" {print \$1}'"
alias ansible-local='ansible localhost -c local -i localhost,'
alias ansible-local-playbook='ansible-playbook -i localhost, -c local'
alias concat="perl -pe 's/\\n/\\\\n/g'"
alias deconcat="perl -pe 's/\\\\n/\\n/g'"
alias ecr-login='eval $(aws ecr get-login --no-include-email)'
alias hostlocal='docker run --rm --privileged --net=host gliderlabs/hostlocal'
alias cadvisor='docker run --rm   --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=8080:8080 --detach=true --name=cadvisor google/cadvisor:latest'
alias __apt-daily="sudo /bin/sh -c 'apt-get update && apt-get dist-upgrade --download-only --yes && apt-get autoclean'"
alias apt-daily="monitor __apt-daily"
alias __flatpak-daily='sudo flatpak update --assumeyes'
alias flatpak-daily="monitor __flatpak-daily"
alias cdtemp='cd $(mktemp -d)'
alias 0-day-cleanup='ssh xbmc.shore.co.il "sudo -u debian-transmission find /srv/library/Comics -name *.part -path *0-Day\ Week\ of* -delete"'
alias httpbin='gunicorn httpbin:app'
alias update-requirements='find -name "*requirements*.txt" -exec pur --requirement {} \;'
alias restart-kodi='ssh xbmc.shore.co.il "sudo systemctl kill --kill-who=all --signal=9 xorg.service"'
alias __sync-podcasts='(cd && unison podcasts)'
alias sync-podcasts='monitor __sync-podcasts'
alias sync-comics='monitor __sync_comics'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'
# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
alias wifi-portal='curl --silent --fail --write-out "%{redirect_url}" --output /dev/null http://detectportal.firefox.com/success.txt'
alias transmission-remote='ssh -fNo ExitOnForwardFailure=yes xbmc.shore.co.il && transmission-remote'
alias kpcli='kpcli --kdb ~/Documents/Database.kdbx'
alias gen-mac="hexdump -n5 -e '\"02\" 5/1 \":%02X\" \"\\n\"' /dev/urandom"
alias clean-swp="find \$HOME/ -name '*.swp' -delete"
alias unssh="ssh -o \"UserKnownHostsFile /dev/null\" -o \"StrictHostKeyChecking no\""
alias todo="vim \$HOME/Documents/TODO.yml"
alias sudo="sudo "
alias git="git "
alias xargs="xargs "
alias presentation='docker dev adarnimrod/presentation'
alias prune_prerun='find "$HOME" -maxdepth 1 -name ".prerun\.[0-9]*" | grep -v "$(pgrep -u "$(id -u)" "$(basename "$SHELL" )" )" | xargs -r rm'
alias netdata='docker run --detach --name netdata --cap-add SYS_PTRACE --volume /proc:/host/proc:ro --volume /sys:/host/sys:ro --volume /var/run/docker.sock:/var/run/docker.sock --publish 19999:19999 firehol/netdata:alpine'
alias newman='docker run --rm -u "$(id -u):$(id -g)" -v "$PWD:/etc/newman" -t postman/newman_alpine33'
alias http-server='python3 -m http.server 8080'
alias dd='monitor sudo dd status=progress'
alias screenshot-cleanup='find "$HOME/Pictures" -name "Screenshot from *.png" -delete'
alias black='black --line-length 79'
alias torrent_off='ssh xbmc.shore.co.il sudo systemctl stop transmission-{rss,daemon}.service'
alias torrent_on='ssh xbmc.shore.co.il sudo systemctl start transmission-{daemon,rss}.service'
alias bell="printf '\\a'"
command -v notify-send > /dev/null || alias notify-send='bell'
alias __gcloud='docker run --rm -it -v "$HOME/.config/gcloud:/tmp/.config/gcloud" -e "HOME=/tmp" -u "$(id -u):$(id -g)" google/cloud-sdk:alpine'
alias gcloud='__gcloud gcloud'
alias gsutil='__gcloud gsutil'

monitor () {
    if eval "$@"
    then
        notify-send "$(basename "${1#__}") has finished."
    else
        notify-send --urgency=critical "$(basename "${1#__}") has failed."
    fi
}

jt () {
    if command -v pygmentize > /dev/null
    then
        python3 -m json.tool "$@" | pygmentize -l javascript
    else
        python3 -m json.tool "$@"
    fi
}

bold () {
    printf '\e[1m' || true
    echo "$@"
    printf '\e[0m' || true
}

red () {
    printf '\e[1;91m' || true
    echo "$@"
    printf '\e[0m' || true
}

green () {
    printf '\e[1;92m' || true
    echo "$@"
    printf '\e[0m' || true
}

yellow () {
    printf '\e[1;93m' || true
    echo "$@"
    printf '\e[0m' || true
}

blue () {
    printf '\e[1;94m' || true
    echo "$@"
    printf '\e[0m' || true
}

magenta () {
    printf '\e[1;95m' || true
    echo "$@"
    printf '\e[0m' || true
}

cyan () {
    printf '\e[1;96m' || true
    echo "$@"
    printf '\e[0m' || true
}

deduce_aws_region () {
    AWS_DEFAULT_REGION="$(python3 << EOF
from urllib.request import urlopen
import json
response = urlopen('http://169.254.169.254/latest/dynamic/instance-identity/document')
print(json.loads(response.read().decode('utf-8'))['region'])
EOF
    )"
    export AWS_DEFAULT_REGION
    echo "$AWS_DEFAULT_REGION"
}

ssh_keyscan_add () {
    ssh-keyscan "$@" >> "$HOME/.ssh/known_hosts"
    sort -uo "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts"
}

gen_csr () {
    openssl req -new -newkey rsa:4096 -nodes -out "$1.csr" -keyout "$1.key"
}

__sync_comics () {
    local this_month last_month format
    format='+xbmc.shore.co.il:/srv/library/Comics/0-Day\ Week\ of\ %Y.%m.*'
    this_month="$( date "$format" )"
    last_month="$( date --date '1 month ago' "$format" )"
    rsync --prune-empty-dirs --ignore-missing-args --recursive --compress --progress --exclude "*.part" "$last_month" "$this_month" "$HOME/Downloads/Comics/"
    find "$HOME/Downloads/Comics/" -name "$(date --date '2 month ago' +'0-Day\ Week\ of\ %Y.%m.*')" -exec rm -r {} +
}

ddg () {
    lynx "https://duckduckgo.com/lite/?q=$(urlencode "$@")"
}

toux () {
    touch "$@"
    chmod +x "$@"
}

match_ssl_pair () {
    if [ "$#" -ne 2 ]
    then
        echo "Usage: match_ssl_pair private_key certificate"
        return 1
    fi
    tempkey="$(mktemp)"
    tempcert="$(mktemp)"
    openssl pkey -pubout -outform PEM -in "$1" > "$tempkey"
    openssl x509 -pubkey -noout -in "$2" > "$tempcert"
    cmp "$tempkey" "$tempcert" > /dev/null
    exitcode="$?"
    rm "$tempkey" "$tempcert"
    return "$exitcode"
}

__run_duration () {
    if [ -f "$HOME/.prerun.$$" ]
    then
        local endtime starttime
        endtime="$(date +%s)"
        starttime="$(cat "$HOME/.prerun.$$")"
        rm "$HOME/.prerun.$$"
        echo "$(( endtime - starttime ))"
    else
        echo 0
    fi
}

__prerun () {
    date +%s > "$HOME/.prerun.$$"
}

__prompt () {
    local exitstatus="$?"
    local runduration prompt
    ! [ "$(type history 2> /dev/null)" = "history is a shell builtin" ] || history -a
    prompt=""
    [ ! -f "$HOME/.prerun.$$" ] || runduration="$(__run_duration)"
    [ "${runduration:-0}" -lt "10" ] || prompt="$(cyan -n "[Run duration: $runduration]") $prompt"
    [ -n "${runduration:-}" ] || exitstatus='0'
    [ "$exitstatus" = "0" ] || prompt="$(red -n "[Exit status: $exitstatus]") $prompt"
    echo "$prompt"
}

# shellcheck disable=SC1090
. "$HOME/Documents/Shore/bundle_certs/bundle_certs"

if [ -n "${BASH:-}" ]
then
    shopt -s checkwinsize
    shopt -s cmdhist
    # shellcheck disable=SC1091
    [ -f /etc/bash_completion ] && . /etc/bash_completion

    # shellcheck disable=SC1090
    for sourcefile in $HOME/.bash_completion.d/*
    do
        [ ! -f "$sourcefile" ] || . "$sourcefile"
    done
    ! command -v direnv > /dev/null || eval "$(direnv hook bash)"
fi


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip -color'
    alias less='less --raw-control-chars'
fi

prune_prerun
