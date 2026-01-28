# --- Phase 3: Repository Vending (GitHub) ---
resource "github_repository" "project_repo" {
  name        = var.repo_name
  description = "Infrastructure-as-Code for ${var.repo_name} - Managed by DevStream Vending Machine"
  visibility  = "public" # Or 'private'

  # --- 1. THE INITIAL TEMPLATE ---
  template {
    owner      = var.github_org
    repository = var.template_repo_name
    # includes the latest code from the template's default branch
  }

  # --- 2. MERGE STRATEGY (Keeps history clean) ---
  allow_squash_merge          = true
  allow_rebase_merge          = false # Disable to force a single 'squash' commit
  allow_merge_commit          = false # Disable to avoid 'Merge branch...' clutter
  squash_merge_commit_title   = "PR_TITLE" # Uses the PR title as the commit message
  delete_branch_on_merge      = true       # Tidies up feature branches automatically

  # --- 3. FEATURES & GOVERNANCE ---
  has_issues                  = true
  has_wiki                    = false
  has_projects                = false
  vulnerability_alerts        = true # Enables Dependabot security alerts

  # --- 4. ADVANCED AUTOMATION ---
  allow_auto_merge            = true # Allows PRs to merge themselves once checks pass

  # --- 5. LIFECYCLE (Safety) ---
  # If you ever delete this repo via Terraform, it will archive it instead of
  # nuking it from orbit. This is a massive life-saver.
  # TODO: reinstate when you are happy with setup
  # archive_on_destroy = true
  archive_on_destroy = false
}

# --- 6. BRANCH PROTECTION (The "Non-Negotiables") ---
resource "github_branch_protection" "main" {
  repository_id = github_repository.project_repo.node_id
  pattern       = "main"

  # No direct pushes to main - must go through a PR
  required_pull_request_reviews {
    required_approving_review_count = 1
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = false
  }

  # Ensure the Terraform Plan passes before merging
  required_status_checks {
    strict   = true
    contexts = ["Terraform Plan"] # Must match your workflow job name
  }

  enforce_admins = false # Allow yourself to fix things in an emergency
}

resource "github_repository_environment" "nonprod" {
  environment = "nonprod"
  repository  = github_repository.project_repo.name
  # You can add reviewers here if using a paid/public repo
}




# Secret Injection
locals {
  github_secrets = {
    "AZURE_CLIENT_ID"             = azuread_application.app.client_id
    "AZURE_TENANT_ID"             = data.azurerm_client_config.current.tenant_id
    "AZURE_SUBSCRIPTION_ID"       = data.azurerm_client_config.current.subscription_id
    "AZURE_STATE_STORAGE_ACCOUNT" = azurerm_storage_account.state_sa.name
    "AZURE_STATE_RESOURCE_GROUP"  = azurerm_resource_group.project_rg.name
  }
}

resource "github_actions_secret" "secrets" {
  for_each        = local.github_secrets
  repository      = github_repository.project_repo.name
  secret_name     = each.key
  plaintext_value = each.value
}