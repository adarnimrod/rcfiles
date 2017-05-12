# shellcheck disable=SC2148,SC1091
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LANG=en_US.UTF8
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
if [ -n "$BASH" ]
then
    shopt -s histappend
    shopt -s checkwinsize
    shopt -s cmdhist
    [ -f /etc/bash_completion ] && . /etc/bash_completion

    # shellcheck disable=SC2086,SC1090
    [ -d "$HOME/.bash_completion.d" ] && . $HOME/.bash_completion.d/*

    # shellcheck disable=SC1090
    # added by travis gem
    [ -f "$HOME/.travis/travis.sh" ] && . "$HOME/.travis/travis.sh"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
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

export REPREPRO_BASE_DIR=$HOME/Documents/Shore/debian-repository
export EDITOR=vim
export GOPATH=$HOME/Documents/Golang
export PATH=$PATH:$GOPATH/bin:/usr/lib/go/bin/
export PATH=$PATH:$HOME/Documents/Shore/cleanup
export PATH=$PATH:$HOME/Documents/Shore/ssh-ca
export PATH=$PATH:$HOME/Documents/Shore/ssl-ca
export PATH=$PATH:$HOME/.cargo/bin
export PYTHONSTARTUP=~/.pythonstartup
export AWS_DEFAULT_PROFILE='shore'
alias ll='ls -lha'
alias la='ls -A'
alias l='ls -CF'
alias gcc='gcc --std=c99 -Wall -Wextra -Werror -pedantic'
alias dpkglog="grep -v 'status\|trigproc\|configure' /var/log/dpkg.log"
alias deborphan='deborphan -a --no-show-section --ignore-suggests'
alias aptitude='aptitude --display-format %p --quiet'
alias obsolete='aptitude search ?obsolete'
alias missing-recommends="aptitude search '~RBrecommends:~i'"
# shellcheck disable=2142
alias deinstalled="dpkg --get-selections | awk '\$2==\"deinstall\" {print \$1}'"
alias ansible-local='ansible localhost -c local -i localhost,'
alias ansible-local-playbook='ansible-playbook -i localhost, -c local'
alias gen-ssh-config='cat $HOME/.ssh/config.d/* > $HOME/.ssh/config'
alias concat="perl -pe 's/\n/\\\n/g'"
alias deconcat="perl -pe 's/\\\n/\n/g'"
alias ggo='sudo GOPATH=/usr/share/go go'
alias ecr-login='eval $(aws ecr get-login)'
alias hostlocal='docker run --rm --privileged --net=host gliderlabs/hostlocal'
alias apt-daily="sudo /bin/sh -c 'apt-get update && apt-get dist-upgrade --download-only --yes && apt-get autoclean'"
alias docker-build='docker build -t "$(basename $PWD)" ./'
alias cdtemp='cd $(mktemp -d)'
alias 0-day-cleanup='ssh xbmc.shore.co.il "sudo -u debian-transmission find /srv/library/Comics -name *.part -path *0-Day\ Week\ of* -delete"'
alias httpbin='tox -c $HOME/.tox.ini.httpbin --'
alias update-requirements='find -name "*requirements*.txt" -exec pur --requirement {} \;'

deduce-aws-region () {
    AWS_DEFAULT_REGION="$(curl --silent \
        http://169.254.169.254/latest/dynamic/instance-identity/document \
        | sed -n 's/ *"region" : "\([a-z0-9\-]*\)"/\1/gp')"
    export AWS_DEFAULT_REGION
    echo "$AWS_DEFAULT_REGION"
}

ssh-keyscan-add () {
    # shellcheck disable=SC2094
    (ssh-keyscan "$@"; cat "$HOME/.ssh/known_hosts") | sort -u >> "$HOME/.ssh/known_hosts"
}

gen-csr () {
    openssl req -new -newkey rsa:4096 -nodes -out "$1.csr" -keyout "$1.key"
}

docker-dev () {
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

sync-comics () {
    local this_month last_month
    this_month="$( date '+xbmc.shore.co.il:/srv/library/Comics/0-Day\ Week\ of\ %Y.%m.*' )"
    last_month="$( date --date '1 month ago' '+xbmc.shore.co.il:/srv/library/Comics/0-Day\ Week\ of\ %Y.%m.*' )"
    rsync --recursive --compress --progress --exclude "*.part" "$last_month" "$this_month" "$HOME/Downloads/Comics/"
}

# shellcheck disable=SC1090
. "$HOME/Documents/Shore/bundle_certs/bundle_certs"
