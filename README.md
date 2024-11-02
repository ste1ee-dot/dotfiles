# dotfiles

This repo contains the configuration to setup my machines. This is using [Chezmoi](https://chezmoi.io), the dotfile manager to setup the install.

This setup currently only works on with APT and DNF package managers!

## How to run

```shell
export GITHUB_USERNAME=ste1ee-dot
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply $GITHUB_USERNAME
```
