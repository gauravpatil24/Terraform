Data block is used to get the already created resources on cloud into our Terraform code e.g. in realtime there may be Resource group and VNET's already created on cloud, 
and we may want to deploy new subnet with sets of VM's in that particular subnet and resource group.
In short, Resource block in Terraform creates new resource on cloud while Data block access the existing one.
In real time we dont create terraform.tfvars but we pass variables in command line as below
terraform plan -var "resource_group_name=resgrp" -var "resource_group_location=West India"