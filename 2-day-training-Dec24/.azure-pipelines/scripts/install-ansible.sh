#!/bin/bash

# Prepare the Ansible Control Node
# Install python, pip, Ansible

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
export TZ=Europe/London
VIRTUAL_ENV="${VIRTUAL_ENV:-ansible-venv}"

echo "Install Python 3 and pip"
sudo apt update
sudo apt-get install -qy --no-install-recommends python3-pip python3-venv

mkdir -p "$VIRTUAL_ENV"

echo "Create virtual environment for a modern version of Ansible, and activate it"
if ! "$VIRTUAL_ENV/bin/python3" --version; then
    python3 -m venv "$VIRTUAL_ENV"
    "$VIRTUAL_ENV/bin/python3" --version
fi
[[ ":$PATH:" != *":$VIRTUAL_ENV/bin:"* ]] && PATH="$VIRTUAL_ENV/bin:${PATH}"

echo "Install or upgrade ansible"
python3 -m pip install --upgrade "ansible"

echo "Add or modify lines in ./hosts.ini"
ansible localhost -m lineinfile -a 'path=hosts.ini insertbefore="BOF" regexp="^localhost(?!.*ansible_python_interpreter=)(.*)$" backrefs="true" line="localhost ansible_python_interpreter='"$VIRTUAL_ENV"'/bin/python\1"'

echo "Add or modify lines in ./ansible.cfg"
ansible localhost -m ini_file -a "path=./ansible.cfg section=defaults option=collections_path value=$VIRTUAL_ENV/.ansible/collections"
ansible localhost -m ini_file -a "path=./ansible.cfg section=ssh_connection option=ssh_args value='-o StrictHostKeyChecking=no -o ServerAliveInterval=30'"
ansible localhost -m ini_file -a "path=./ansible.cfg section=ssh_connection option=retries value=5"

echo "Print ansible version"
ansible --version

echo 'Add venv to path future tasks'
echo "##vso[task.prependpath]$VIRTUAL_ENV/bin"