# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export LANG=en_US.UTF8
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
shopt -s histappend
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f /usr/local/bin/virtualenvwrapper.sh ]
then
    . /usr/local/bin/virtualenvwrapper.sh
fi

export REPREPRO_BASE_DIR=$HOME/Documents/Shore/debian-repository
export EDITOR=vim
export GOPATH=$HOME/Documents/Golang
export PATH=$PATH:$GOPATH/bin:/usr/lib/go/bin/:$HOME/Documents/Shore/cleanup:$HOME/Documents/Shore/ssh-ca:$HOME/Documents/Shore/ssl-ca
export PYTHONSTARTUP=~/.pythonstartup
alias ll='ls -lha'
alias la='ls -A'
alias l='ls -CF'
alias gcc='gcc --std=c99 -Wall'
alias dpkglog="grep -v 'status\|trigproc\|configure' /var/log/dpkg.log"
alias deborphan='deborphan -a --no-show-section'
alias aptitude='aptitude --display-format %p --quiet'
alias obsolete='aptitude search ?obsolete'
alias missing-recommends="aptitude search '~RBrecommends:~i'"
alias deinstalled="dpkg --get-selections | awk '\$2==\"deinstall\" {print \$1}'"
alias ansible-local='ansible localhost -c local -i localhost,'
alias ansible-local-playbook='ansible-playbook -i localhost, -c local'
alias gen-ssh-config='cat $HOME/.ssh/config.d/* > $HOME/.ssh/config'
alias concat="perl -pe 's/\n/\\\n/g'"
alias deconcat="perl -pe 's/\\\n/\n/g'"
alias ggo='sudo GOPATH=/usr/share/go go'
alias tag-version='git tag -f v"$(cat VERSION)"'
alias ecr-login='eval $(aws ecr get-login)'
ssh-keyscan-add () {
    (ssh-keyscan $@; cat $HOME/.ssh/known_hosts) | sort -u >> $HOME/.ssh/known_hosts
}

gen-csr () {
    openssl req -new -newkey rsa:4096 -nodes -out $1.csr -keyout $1.key
}

. $HOME/Documents/Shore/bundle_certs/bundle_certs
