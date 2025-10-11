#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias sudo='sudo '

alias ls='ls --color=auto'
alias la='ls -a'

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias neovim='nvim'
