# --- Phase 1: Identity & Security (Azure Entra ID) ---
resource "azuread_application" "app" {
  display_name = local.repo_name_clean
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.client_id
}

# Federated Trust for Pull Requests (Plan)
resource "azuread_application_federated_identity_credential" "pr" {
  application_id = azuread_application.app.id
  display_name   = "github-pr"
  description    = "Allow plan on PRs"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.repo_name}:pull_request"
}

# Federated Trust for Main (Apply)
resource "azuread_application_federated_identity_credential" "main" {
  application_id = azuread_application.app.id
  display_name   = "github-main"
  description    = "Allow apply on main branch"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.repo_name}:ref:refs/heads/main"
}

# RBAC Assignment - Scoped to the new Resource Group
resource "azurerm_role_assignment" "contributor" {
  scope                = azurerm_resource_group.project_rg.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.sp.object_id
}