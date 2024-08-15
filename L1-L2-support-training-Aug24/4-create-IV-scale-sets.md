Before starting
--

Log into your Ansible control node with SSH, activate the virtual environment and populate the Azure environment variables

To create the VM images and Scale Sets, run the [create_vm-images.ansible.yml](ansible/create-vm-images.ansible.yml) playbook passing it your inventory file (`hosts.ini`) and the name of your resource group and VM suffix

```bash
ansible-playbook -i hosts.ini -e resource_group=${AZURE_RESOURCE_GROUP} -e vm_suffix=-KCCT-10 create_vm-images.ansible.yml
```
