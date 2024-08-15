Creating VM scale sets manually is covered here:
https://support.intelligentvoice.com/hc/en-us/articles/23612526692371-Azure-Autoscaling-Setup

Before starting
--

Log into your Ansible control node with SSH, activate the virtual environment and populate the Azure environment variables

Creating the Application Insights
--
Follow [the instructions](https://support.intelligentvoice.com/hc/en-us/articles/23612526692371-Azure-Autoscaling-Setup#AzureAutoscalingSetup-Step1.CreateanApplicationInsightresource) and get the instrumentation key.

To create the VM images and Scale Sets, run the [create_vm-images.ansible.yml](ansible/create-vm-images.ansible.yml) playbook passing it your inventory file (`hosts.ini`) and the name of your resource group and VM suffix

```bash
ansible-playbook -i hosts.ini -e resource_group=${AZURE_RESOURCE_GROUP} -e vm_suffix=-KCCT-10 create-vm-images.ansible.yml
```


More about setting scale set rules in Azure using Ansible here:
https://learn.microsoft.com/en-us/azure/developer/ansible/vm-scale-set-auto-scale

(Colin will add this to the playbook at later date)