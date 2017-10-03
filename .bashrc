# shellcheck disable=SC2148,SC1091
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LANG=en_US.UTF8
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
if [ -n "${BASH:-}" ]
then
    shopt -s histappend
    shopt -s checkwinsize
    shopt -s cmdhist
    [ -f /etc/bash_completion ] && . /etc/bash_completion

    # shellcheck disable=SC1090
    for sourcefile in $HOME/.bash_completion.d/*
    do
        [ ! -f "$sourcefile" ] || . "$sourcefile"
    done

    # shellcheck disable=SC1090
    # added by travis gem
    [ -f "$HOME/.travis/travis.sh" ] && . "$HOME/.travis/travis.sh"

    # shellcheck disable=SC2015
    which aws_completer >/dev/null && complete -C 'aws_completer' aws ||
        true
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# shellcheck disable=SC2142
[ -f /usr/local/bin/virtualenvwrapper.sh ] && . /usr/local/bin/virtualenvwrapper.sh

if which powerline-daemon > /dev/null && [ -f /usr/share/powerline/bindings/bash/powerline.sh ]
then
    export POWERLINE_BASH_CONTINUATION=1
    export POWERLINE_BASH_SELECT=1
    pgrep -f powerline-daemon > /dev/null || powerline-daemon -q
    . /usr/share/powerline/bindings/bash/powerline.sh
fi

export REPREPRO_BASE_DIR="$HOME/Documents/Shore/debian-repository"
export EDITOR=vim
export GOPATH="$HOME/Documents/Golang"
export PATH="$GOPATH/bin:/usr/lib/go/bin/:$PATH"
export PATH="$HOME/Documents/Shore/ssh-ca:$PATH"
export PATH="$HOME/Documents/Shore/ssl-ca:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cabal/bin:$PATH"
export PATH="$HOME/Documents/bin:$PATH"
export PYTHONSTARTUP=~/.pythonstartup
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
alias ll='ls -lha'
alias la='ls -A'
alias l='ls -CF'
alias gcc='gcc --std=c99 -Wall -Wextra -Werror -pedantic'
alias dpkglog="grep -v 'status\|trigproc\|configure' /var/log/dpkg.log"
alias deborphan='deborphan -a --no-show-section --ignore-suggests'
alias aptitude='aptitude --display-format %p --quiet'
alias obsolete='aptitude search ?obsolete'
alias missing-recommends="aptitude search '~RBrecommends:~i'"
# shellcheck disable=SC2142
alias deinstalled="dpkg --get-selections | awk '\$2==\"deinstall\" {print \$1}'"
alias ansible-local='ansible localhost -c local -i localhost,'
alias ansible-local-playbook='ansible-playbook -i localhost, -c local'
alias concat="perl -pe 's/\n/\\\n/g'"
alias deconcat="perl -pe 's/\\\n/\n/g'"
alias ggo='sudo GOPATH=/usr/share/go go'
alias ecr-login='eval $(aws ecr get-login)'
alias hostlocal='docker run --rm --privileged --net=host gliderlabs/hostlocal'
alias apt-daily="sudo /bin/sh -c 'apt-get update && apt-get dist-upgrade --download-only --yes && apt-get autoclean && flatpak update --no-deploy' && flatpak --user update --no-deploy"
alias docker-build='docker build -t "$(basename $PWD)" ./'
alias cdtemp='cd $(mktemp -d)'
alias 0-day-cleanup='ssh xbmc.shore.co.il "sudo -u debian-transmission find /srv/library/Comics -name *.part -path *0-Day\ Week\ of* -delete"'
alias httpbin='tox -c $HOME/.tox.ini.httpbin --'
alias update-requirements='find -name "*requirements*.txt" -exec pur --requirement {} \;'
alias restart-kodi='ssh xbmc.shore.co.il "sudo systemctl kill --kill-who all xorg.service"'
alias sync-podcasts='(cd && unison podcasts)'
# shellcheck disable=SC2142
alias tolower='awk "{print tolower(\$0)}"'
# shellcheck disable=SC2142
alias toupper='awk "{print toupper(\$0)}"'
alias wifi-portal='curl --silent --fail --write-out "%{redirect_url}" --output /dev/null http://detectportal.firefox.com/success.txt'
alias urlencode='perl -MURI::Escape -ne "chomp;print uri_escape(\$_), \"\n\""'
alias urldecode='perl -MURI::Escape -ne "chomp;print uri_unescape(\$_), \"\n\""'
alias transmission-remote='ssh -fNo ExitOnForwardFailure=yes xbmc.shore.co.il && transmission-remote'
alias kpcli='kpcli --kdb ~/Documents/Database.kdbx'
alias gen-mac="hexdump -n5 -e '\"02\" 5/1 \":%02X\" \"\\n\"' /dev/urandom"
alias clean-swp="find \$HOME/ -name '*.swp' -delete"
alias boxssh="ssh -i \$HOME/.ssh/bullguard-box_rsa -l root -p 64222"
alias todo="vim \$HOME/Documents/TODO.yml"

deduce_aws_region () {
    AWS_DEFAULT_REGION="$(python << EOF
from __future__ import print_function
try:
    from urllib import urlopen
except ImportError:
    from urllib.request import urlopen
import json
print(json.load(urlopen('http://169.254.169.254/latest/dynamic/instance-identity/document'))['region'])
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

docker_dev () {
    local root repo uid
    root="$(git rev-parse --show-toplevel)"
    repo="$(basename "$root")"
    uid="$(id -u)"
    docker build -t "$repo:dev" "$root"
    docker run --interactive \
               --publish-all \
               --name "$repo" \
               --rm \
               --tty \
               --volume "$HOME:$HOME" \
               --volume "$root:$root" \
               --user "$uid" \
               --workdir "$PWD" "$repo:dev" /bin/sh -l
}

sync_comics () {
    local this_month last_month format
    format='+xbmc.shore.co.il:/srv/library/Comics/0-Day\ Week\ of\ %Y.%m.*'
    this_month="$( date "$format" )"
    last_month="$( date --date '1 month ago' "$format" )"
    rsync --prune-empty-dirs --ignore-missing-args --recursive --compress --progress --exclude "*.part" "$last_month" "$this_month" "$HOME/Downloads/Comics/"
    find "$HOME/Downloads/Comics/" -name "$(date --date '2 month ago' +'0-Day\ Week\ of\ %Y.%m.*')" -exec rm -r {} +
}

bfg () {
    [ -f "$HOME/Downloads/bfg.jar" ] || curl 'https://search.maven.org/remote_content?g=com.madgag&a=bfg&v=LATEST' -sLo "$HOME/Downloads/bfg.jar"
    java -jar "$HOME/Downloads/bfg.jar" "$@"
}

ddg () {
    lynx "https://duckduckgo.com/lite/?q=$(echo "$@" | urlencode)"
}

bump () {
    semver-bump "$1-release" && \
    git commit VERSION -m"- Bumped $1 version." && \
    git tag-version
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

# shellcheck disable=SC1090
. "$HOME/Documents/Shore/bundle_certs/bundle_certs"
