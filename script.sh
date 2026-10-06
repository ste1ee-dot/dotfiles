#!/usr/bin/bash

dotfiles_dir=$(dirname $(readlink -f "$0"))
echo $dotfiles_dir


# Emacs
rm -rf $HOME/.config/emacs/
cp -rf $dotfiles_dir/.config/emacs/ $HOME/.config/emacs/

# Vis
rm -rf $HOME/.config/vis/
cp -rf $dotfiles_dir/.config/vis/ $HOME/.config/vis/

# Hypr
rm -rf $HOME/.config/hypr/
cp -rf $dotfiles_dir/.config/hypr/ $HOME/.config/hypr/
