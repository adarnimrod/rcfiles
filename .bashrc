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
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/bin:$PATH"
export PYTHONSTARTUP=~/.config/pythonrc.py
PIPENV_DEFAULT_PYTHON_VERSION="$(python3 --version | grep -i '3\.[0-9]*')" > /dev/null 2>&1
export PIPENV_DEFAULT_PYTHON_VERSION=
export AWS_DEFAULT_PROFILE='shore'
export ANSIBLE_VERBOSITY=2
export ANSIBLE_COMMAND_WARNINGS=True
export ANSIBLE_DEPRECATION_WARNINGS=True
export ANSIBLE_SYSTEM_WARNINGS=True
export ANSIBLE_RETRY_FILES_SAVE_PATH=/tmp/
export ANSIBLE_PIPELINING=True
export ANSIBLE_GATHERING=smart
export ANSIBLE_CACHE_PLUGIN=jsonfile
export ANSIBLE_CACHE_PLUGIN_CONNECTION="$HOME/.ansible/facts"
export ANSIBLE_CALLBACK_WHITELIST="profile_tasks, timer"
export ANSIBLE_SSH_CONTROL_PATH="/tmp/ssh-%%h"
export ANSIBLE_INVENTORY_ANY_UNPARSED_IS_FAILED=True
export LYNX_SAVE_SPACE="$HOME/Downloads"
export LYNX_TEMP_SPACE="$HOME/.cache/lynx"
export VAGRANT_DEFAULT_PROVIDER="virtualbox"
export PIPENV_MAX_DEPTH=5
# Blinking (red).
export LESS_TERMCAP_mb=$'\E[01;31m'
# Double bright (purple).
export LESS_TERMCAP_md=$'\E[01;35m'
export LESS_TERMCAP_me=$'\E[0m'
# Standout (grey).
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_se=$'\E[0m'
# Underline (dark grey).
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export HELM_HOME="$HOME/.helm"

alias ll='ls -lha'
alias la='ls -A'
alias l='ls -CF'
alias gcc='gcc --std=c99 -Wall -Wextra -Werror -pedantic'
alias dpkglog="grep -v 'status\\|trigproc\\|configure' /var/log/dpkg.log"
alias deborphan='deborphan -a --no-show-section --ignore-suggests'
alias aptitude='aptitude --display-format %p --quiet'
alias obsolete='aptitude search ?obsolete'
alias missing-recommends="aptitude search '~RBrecommends:~i'"
alias missing-suggests="aptitude search '~RBsuggests:~i'"
# shellcheck disable=SC2142
alias deinstalled="dpkg --get-selections | awk 'BEGIN {exitcode=1}; \$2==\"deinstall\" {print \$1; exitcode=0}; END {exit exitcode}'"
alias ansible-local='ansible localhost -c local -i localhost,'
alias ansible-local-playbook='ansible-playbook -i localhost, -c local'
alias concat="perl -pe 's/\\n/\\\\n/g'"
alias deconcat="perl -pe 's/\\\\n/\\n/g'"
alias hostlocal='docker run --rm --privileged --net=host gliderlabs/hostlocal'
alias cadvisor='docker run --rm   --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=8080:8080 --detach=true --name=cadvisor google/cadvisor:latest'
alias cdtemp='cd $(mktemp -d)'
alias 0-day-cleanup='ssh xbmc.shore.co.il "sudo -u debian-transmission find /srv/library/Comics -name *.part -path *0-Day\ Week\ of* -delete"'
alias httpbin='gunicorn httpbin:app'
alias update-requirements='find -name "*requirements*.txt" -exec pur --requirement {} \;'
alias restart-kodi='ssh xbmc.shore.co.il "sudo systemctl kill --kill-who=all --signal=9 xorg.service"'
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
alias monitor="monitor "
alias sudome="sudome "
alias presentation='docker dev adarnimrod/presentation'
alias netdata='docker run --detach --name netdata --cap-add SYS_PTRACE --volume /proc:/host/proc:ro --volume /sys:/host/sys:ro --volume /var/run/docker.sock:/var/run/docker.sock --publish 19999:19999 firehol/netdata:alpine'
alias newman='docker run --rm -u "$(id -u):$(id -g)" -v "$PWD:/etc/newman" -t postman/newman_alpine33'
alias http-server='python3 -m http.server 8080'
alias dd='dd status=progress'
alias screenshot-cleanup='find "$HOME/Pictures" -name "Screenshot from *.png" -delete'
alias black='black --line-length 79'
alias torrent_off='ssh xbmc.shore.co.il sudo systemctl stop transmission-{rss,daemon}.service'
alias torrent_on='ssh xbmc.shore.co.il sudo systemctl start transmission-{daemon,rss}.service'
alias bell="printf '\\a'"
command -v notify-send > /dev/null || alias notify-send='bell'
alias detectproxy='w3m http://detectportal.firefox.com/success.txt'
alias color='less --raw-control-chars -p'
alias pip2='python2 -m pip'
alias pip3='python3 -m pip'
# shellcheck disable=SC2139
alias rc_make="make --directory $HOME --always-make"
alias rc_update="rc_make vendored generated"
alias gen-ssh-config="rc_make .ssh/config"
alias bfg='java -jar $HOME/.local/share/bfg/bfg.jar'
alias prune_docker_remote='find ~/.ssh -maxdepth 1 -type s -name "docker_*" -delete'
alias close='ssh -fnNTS ~/.ssh/%C.sock -O exit'

genpass () {
    bytes="${1:-32}"
    head --bytes="$bytes" /dev/urandom | base64 --wrap=0
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

ssh_keyscan_add () {
    ssh-keyscan "$@" >> "$HOME/.ssh/known_hosts"
    sort -uo "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts"
}

gen_csr () {
    name="${1:-site}"
    openssl req -new -newkey rsa:4096 -nodes -out "$name.csr" -keyout "$name.key"
}

sync_comics () {
    local this_month last_month format
    format='+xbmc.shore.co.il:/srv/library/Comics/0-Day\ Week\ of\ %Y.%m.*'
    this_month="$( date "$format" )"
    last_month="$( date --date '1 month ago' "$format" )"
    rsync --prune-empty-dirs --ignore-missing-args --recursive --compress --progress --exclude "*.part" "$last_month" "$this_month" "$HOME/Downloads/Comics/"
    find "$HOME/Downloads/Comics/" -name "$(date --date '2 month ago' +'0-Day\ Week\ of\ %Y.%m.*')" -exec rm -r {} +
}

sync_podcasts () (
    cd || exit 1
    unison podcasts
)

ddg () {
    w3m "https://duckduckgo.com/lite/?q=$(echo "$@" | urlencode)"
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

__prompt () {
    local exitstatus="$?"
    local runduration endtime
    ! [ "$(type history 2> /dev/null)" = 'history is a shell builtin' ] || history -a
    PS1='\u@\h:\w\$ '
    if [ -n "${starttime:-}" ]
    then
        endtime="$(date +%s)"
        runduration="$(( endtime - starttime))"
        [ "$runduration" -lt '10' ] || PS1="\\[\\e[1;96m[Run duration: $runduration]\\e[0m\\] $PS1"
        [ "$exitstatus" -eq '0' ] || [ -z "${run_command:-}" ] || PS1="\\[\\e[1;91m[Exit status: $exitstatus]\\e[0m\\] $PS1"
        unset run_command
    fi
    last_command='__prompt'
    unset starttime
    trap __command_notifier debug
}

__command_notifier () {
    local exitstatus="$?"
    local runduration endtime
    endtime="$(date +%s)"
    if [ "${last_command:-}" = '__prompt' ]
    then
        starttime="$(date +%s)"
    elif [ -n "${last_finish:-}" ]
    then
        if [ "${last_command:-}" != '_direnv_hook' ]
        then
            run_command='1'
        fi
        runduration="$(( endtime - last_finish ))"
        if [ "$runduration" -gt '10' ]
        then
            if [ "$exitstatus" -eq '0' ]
            then
                notify-send "$last_command has finished."
            else
                notify-send --urgency=critical "$last_command has failed."
            fi
        fi
    fi
    last_command="$BASH_COMMAND"
    last_finish="$(date +%s)"
    trap - debug
}

# shellcheck disable=SC1090
. "$HOME/Documents/Shore/bundle_certs/bundle_certs"


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

if [ -n "${BASH:-}" ]
then
    export CDPATH="$HOME:$HOME/Documents:$HOME/Documents/Shore:$HOME/Documents/Endless"
    # shellcheck disable=SC2016
    export PROMPT_COMMAND='__prompt'
    shopt -s checkwinsize
    shopt -s cmdhist
    # shellcheck disable=SC1091
    [ -f /etc/bash_completion ] && . /etc/bash_completion

    # shellcheck disable=SC1090
    for sourcefile in "$HOME"/.bash_completion.d/*
    do
        [ ! -f "$sourcefile" ] || . "$sourcefile"
    done
    ! command -v direnv > /dev/null || eval "$(direnv hook bash)"
fi

prune_docker_remote
