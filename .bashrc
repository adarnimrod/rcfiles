# shellcheck disable=SC2148 shell=bash
# vim: ft=sh

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Source all of the files in ~/.bashrc.d
for sourcefile in "$HOME"/.bashrc.d/*
do
    if [ -f "$sourcefile" ] && [ "$sourcefile" = "${sourcefile%.j2}" ]
    then
        # shellcheck disable=SC1090
        . "$sourcefile"
    fi
done

export ANSIBLE_CACHE_PLUGIN=jsonfile
export ANSIBLE_CACHE_PLUGIN_CONNECTION="$HOME/.ansible/facts"
export ANSIBLE_CALLBACKS_ENABLED="ansible.posix.profile_tasks, ansible.posix.timer"
export ANSIBLE_DEPRECATION_WARNINGS=True
export ANSIBLE_FORKS=5
export ANSIBLE_GATHERING=smart
export ANSIBLE_INVENTORY_ANY_UNPARSED_IS_FAILED=True
export ANSIBLE_PIPELINING=True
export ANSIBLE_PYTHON_INTERPRETER=auto
export ANSIBLE_RETRY_FILES_SAVE_PATH=/tmp/
export ANSIBLE_SSH_CONTROL_PATH="/tmp/ssh-%%h"
export ANSIBLE_SYSTEM_WARNINGS=True
export ANSIBLE_VERBOSITY=2
export AWS_DEFAULT_PROFILE='shore'
if flatpak info org.mozilla.firefox >/dev/null 2>&1
then
    export BROWSER='flatpak run org.mozilla.firefox'
elif command -v w3m >/dev/null
then
    export BROWSER=w3m
fi
export CFLAGS="-g3 -Wall -Wextra -Wconversion -Wdouble-promotion -Wno-unused-parameter -Wno-unused-function -Wno-sign-conversion -fsanitize=undefined -fsanitize-trap"
export CLOUDSDK_ACTIVE_CONFIG_NAME='shore'
export EDITOR=vim
export GITLAB_BASE_URL='https://git.shore.co.il/api/v4'
export GITLAB_HOST='https://git.shore.co.il'
export GOPATH="$HOME/.local/golang"
export GOPRIVATE="*"
export HELM_HOME="$HOME/.helm"
export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=100000
export HISTSIZE=100000
export LANG=en_US.UTF8
# Blinking (red).
export LESS_TERMCAP_mb=$'\E[01;31m'
# Double bright (purple).
export LESS_TERMCAP_md=$'\E[01;35m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
# Standout (grey).
export LESS_TERMCAP_so=$'\E[01;33m'
export LESS_TERMCAP_ue=$'\E[0m'
# Underline (dark grey).
export LESS_TERMCAP_us=$'\E[01;32m'
export LYNX_SAVE_SPACE="$HOME/Downloads"
export LYNX_TEMP_SPACE="$HOME/.cache/lynx"
export MAKEFLAGS="-e -k -j4"
export PATH="$GOPATH/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/var/lib/flatpak/exports/bin:$PATH"
export PATH="$HOME/.local/share/flatpak/exports/bin:$PATH"
export PATH="$HOME/Documents/bin:$PATH"
export PATH="$HOME/Repositories/Shore/ssh-ca:$PATH"
export PATH="$HOME/Repositories/Shore/ssl-ca:$PATH"
export PGSSLROOTCERT=/etc/ssl/certs/ca-certificates.crt
export PS1='\u@\h:\w\$ '
export PYTHON_GITLAB_CFG=~/.config/python-gitlab.cfg
export REDISCLI_HISTFILE="$HOME/Documents/.rediscli_history"
export VAGRANT_DEFAULT_PROVIDER="virtualbox"

alias 0-day-cleanup='ssh kodi.shore.co.il "sudo -u debian-transmission find /srv/library/Comics -name *.part -path *0-Day\ Week\ of* -delete"'
alias all-hosts='echo -n ns1 ns4 host01 kodi mr8300 | xargs -d " " -I HOST ssh HOST.shore.co.il'
alias all-repos='find "$HOME/Repositories" -maxdepth 3 -type d -name .git -print0 | xargs -IX -0 git -C "X/../"'
alias ansible-local-playbook='ansible-playbook -i localhost, -c local -e "ansible_python_interpreter=$(which python3)"'
alias ansible-local='ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$(which python3)"'
alias aptitude='aptitude --display-format %p --quiet'
alias black='black --line-length 79'
alias cdtemp='cd "$(mktemp -d)"'
alias check_tcp='nc -vzw10'
alias check_unix='nc -Uvzw3'
alias clean-swp="find \$HOME/ -name '*.swp' -delete"
alias close='ssh -fnNTS ~/.ssh/%C.sock -O exit'
alias color='less --raw-control-chars -p'
alias concat="perl -pe 's/\\n/\\\\n/g'"
alias cphere='cp --target-directory=./'
alias dd='dd status=progress'
alias deborphan='deborphan -a --no-show-section --ignore-suggests'
alias deconcat="perl -pe 's/\\\\n/\\n/g'"
# shellcheck disable=SC2142
alias deinstalled="dpkg --get-selections | awk 'BEGIN {exitcode=1}; \$2==\"deinstall\" {print \$1; exitcode=0}; END {exit exitcode}'"
alias detectproxy='w3m http://detectportal.firefox.com/success.txt'
alias df='df --output=source,fstype,size,used,avail,pcent,iavail,ipcent,target'
alias diff='diff --unified'
alias dpkglog="grep -v 'status\\|trigproc\\|configure' /var/log/dpkg.log"
alias gen-mac='hexdump -n5 -e '\''"02" 5/1 ":%02X" "\n"'\'' /dev/urandom'
alias gen-ssh-config="rc_make .ssh/config"
alias hcl2json='json2hcl -reverse'
alias jjb='jenkins-jobs'
alias l='ls -F'
alias la='ls -AF'
alias lh='ls -lhAS'
alias listen_tcp='nc -vlk 0.0.0.0'
alias listen_udp='nc -uvlk 0.0.0.0'
alias listen_unix='nc -Uvlk'
alias ll='ls -lha'
alias lsblk='lsblk --output=NAME,RM,RO,SIZE,TYPE,FSTYPE,LABEL,UUID,MODEL,TRAN,MOUNTPOINT'
alias missing-recommends="aptitude search '~RBrecommends:~i'"
alias missing-suggests="aptitude search '~RBsuggests:~i'"
alias monitor="monitor "
alias mvhere='mv --target-directory=./'
# shellcheck disable=SC1004
alias nextcloudcmd='flatpak run --command=nextcloudcmd com.nextcloud.desktopclient.nextcloud'
# shellcheck disable=SC2139
alias notify="notify --hint \"string:desktop-entry:$(basename "${GIO_LAUNCHED_DESKTOP_FILE:-io.elementary.terminal.desktop}")\""
alias obsolete='apt list "~o"'
alias pre-commit-update-skel='pre-commit autoupdate --config ~/.config/git/skel/.pre-commit-config.yaml'
# shellcheck disable=SC2139
alias rc_make="make --directory $HOME --always-make"
alias rc_update="rc_make vendored generated"
alias restart-kodi='ssh kodi.shore.co.il "sudo systemctl kill --kill-who=all --signal=9 xorg.service"'
# shellcheck disable=SC2032
alias rm='rm --dir'
alias screenshot-cleanup='find "$HOME/Pictures" -name "Screenshot from *.png" -delete'
alias sudo="sudo "
alias sudome="sudome "
alias todo="vim \$HOME/Documents/TODO.yml"
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'
# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
alias transmission-remote='forward kodi.shore.co.il 9091:localhost:9091 && transmission-remote'
alias unscp="scp -o \"UserKnownHostsFile /dev/null\" -o \"StrictHostKeyChecking no\""
alias unsftp="sftp -o \"UserKnownHostsFile /dev/null\" -o \"StrictHostKeyChecking no\""
alias unssh="ssh -o \"UserKnownHostsFile /dev/null\" -o \"StrictHostKeyChecking no\""
alias update-requirements='find -name "*requirements*.txt" -exec pur --requirement {} \;'
alias utcnow='date --utc --iso-8601=seconds'
# shellcheck disable=SC2139
alias wbr="ssh -t ns4.shore.co.il $(command -v wb)"
alias wifi-portal='curl --silent --fail --write-out "%{redirect_url}" --output /dev/null http://detectportal.firefox.com/success.txt'
alias xargs="xargs "

ansible_all () {
    pushd ~/Repositories/Shore/homelab/Ansible || return
    ansible all "$@"
    # shellcheck disable=SC2164
    popd
}

bak () {
    for x in "$@"
    do
        cp --preserve=all --reflink=auto "$x" "${x}~"
    done
}

black8() {
    black "$@" && flake8 "$@"
}

container_name() {
    if [ -f /run/.containerenv ]
    then
        # shellcheck disable=SC1091
        ( . /run/.containerenv; echo "$name"; )
    else
        hostname -s
    fi
}

ddg () {
    w3m "https://lite.duckduckgo.com/lite/?q=$(echo "$@" | urlencode)"
}

genpass () {
    bytes="${1:-32}"
    head --bytes="$bytes" /dev/urandom | base64 --wrap=0
    echo
}

kodi_scan () {
    # shellcheck disable=SC1083
    ssh kodi.shore.co.il curl --silent --fail --show-error --json \'{\"jsonrpc\": \"2.0\", \"id\": \"transmission\", \"method\": \"VideoLibrary.Scan\"}\' http://127.0.0.1:8080/jsonrpc | jt
    # shellcheck disable=SC1083
    ssh kodi.shore.co.il curl --silent --fail --show-error --json \'{\"jsonrpc\": \"2.0\", \"id\": \"transmission\", \"method\": \"AudioLibrary.Scan\"}\' http://127.0.0.1:8080/jsonrpc | jt
}

mnt_lib () {
    mkdir -p "$HOME/Library"
    rclone mount \
        --daemon \
        --gid "$(id -g)" \
        --vfs-cache-mode full \
        --uid "$(id -u)" \
        library:/ \
        "$HOME/Library"
}

new_experiment () {
    if [ "$#" -ne 1 ]
    then
        echo 'Usage: new_experiment EXPERIMENT_NAME' >&2
        return 1
    fi
    local name="$1"
    local repo="$HOME/Repositories/Shore/experiments"
    if [ ! -d "$repo/.git" ]
    then
        git clone git@git.shore.co.il:nimrod/experiments.git "$repo"
    fi
    # shellcheck disable=SC2164
    cd "$repo"
    git checkout master
    git checkout -b "$name/master"
}

# shellcheck disable=SC2120
prune_ssh_sockets () {
    { [ "${1:-}" != '-f' ] && [ "${1:-}" != '--force' ]; } || killall -v ssh || true
    find ~/.ssh/ \
        -maxdepth 1 \
        -type s \
        \! -name 'cm_*.sock' \
        -execdir sh -c 'lsof -t "$1" >/dev/null || rm "$1"' _ {} \;
}

set_title () {
    local default_title
    default_title="$(basename "$PWD")"
    printf "\033]0;%s\007" "${1:-$default_title}"
}

ssh_keyscan_add () {
    ssh-keyscan "$@" >> "$HOME/.ssh/known_hosts"
    sort -uo "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts"
}

sync_comics () {
    local this_month last_month format
    format='+kodi.shore.co.il:/srv/library/Comics/0-Day\ Week\ of\ %Y.%m.*'
    this_month="$( date "$format" )"
    last_month="$( date --date '1 month ago' "$format" )"
    rsync --prune-empty-dirs --ignore-missing-args --recursive --compress --progress --exclude "*.part" "$last_month" "$this_month" "$HOME/Downloads/Comics/"
    # shellcheck disable=SC2033
    find "$HOME/Downloads/Comics/" -name "$(date --date '2 month ago' +'0-Day\ Week\ of\ %Y.%m.*')" -exec rm -r {} +
}

temp_venv () {
    cdtemp
    venv .
    # shellcheck disable=SC1090,SC1091
    . bin/activate
}

toux () {
    touch "$@"
    chmod +x "$@"
}

unescape () {
    echo "$@" | xargs
}

__prompt () {
    local exitstatus="$?"
    local runduration endtime pre_prompt
    ! [ "$(type history 2> /dev/null)" = 'history is a shell builtin' ] || history -a
    if [ -n "${starttime:-}" ]
    then
        endtime="$(date +%s)"
        runduration="$(( endtime - starttime))"
        pre_prompt=''
        [ "$exitstatus" -eq '0' ] || [ -z "${run_command:-}" ] || pre_prompt="$pre_prompt\\e[1;91m[Exit status: $exitstatus]\\e[0m "
        [ "$runduration" -lt '5' ] || pre_prompt="$pre_prompt\\e[1;96m[Run duration: $runduration]\\e[0m "
        [ -z "$pre_prompt" ] || echo -e "$pre_prompt"
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
                echo "$last_command has finished." | notify
            else
                echo "$last_command has failed." | notify --urgency=critical
            fi
        fi
    fi
    last_command="$BASH_COMMAND"
    last_finish="$(date +%s)"
    trap - debug
}

# shellcheck disable=SC1090,SC1091
. "$HOME/Repositories/Shore/bundle_certs/bundle_certs"


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]
then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias diff='diff --color=auto --unified'
    alias ip='ip -color'
    alias less='less --raw-control-chars'
fi

if [ -n "${BASH:-}" ]
then
    export CDPATH=".:$HOME"
    export CDPATH="$CDPATH:$HOME/Documents"
    export CDPATH="$CDPATH:$HOME/Repositories/Shore"
    export CDPATH="$CDPATH:$HOME/Repositories/nehesr"
    export CDPATH="$CDPATH:$HOME/Repositories/GitHub"
    export CDPATH="$CDPATH:$HOME/Repositories/SchooLinks"
    export CDPATH="$CDPATH:$HOME/Repositories"
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

# shellcheck disable=SC2119
prune_ssh_sockets
