Before starting
--

Log into your Ansible control node with SSH and activate the virtual environment.  You won't need the Azure environment variables for this workbook.

Download the IV installer
--

```bash
curl -O https://installers.intelligentvoice.com/installer-v4.5.1.zip
unzip installer-v4.5.1.zip
```
Edit the inventory file
---
Starting with the example inventory file [example.hosts.ini](ansible/example.hosts.ini), customise this to suit your installation and save it as `hosts.ini`

For example, you will need to fill in the credentials you have been given and you may also need to customise hostnames and IP addresses.

Run the installer
--
```bash
ansible-playbook -i hosts.ini install.yml
```
This will take 30-60 mins to run.

If you encounter errors, fix the inventory and re-run the install.