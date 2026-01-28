locals {
  projects = {
    "test-devstream-repo" = { org = "iainazure", loc = "UK South" , template_repo = "python-ds-template" }
  }
}

module "vending_machine" {
  source   = "../../github_repo_vending"
  for_each = local.projects
  repo_name = "${each.key}"
  github_org         = each.value.org
  location           = each.value.loc
  template_repo_name = each.value.template_repo
}