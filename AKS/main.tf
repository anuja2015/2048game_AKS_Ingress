

resource "azurerm_resource_group" "aks" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
}

resource "azurerm_log_analytics_solution" "main" {
  solution_name         = "Containers"
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name
  location              = azurerm_resource_group.aks.location
  resource_group_name   = azurerm_resource_group.aks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
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
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.main.id
    msi_auth_for_monitoring_enabled = true
  }
}
output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config_raw
  sensitive = true
}