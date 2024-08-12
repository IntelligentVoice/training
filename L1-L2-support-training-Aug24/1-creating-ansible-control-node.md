
Commands to create an ansible control node VM in an existing resource group, and configure it to manage Azure resources.

This workbook was built on information from these guides, updated and tailored for this course:
* https://learn.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm
* https://learn.microsoft.com/en-us/azure/developer/ansible/create-ansible-service-principal

You can run `az` commands from any computer with Azure CLI installed and configured, or you can run it in a browser using Azure Shell at https://shell.azure.com/ (choose Bash as your shell)



Create Azure credentials
--
To use Ansible to manage Azure resources, you need the following information:

* Your Azure subscription ID and tenant ID
* A service principal application ID and secret

To get your Azure subscription ID and tenant ID, run this command:

```bash
az account show --query '{tenantId:tenantId,subscriptionid:id}'
```
To create a service principle named _ansible_ which is scoped to your resource group, first set these environment variables:
```bash
export AZURE_RESOURCE_GROUP=<name of your resource group>
export AZURE_SUBSCRIPTION_ID=<your "subscriptionid" from "az account show">
```
then run this command:

```bash
az ad sp create-for-rbac --name ansible \
    --role Contributor \
    --scopes /subscriptions/$AZURE_SUBSCRIPTION_ID/resourceGroups/$AZURE_RESOURCE_GROUP
```

Create a virtual machine
--
1. Create the Azure virtual machine for Ansible.  Set `$AZURE_RESOURCE_GROUP` to the name of your existing resource group.

    ```bash
    az vm create \
    --resource-group $AZURE_RESOURCE_GROUP \
    --name Ansible-Control-Node \
    --image RedHat:RHEL:9-lvm-gen2:latest \
    --admin-username ivuser \
    --generate-ssh-keys
    ```
    Note: The `--generate-ssh-keys` options will create a new private key for you in `.ssh/id_rsa` in your Azure Cloud Shell.  You can use an already existing key by specifying the path using e.g. `--ssh-key-value .ssh/id_rsa.pub` instead of `--generate-ssh-keys`)

2. Get the public IP address of the Azure virtual machine.
The output of the command above will include the public IP address of your VM or you can run this command:
    ```bash
    az vm show -d -g $AZURE_RESOURCE_GROUP -n Ansible-Control-Node --query publicIps -o tsv
    ```

Connect to your virtual machine via SSH
--

Using the SSH command, connect to your virtual machine's public IP address:

```bash
ssh ivuser@<vm_ip_address>
```

Replace the <vm_ip_address> with the appropriate value returned in previous commands.

Install Ansible on the virtual machine
--
Run the following commands to install Ansible on RHEL 9:

```bash
#!/bin/bash

# Update all packages that have available updates.
sudo yum update -y

# Install Python 3 and pip.
sudo yum install -y python3-pip

# Create virtual environment for a modern version of Ansible, and activate it:
python -m venv ansible-venv
source ansible-venv/bin/activate

# Install or upgrade pip3 and ansible
pip3 install --upgrade pip ansible

# extend the home volume to make space for Ansible modules we will install
# this is also a good test to prove we have Ansible working
ansible localhost -b -m community.general.lvol -a "vg=rootvg lv=homelv size=+10G resizefs=true"

# Install Ansible az collection for interacting with Azure.
ansible-galaxy collection install azure.azcollection --force

# Install Ansible modules for Azure
pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt
```

Run the following commands to populate the required environment variables on the Ansible server:

```bash
export AZURE_RESOURCE_GROUP=<ResourceGroup>
export AZURE_SUBSCRIPTION_ID=<SubscriptionID>
export AZURE_TENANT=<TenantID>
export AZURE_CLIENT_ID=<ApplicationId>
export AZURE_SECRET=<Password>
```

Replace the values in `< >` with the values generated above.  You can show these again by running these commands in Azure Cloud Shell:

```bash
az account show --query '{tenantId:tenantId,subscriptionid:id}'
az ad sp list --display-name ansible --query '{clientId:[0].appId}'
```

Note: you will need to set these environment variables every time you log into the Ansible Control Node, so for convinience you may wish to add them to the end of your `.bashrc` file

You can verify that the Ansible Azure setup is complete by running this command:

```bash
ansible localhost -m azure.azcollection.azure_rm_virtualmachine_info -a "resource_group=$AZURE_RESOURCE_GROUP"
```

This outputs a list of VMs in the resource group, which should include at least the Ansible control node