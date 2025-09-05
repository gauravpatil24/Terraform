We can create multiple VM's using For Each too just like using Count. 
However the main difference between these 2 methods is we can give VM names as per our need using For Each, 
which is not possible with using Count where numbers are given according to index.
In real time we dont create terraform.tfvars but we pass variables in command line as below
terraform plan -var "resource_group_name=resgrp" -var "resource_group_location=West India"