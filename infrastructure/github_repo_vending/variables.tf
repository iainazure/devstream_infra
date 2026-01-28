# --- Core Logic Variables ---

variable "repo_name" {
  description = "The name of the new GitHub repository (used as the seed for all Azure naming)."
  type        = string
}

variable "github_org" {
  description = "The GitHub Organization or Username where the repo will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the Resource Group and Storage Account will be created."
  type        = string
  default     = "UK South"
}

# --- Phase 3: Repository Vending Variables ---

variable "template_repo_name" {
  description = "The name of the template repository to spawn the new repo from."
  type        = string
  default     = "devstream_infra_template"
}

# --- Data Sources (Used for Phase 1 & 3 Secrets) ---

data "azurerm_client_config" "current" {
  # This automatically captures your current Subscription and Tenant IDs
  # so you don't have to hardcode them as variables.
}