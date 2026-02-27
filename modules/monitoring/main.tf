resource "azurerm_resource_group" "monitoring" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Centralized Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "central" {
  name                = "law-central-monitoring"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30  # Keep costs low for lab
  tags                = var.tags
}

# Activity Log diagnostic setting — sends subscription-level logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "activity_log" {
  name                       = "activity-log-to-law"
  target_resource_id         = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.central.id

  enabled_log {
    category = "Administrative"
  }

  enabled_log {
    category = "Security"
  }

  enabled_log {
    category = "Policy"
  }
}

data "azurerm_subscription" "current" {}

# Action group for alerts (email notification)
resource "azurerm_monitor_action_group" "platform_alerts" {
  name                = "ag-platform-alerts"
  resource_group_name = azurerm_resource_group.monitoring.name
  short_name          = "PlatAlerts"
  tags                = var.tags

  email_receiver {
    name          = "admin-email"
    email_address = "ayobami.odunlami@hotmail.com"
  }
}

# Alert: Resource Health degraded
resource "azurerm_monitor_activity_log_alert" "resource_health" {
  name                = "alert-resource-health"
  resource_group_name = azurerm_resource_group.monitoring.name
  scopes              = ["/subscriptions/${data.azurerm_subscription.current.subscription_id}"]
  description         = "Alert when any resource health status changes to degraded or unavailable"
  tags                = var.tags

  criteria {
    category = "ResourceHealth"
  }

  action {
    action_group_id = azurerm_monitor_action_group.platform_alerts.id
  }
}