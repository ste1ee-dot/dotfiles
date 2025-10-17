#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# VARIABLES
export EDITOR="nvim"								#sets the defualt editor
export NOTESPATH="/home/$USER/Documents/notes"		#sets the path to my notes


# ALIASES
alias sudo='sudo '

alias ls='ls --color=auto'
alias la='ls -a'

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias neovim='nvim'


# KEYBINDS
bind -x '"\C-n":$EDITOR $NOTESPATH'					#Ctrl-n open notes in editor	
bind -x '"\C-f":$EDITOR $(fzf)'						#Ctrl-f opens editor fzf
bind -x '"\ef":fzf'									#Alt/Meta-f opens normal fzf
bind -x '"\C-t":. /home/$USER/timew/time.sh && basta.update_status'


# SCRIPTS
. ~/.basta.sh
