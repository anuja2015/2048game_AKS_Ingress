variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "aks-resource-group"
}

variable "location" {
  description = "The Azure region where resources will be deployed"
  type        = string
  default     = "East US"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
  default     = "aks-vnet"
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used the virtual network. You can supply more than one address space but for our module implementation we are limiting it to 1 address space only."
  default     = ["10.1.0.0/16"]
  validation {
    condition     = length(var.address_space) == 1
    error_message = "Only a single address space can be set. Please check your subnet address prefixes."
  }
}

variable "subnet_name" {
  type        = string
  description = "The name of the subnet. Changing this forces a new resource to be created."
  default = "subnet01"
}
  
variable "address_prefixes" {
  type        = list(string)
  description = "The address prefixes to use for the subnet. Currently only a single address prefix can be set as the Multiple Subnet Address Prefixes Feature is not yet in public preview or general availability."
  default     = ["10.1.0.0/16"]
  validation {
    condition     = length(var.address_prefixes) == 1
    error_message = "Only a single address prefix can be set. Please check your subnet address prefixes."
  }
}
 
variable "service_endpoints" {
  type        = list(string)
  description = "The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web."
  default     = []
}


variable "aks_cluster_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "aks-cluster"
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster"
  type        = string
  default     = "aksdns"
}

variable "node_count" {
  description = "The number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "The size of the virtual machines in the default node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {
    environment = "production"
  }
}

variable "prefix" {
  description = "A prefix used for all resources in this example"
}

variable "network_plugin" {
  type        = string
  description = "Network plugin to use for networking. Currently supported values are azure, kubenet and none. Changing this forces a new resource to be created."
  default     = "azure"
}

