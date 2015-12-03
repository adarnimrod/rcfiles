# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export HISTCONTROL=ignoreboth
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

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias gcc='gcc --std=c99 -Wall'
alias dpkglog="grep -v 'status\|trigproc\|configure' /var/log/dpkg.log"
alias deborphan='deborphan -a --no-show-section'
export REPREPRO_BASE_DIR=$HOME/Documents/Shore/debian-repository
export EDITOR=vim
alias ansible-local='ansible localhost -c local -i localhost,'
alias ansible-local-playbook='ansible-playbook -i localhost,'
alias gen-ssh-config='cat $HOME/.ssh/config.d/* > $HOME/.ssh/config'
alias ssl-ca='$HOME/Documents/Shore/ssl-ca/ssl-ca'
