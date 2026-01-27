# 1. Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "rg-devstream-test-uks"
  location = "UK South"
}

# 2. Create the Storage Account
resource "azurerm_storage_account" "example" {
  # Change 'iaintest' to something unique like 'iain344a8b'
  name                     = "iainteststorage001"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "learning"
  }
}