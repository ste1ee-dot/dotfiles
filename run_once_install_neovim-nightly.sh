#!/bin/bash

# Download the Neovim Nightly AppImage
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage

# Make the AppImage executable
chmod u+x nvim-linux-x86_64.appimage

sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
