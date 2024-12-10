This is a collection of Ansible playbooks which automate the best practices for deploying Intelligent Voice as an auto-scaling solution in Azure.

This includes the following steps:

1. Creating all the VMs
2. Preparing the VMs by extending the filesystems, applying OS updates, and installing GPU drivers (where applicable)
3. Downloading and configuring the IV installer
4. Running the installation
5. Capturing most of the VMs as images
6. Creating Azure VM Scale Sets using the images
7. Creating auto-scaling rules
8. Running a smoke test to validate the installation

This