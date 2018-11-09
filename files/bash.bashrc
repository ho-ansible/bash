# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

PROMPT_DIRTRIM=2
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# Identify chroot environment
if [ -z "$chroot" ] && [ -r /etc/debian_chroot ]; then
	chroot="($(cat /etc/debian_chroot))"
fi

# Set title of graphical terminal window
case "$TERM" in
screen*|xterm*|rxvt*)
	PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${chroot}${PWD/#$HOME/\~}\007"'
        ;;
esac

# Set shell prompt, with color if available
tput=/usr/bin/tput
if [ -x $tput ] && $tput setaf 1 >&/dev/null; then
	PS1='\[\e[30;43m\]\h\[\e[0m\]:\[\e[30;46m\]${chroot}\[\e[96;40m\]\w \[\e[30;101m\]${?#0}\[\e[0m\]\$ '
        alias ls='ls --color=auto'
        alias grep='grep --colour=auto'
else
        PS1='\h:${chroot}\w $?\$ '
fi
unset tput

alias ll="ls -l"
alias lt="ll -rt"
alias lss="ls -shSr"
alias m='${PAGER}'
alias px="ps xww"
alias pm="ps auxk -vsz"
alias where="type -all"

export PAGER="/usr/bin/less"
export EDITOR="/usr/bin/vi"

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Symlink ssh agent socket to standard place
stdsock=~/.ssh/agent.sock
mkdir -p ${stdsock%/*}
if [[ -S "$SSH_AUTH_SOCK" ]] && ! SSH_AUTH_SOCK="$stdsock" ssh-add -l 1>&- 2>&-; then
	ln -sf "$SSH_AUTH_SOCK" "$stdsock"
fi

