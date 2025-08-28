Project to use Provisioners with Terraform.
Provisioners are used to perform actions once the VM is created. e.g. installing a software on VM once the VM is created.
Though this is not as par with using Ansible but useful in small operations.
There are 3 types of Provisioners.
 1. File Provisioners- used to copy files from local machine where we will run Terraform to VM. e.g. Copy a script to new VM.
 2. Local-exec Provisioners- When we want to perform commands on same machine we are running Terraform commands. e.g. API call, execut script.
 3. Remote-exec Provisioners- When we want to perform commands on newly created VM. e.g. Installtion of software, configuration management.
In real time we dont create terraform.tfvars but we pass variables in command line as below
#terraform plan -var "resource_group_name=resgrp" -var "resource_group_location=West India"
