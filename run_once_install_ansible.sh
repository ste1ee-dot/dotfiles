#!/bin/bash

echo "Which package manager to use?"
echo "apt / dnf: "

read pkgmr

install_on_dnf() {
    sudo dnf install -y ansible
}

install_on_apt() {
    sudo apt-get update
    sudo apt-get install -y ansible
}

if [ "$pkgmr" = "apt" ]; then
    install_on_apt
    echo "Setup for APT"
elif [ "$pkgmr" = "dnf" ]; then
    install_on_dnf
    echo "Setup for DNF"
else
    echo "Unsupported package manager"
    exit 1
fi

if [ "$pkgmr" = "apt" ]; then
    ansible-playbook ~/.bootstrap/setupapt.yml --ask-become-pass
    echo "APT ansible done"
elif [ "$pkgmr" = "dnf" ]; then
    ansible-playbook ~/.bootstrap/setupdnf.yml --ask-become-pass
    echo "DNF ansible done"
else
    echo "Unsupported package manager"
    exit 1
fi

ansible-playbook ~/.bootstrap/setup.yml --ask-become-pass
echo "Flatpak ansible done"

echo "Ansible installation complete."
