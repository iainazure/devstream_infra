# --- Phase 2: Project Scaffolding (Azure RM) ---
resource "azurerm_resource_group" "project_rg" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "state_sa" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.project_rg.name
  location                 = azurerm_resource_group.project_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "state_container" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.state_sa.id
}

resource "azurerm_management_lock" "sa_lock" {
  name       = "state-storage-lock"
  scope      = azurerm_storage_account.state_sa.id
  lock_level = "CanNotDelete"
  notes      = "Prevent accidental deletion of Terraform state"
}
