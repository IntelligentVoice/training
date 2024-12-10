#!/bin/bash

# Prepare the Ansible Control Node
# Install the Ansible modules for Azure

set -euo pipefail

echo "Install Ansible az collection for interacting with Azure."
ansible-galaxy collection install 'azure.azcollection:==1.19.0' --force

echo "Install requirements for az collection"
ansible localhost -m ansible.builtin.pip -a "requirements=$VIRTUAL_ENV/.ansible/collections/ansible_collections/azure/azcollection/requirements-azure.txt"

ansible-galaxy collection list