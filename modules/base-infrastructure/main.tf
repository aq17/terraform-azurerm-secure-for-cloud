locals {
}

resource "azurerm_resource_group" "rg" {
  name     = "${lower(var.naming_prefix)}-resourcegroup"
  location = var.location

  tags = var.tags

}

resource "azurerm_eventhub_namespace" "evn" {
  name                = "${lower(var.naming_prefix)}-eventhub-namespace"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.sku
  capacity            = var.namespace_capacity

  tags = var.tags
}

resource "azurerm_eventhub_namespace_authorization_rule" "ns_auth_rule" {
  name                = "${lower(var.naming_prefix)}-namespace-auth-rule"
  namespace_name      = azurerm_eventhub_namespace.evn.name
  resource_group_name = azurerm_resource_group.rg.name

  listen = true
  send   = true
  manage = true
}

resource "azurerm_eventhub" "aev" {
  name                = "${lower(var.naming_prefix)}-eventhub"
  namespace_name      = azurerm_eventhub_namespace.evn.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = var.eventhub_partition_count
  message_retention   = var.eventhub_retention_days
}

resource "azurerm_eventhub_authorization_rule" "eh_auth_rule" {
  name                = "${lower(var.naming_prefix)}-eventhub_auth_rule"
  namespace_name      = azurerm_eventhub_namespace.evn.name
  eventhub_name       = azurerm_eventhub.aev.name
  resource_group_name = azurerm_resource_group.rg.name

  listen = true
  send   = true
  manage = true
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  name                           = "${lower(var.naming_prefix)}-diagnostic_setting"
  target_resource_id             = "/subscriptions/${var.subscription_id}"
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.ns_auth_rule.id
  eventhub_name                  = azurerm_eventhub.aev.name

  dynamic "log" {
    for_each = var.logs
    content {
      category = log.value

      retention_policy {
        enabled = false
      }
    }
  }
}