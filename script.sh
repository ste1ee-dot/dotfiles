#!/usr/bin/bash

dotfiles_dir=$(dirname $(readlink -f "$0"))

echo $dotfiles_dir

ln -sf $dotfiles_dir/.config/emacs/init.el $HOME/.config/emacs/init.el
