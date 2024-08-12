Before starting
--

Log into your Ansible control node with SSH and activate the virtual environment where you installed Ansible again:

```bash
source ansible-venv/bin/activate
```

Populate the required environment variables on the Ansible server:

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
Creating the IV infrastructure
---

To create the VMs which we will install IV onto, run the [create_vms.ansible.yml](ansible/create-vms.ansible.yml) playbook, passing it the name of your resource group:

```bash
ansible-playbook -i localhost, -e resource_group=${AZURE_RESOURCE_GROUP} create_vms.ansible.yml
```

This playbook can take 5-10 mins to run as it waits for Azure to create all the VMs.

If you have any problems creating these VMs (permissions, quota, etc) fix these before continuing or make a note of changes you need.  Later examples will use the hostnames from this playbook.

Troubleshooting
--
if Ansible fails to detect your virtualenv you can force it by adding this to your ansible-playbook command:
```
-e ansible_python_interpreter=~/ansible-venv/bin/python