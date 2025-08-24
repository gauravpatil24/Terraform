Vm creation using variables.
In real time we dont create terraform.tfvars but we pass variables in command line as below
terraform plan -var "resource_group_name=resgrp" -var "resource_group_location=West India"