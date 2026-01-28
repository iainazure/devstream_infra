# --- Phase 4: The Configuration Handshake (Outputs) ---
output "backend_config_template" {
  value = <<EOT
# Copy this into your new repo's backend.tf if not using automated injection
terraform {
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.project_rg.name}"
    storage_account_name = "${azurerm_storage_account.state_sa.name}"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}
EOT
}