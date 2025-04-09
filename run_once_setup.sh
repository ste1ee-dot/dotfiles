#!/bin/bash

setup_fedora() {
    echo "Setting up Fedora."

    sudo dnf install tmux git make gawk unzip gzip fzf gcc nodejs npm ripgrep golang sqlite3 wget tar dnf-plugins-core flatpak kitty wofi mako -y
    sudo dnf autoremove -y

    echo "Fedora setup finished."
}

setup_ubuntu() {
    echo "Setting up Ubuntu."

    sudo apt update
    sudo apt upgrade -y
    sudo apt-get update
    sudo apt-get upgrade -y

    sudo apt-get install tmux git make gawk unzip gzip fzf gcc nodejs npm ripgrep golang-go sqlite3 wget tar flatpak kitty wofi mako -y

    sudo apt autoremove -y

    echo "Ubuntu setup finished."
}

setup_flatpak() {
    echo "Installing flatpaks"
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    flatpak install flathub com.stremio.Stremio -y
    flatpak install flathub com.discordapp.Discord -y

    echo "Installed flatpaks."
}

setup_general() {
    echo "Setting up Neovim nightly."
    curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    sudo mv nvim-linux-x86_64.appimage /usr/local/bin/nvim
    echo "Neovim nightly installed"

    echo "Setting up Uni."
    curl -LO https://github.com/arp242/uni/releases/download/v2.8.0/uni-v2.8.0-linux-amd64.gz
    gzip -d uni-v2.8.0-linux-amd64.gz
    chmod +x uni-v2.8.0-linux-amd64
    sudo mv uni-v2.8.0-linux-amd64 /usr/local/bin/uni
    echo "Uni installed."

    echo "Setting up Ble.sh"
    git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
    make -C ble.sh install PREFIX=~/.local
    echo 'source ~/.local/share/blesh/ble.sh' >> ~/.bashrc
    echo 'eval "$(atuin init bash)"' >> ~/.bashrc
    echo "Blesh set up."

    echo "Setting up Atuin."
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    echo "Atuin installed."
}

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/fedora-release ]; then
            setup_fedora
            setup_flatpak
            setup_general
        elif [ -f /etc/lsb-release ]; then
            setup_ubuntu
            setup_flatpak
            setup_general
        else
            echo "Unsupported Linux distro."
            exit 1
        fi
        ;;
    *)
        echo "Unsupported operating system: ${OS}"
        exit 1
        ;;
esac

rm ~/.bashrc
ln -sf "$(pwd)/dot_bashrc" ~/.bashrc
