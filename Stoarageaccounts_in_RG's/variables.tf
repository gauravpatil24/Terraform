variable "resource_group" {
  type = map(object({
    resource_group_name = string
    location            = string
    stoage_account_name = string
    container_name      = string
    blob_name           = string
  }))
  default = {
    "rg1" = {
      resource_group_name = "rg1"
      location            = "eastus"
      stoage_account_name = "sa1"
      container_name      = "container1"
      blob_name           = "C:\\Users\\Gaurav\\Downloads\\Terraform\\Practice\\AzurePedia\\data1.txt"
    }
    "rg2" = {
      resource_group_name = "rg2"
      location            = "westus"
      stoage_account_name = "sa2"
      container_name      = "container2"
      blob_name           = "C:\\Users\\Gaurav\\Downloads\\Terraform\\Practice\\AzurePedia\\data2.txt"
    }
     "rg3" = {
      resource_group_name = "rg3"
      location            = "CentralUS"
      stoage_account_name = "sa3"
      container_name      = "container3"
      blob_name           = "C:\\Users\\Gaurav\\Downloads\\Terraform\\Practice\\AzurePedia\\data3.txt"
    }
  }
}