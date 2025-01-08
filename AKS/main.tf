

resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name  = var.vnet_name
  resource_group_name = azurerm_resource_group.aks.name
  location = azurerm_resource_group.aks.location
  address_space = var.address_space
  
}

resource "azurerm_subnet" "subnet01" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = var.address_prefixes
  service_endpoints = var.service_endpoints
  
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    # AKS Default Subnet ID
    vnet_subnet_id        = azurerm_subnet.subnet01.id

  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }
  
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
}
output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}