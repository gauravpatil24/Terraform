variable "vm" {
  type = map(object({
    vm_name  = string
    nic_name = string
    ip_name  = string
  }))
  default = {
    "vm1" = {
      vm_name  = "webserver"
      nic_name = "webserver-nic"
      ip_name  = "webserver-ip"
    }
    "vm2" = {
      vm_name  = "appserver"
      nic_name = "appserver-nic"
      ip_name  = "appserver-ip"
    }
    "vm3" = {
      vm_name  = "dbserver"
      nic_name = "dbserver-nic"
      ip_name  = "dbserver-ip"
    }

  }

}