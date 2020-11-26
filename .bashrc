# shellcheck disable=SC2148 shell=bash
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export ANSIBLE_CACHE_PLUGIN=jsonfile
export ANSIBLE_CACHE_PLUGIN_CONNECTION="$HOME/.ansible/facts"
export ANSIBLE_CALLBACK_WHITELIST="profile_tasks, timer"
export ANSIBLE_COMMAND_WARNINGS=True
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
export CLOUDSDK_ACTIVE_CONFIG_NAME='shore'
export DOCKER_BUILDKIT=1
export EDITOR=vim
export GNUPGHOME="$HOME/Documents/.gnupg"
export GOPATH="$HOME/.local/golang"
export HELM_HOME="$HOME/.helm"
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE="$HOME/Documents/.history"
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
export PATH="$GOPATH/bin:/usr/lib/go/bin/:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/Documents/bin:$PATH"
export PATH="$HOME/Repositories/Shore/ssh-ca:$PATH"
export PATH="$HOME/Repositories/Shore/ssl-ca:$PATH"
export PGSSLROOTCERT=/etc/ssl/certs/ca-certificates.crt
PIPENV_DEFAULT_PYTHON_VERSION="$(python3 --version | grep -i '3\.[0-9]*')" > /dev/null 2>&1
export PIPENV_DEFAULT_PYTHON_VERSION
export PIPENV_MAX_DEPTH=5
export PS1='\u@\h:\w\$ '
export PYTHONSTARTUP=~/.config/pythonrc.py
export REDISCLI_HISTFILE="$HOME/Documents/.rediscli_history"
export VAGRANT_DEFAULT_PROVIDER="virtualbox"

alias 0-day-cleanup='ssh kodi.shore.co.il "sudo -u debian-transmission find /srv/library/Comics -name *.part -path *0-Day\ Week\ of* -delete"'
alias ansible-local-playbook='ansible-playbook -i localhost, -c local -e "ansible_python_interpreter=$(which python3)"'
alias ansible-local='ansible localhost -c local -i localhost, -e "ansible_python_interpreter=$(which python3)"'
alias aptitude='aptitude --display-format %p --quiet'
alias bell="printf '\\a'"
alias bfg='java -jar $HOME/.local/share/bfg/bfg.jar'
alias black='black --line-length 79'
alias cadvisor='docker run --rm   --volume=/:/rootfs:ro --volume=/var/run:/var/run:rw --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=8080:8080 --detach=true --name=cadvisor google/cadvisor:latest'
alias cdtemp='cd $(mktemp -d)'
alias check_tcp='nc -vzw10'
alias check_unix='nc -Uvzw3'
alias clean-swp="find \$HOME/ -name '*.swp' -delete"
alias close='ssh -fnNTS ~/.ssh/%C.sock -O exit'
alias color='less --raw-control-chars -p'
alias concat="perl -pe 's/\\n/\\\\n/g'"
alias dd='dd status=progress'
alias deborphan='deborphan -a --no-show-section --ignore-suggests'
alias deconcat="perl -pe 's/\\\\n/\\n/g'"
# shellcheck disable=SC2142
alias deinstalled="dpkg --get-selections | awk 'BEGIN {exitcode=1}; \$2==\"deinstall\" {print \$1; exitcode=0}; END {exit exitcode}'"
alias detectproxy='w3m http://detectportal.firefox.com/success.txt'
alias diff='diff --unified'
alias dpkglog="grep -v 'status\\|trigproc\\|configure' /var/log/dpkg.log"
alias gcc='gcc --std=c99 -Wall -Wextra -Werror -pedantic'
alias gen-mac='hexdump -n5 -e '\''"02" 5/1 ":%02X" "\n"'\'' /dev/urandom'
alias gen-ssh-config="rc_make .ssh/config"
alias hostlocal='docker run --rm --privileged --net=host gliderlabs/hostlocal'
alias http-server='python3 -m http.server 8080'
alias httpbin='gunicorn httpbin:app --bind 0.0.0.0:8080'
alias jjb='jenkins-jobs'
alias kpcli='kpcli --kdb ~/Documents/Database.kdbx'
alias l='ls -F'
alias la='ls -AF'
alias listen_tcp='nc -vlk 0.0.0.0'
alias listen_udp='nc -uvlk 0.0.0.0'
alias listen_unix='nc -Uvlk'
alias ll='ls -lha'
alias lsblk='lsblk --output=NAME,RM,RO,SIZE,TYPE,FSTYPE,LABEL,UUID,MODEL,TRAN,MOUNTPOINT'
alias missing-recommends="aptitude search '~RBrecommends:~i'"
alias missing-suggests="aptitude search '~RBsuggests:~i'"
alias monitor="monitor "
# shellcheck disable=SC1004
alias netdata='docker run --detach \
                          --name netdata \
                          --cap-add SYS_PTRACE \
                          --volume netdatalib:/var/lib/netdata \
                          --volume netdatacache:/var/cache/netdata \
                          --volume /etc/os-release:/host/etc/os-release:ro \
                          --volume /etc/passwd:/host/etc/passwd:ro \
                          --volume /etc/group:/host/etc/group:ro \
                          --volume /proc:/host/proc:ro \
                          --volume /sys:/host/sys:ro \
                          --volume /var/run/docker.sock:/var/run/docker.sock \
                          --publish 19999:19999 \
                          --security-opt apparmor=unconfined \
                          netdata/netdata'
alias newman='docker run --rm -u "$(id -u):$(id -g)" -v "$PWD:/etc/newman" -t postman/newman_alpine33'
alias nextcloudcmd='flatpak run --command=nextcloudcmd org.nextcloud.Nextcloud'
# shellcheck disable=SC2139
alias notify="notify --hint \"string:desktop-entry:$(basename "${GIO_LAUNCHED_DESKTOP_FILE:-io.elementary.terminal.desktop}")\""
alias obsolete='aptitude search ?obsolete'
alias pip2='python2 -m pip'
alias pip3='python3 -m pip'
alias presentation='docker dev adarnimrod/presentation'
# shellcheck disable=SC2139
alias rc_make="make --directory $HOME --always-make"
alias rc_update="rc_make vendored generated"
alias restart-kodi='ssh kodi.shore.co.il "sudo systemctl kill --kill-who=all --signal=9 xorg.service"'
# shellcheck disable=SC2032
alias rm='rm --dir'
alias screenshot-cleanup='find "$HOME/Pictures" -name "Screenshot from *.png" -delete'
alias smtp-server='python3 -m smtpd -ndc DebuggingServer'
alias sudo="sudo "
alias sudome="sudome "
alias tfa='terraform apply tfplan'
alias tfvf='tfv && terraform fmt -diff'
alias todo="vim \$HOME/Documents/TODO.yml"
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'
alias torrent_off='ssh kodi.shore.co.il sudo systemctl stop transmission-{rss,daemon}.service'
alias torrent_on='ssh kodi.shore.co.il sudo systemctl start transmission-{daemon,rss}.service'
# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
alias transmission-remote='forward kodi.shore.co.il 9091:localhost:9091 && transmission-remote'
alias unssh="ssh -o \"UserKnownHostsFile /dev/null\" -o \"StrictHostKeyChecking no\""
alias update-requirements='find -name "*requirements*.txt" -exec pur --requirement {} \;'
alias wb="ssh -t workbench.shore.co.il 'if tmux ls >/dev/null 2>&1; then tmux a; else tmux; fi;'"
alias wifi-portal='curl --silent --fail --write-out "%{redirect_url}" --output /dev/null http://detectportal.firefox.com/success.txt'
alias xargs="xargs "

blue () {
    printf '\e[1;94m' || true
    echo "$@"
    printf '\e[0m' || true
}

bold () {
    printf '\e[1m' || true
    echo "$@"
    printf '\e[0m' || true
}

cyan () {
    printf '\e[1;96m' || true
    echo "$@"
    printf '\e[0m' || true
}

ddg () {
    w3m "https://duckduckgo.com/lite/?q=$(echo "$@" | urlencode)"
}

genpass () {
    bytes="${1:-32}"
    head --bytes="$bytes" /dev/urandom | base64 --wrap=0
    echo
}

gen_csr () {
    name="${1:-site}"
    openssl req -new -newkey rsa:4096 -nodes -out "$name.csr" -keyout "$name.key"
}

green () {
    printf '\e[1;92m' || true
    echo "$@"
    printf '\e[0m' || true
}

jt () {
    if command -v pygmentize > /dev/null
    then
        python3 -m json.tool "$@" | pygmentize -l javascript
    else
        python3 -m json.tool "$@"
    fi
}

magenta () {
    printf '\e[1;95m' || true
    echo "$@"
    printf '\e[0m' || true
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

# shellcheck disable=SC2120
prune_ssh_sockets () {
    { [ "${1:-}" != '-f' ] && [ "${1:-}" != '--force' ]; } || killall -v ssh || true
    find ~/.ssh/ \
        -maxdepth 1 \
        -type s \
        \! -name 'cm_*.sock' \
        -execdir sh -c 'lsof -t "$1" >/dev/null || rm "$1"' _ {} \;
}

red () {
    printf '\e[1;91m' || true
    echo "$@"
    printf '\e[0m' || true
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

sync_podcasts () (
    cd || exit 1
    unison podcasts
)

tfaa () {
    workspace="$(terraform workspace show)"
    if [ "$workspace" = "default" ] || [ ! -f "$workspace.tfvars" ]
    then
        terraform apply -auto-approve "$@"
    else
        terraform apply -auto-approve -var-file "$workspace.tfvars" "$@"
    fi
}

tfi () {
    workspace="$(terraform workspace show)"
    if [ "$workspace" = "default" ] || [ ! -f "$workspace.tfvars" ]
    then
        terraform import "$@"
    else
        terraform import -var-file "$workspace.tfvars" "$@"
    fi
}

tfp () {
    workspace="$(terraform workspace show)"
    if [ "$workspace" = "default" ] || [ ! -f "$workspace.tfvars" ]
    then
        terraform plan -out tfplan "$@"
    else
        terraform plan -out tfplan -var-file "$workspace.tfvars" "$@"
    fi
}

tfr () {
    workspace="$(terraform workspace show)"
    if [ "$workspace" = "default" ] || [ ! -f "$workspace.tfvars" ]
    then
        terraform refresh "$@"
    else
        terraform refresh -var-file "$workspace.tfvars" "$@"
    fi
}

tfv () {
    workspace="$(terraform workspace show)"
    if [ "$workspace" = "default" ] || [ ! -f "$workspace.tfvars" ]
    then
        terraform validate "$@"
    else
        terraform validate -var-file "$workspace.tfvars" "$@"
    fi
}

toux () {
    touch "$@"
    chmod +x "$@"
}

yellow () {
    printf '\e[1;93m' || true
    echo "$@"
    printf '\e[0m' || true
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

# shellcheck disable=SC1090
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
    export CDPATH=".:$HOME:$HOME/Documents:$HOME/Documents/Shore:$HOME/Repositories/Shore:$HOME/Repositories/Endless:$HOME/Documents/Endless"
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
