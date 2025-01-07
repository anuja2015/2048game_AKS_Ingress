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

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics workspace"
  type        = string
  default     = "aks-log-analytics"
}

variable "log_retention_days" {
  description = "The retention period for the Log Analytics workspace"
  type        = number
  default     = 30
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

