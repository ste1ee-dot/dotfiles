# Dotfiles
My dotfiles are managed with [stow](https://www.gnu.org/software/stow/).

Required packages:
- [Neovim](https://neovim.io/) 0.12+
- [Stow](https://www.gnu.org/software/stow/)

## Usage
From the dotfiles directory:
```bash
stow .
```
Or use a one-liner:
```bash
git clone git@github.com:ste1ee-dot/dotfiles.git && cd dotfiles && sh ./script.sh && cd /home/$USER
```
