# --- Phase 0: The Naming & Sanitization Engine ---
locals {
  # Clean the repo name for general use
  repo_name_clean = lower(var.repo_name)

  # Azure Storage Account Naming (Max 24 chars, no hyphens)
  # Strips hyphens, takes first 18 chars, appends random suffix
  storage_name_base = substr(replace(local.repo_name_clean, "/[-_]/", ""), 0, 18)
  storage_account_name = "${local.storage_name_base}${random_string.suffix.result}"

  # Resource Group & SP Names
  resource_group_name = "rg-${local.repo_name_clean}"
  sp_name             = "sp-${local.repo_name_clean}"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}
