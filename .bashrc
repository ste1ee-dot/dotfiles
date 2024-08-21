#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

PS1='\n\A [\u@\h] '"'"'\w'"'"' \n\\$ '

HISTSIZE= HISTFILESIZE= # Infinite history

alias nf='clear && neofetch'

shopt -s autocd #Allows you to cd into directory just by name

alias ll='exa --icons -a -x -s type'
