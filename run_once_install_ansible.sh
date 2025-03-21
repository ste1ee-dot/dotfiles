#!/bin/bash

install_on_fedora() {
    sudo dnf install -y ansible
}
install_on_ubuntu() {
	sudo apt-get update
	sudo apt-get install -y ansible
}

OS="$(uname -s)"
case "${OS}" in
	Linux*)
        if [ -f /etc/fedora-release ]; then
            install_on_fedora
            ansible-playbook ~/.bootstrap/setup_fedora.yml --ask-become-pass
        elif [ -f /etc/lsb-release ]; then
			install_on_ubuntu
            ansible-playbook ~/.bootstrap/setup_ubuntu.yml --ask-become-pass
		else
			echo "Unsupported Linux distribution."
			exit 1
		fi
		;;
	*)
		echo "Unsupported operating system: ${OS}"
		exit 1
		;;
esac

ansible-playbook ~/.bootstrap/setup_flatpak.yml
ansible-playbook ~/.bootstrap/setup_user.yml

echo "Ansible installation complete."
