#!/bin/sh

stow . --adopt &&
git restore . &&
stow .
cd /home/$USER
