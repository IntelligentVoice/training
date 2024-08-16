Creating VM scale sets manually is covered here:
https://support.intelligentvoice.com/hc/en-us/articles/23612526692371-Azure-Autoscaling-Setup

Before starting
--

Log into your Ansible control node with SSH, activate the virtual environment and populate the Azure environment variables

Creating the Application Insights
--
Follow [the instructions](https://support.intelligentvoice.com/hc/en-us/articles/23612526692371-Azure-Autoscaling-Setup#AzureAutoscalingSetup-Step1.CreateanApplicationInsightresource) and get the instrumentation key.
Record the name you used for your Application Insights, for this workbook we will assume *TrainingAppInsight*

Configuration change to add gearmanstats to the installation
--
Insert the block below into your inventory (hosts.ini file), setting the `instrumentation_key` value to your instrumentation key 

    gearman_stats_enabled=true
    gearman_stats_platform=azure
    instrumentation_key=d6067e5a-9031-4213-893e-e39aaf1d1400

Re-run the installation

Create Images and Scale Sets
--

To create the VM images and Scale Sets, run the [create_vm-images.ansible.yml](ansible/create-vm-images.ansible.yml) playbook passing it your inventory file (`hosts.ini`) and the name of your resource group, VM suffix and Application Insight name.

```bash
ansible-playbook -i localhost, --connection local -e resource_group=${AZURE_RESOURCE_GROUP} -e vm_suffix=-KCCT-10 -e appinsight_name=TrainingAppInsight create-vm-images.ansible.yml
```

This playbook includes basic scale set rules.  More about setting scale set rules in Azure using Ansible here:
https://learn.microsoft.com/en-us/azure/developer/ansible/vm-scale-set-auto-scale