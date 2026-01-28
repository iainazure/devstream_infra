locals {
  projects = {
    "test-devstream-repo" = { org = "iainazure", loc = "UK South" }
  }
}

module "vending_machine" {
  source   = "../../github_repo_vending"
  for_each = local.projects
  repo_name = "${each.key}-infra"
  github_org         = each.value.org
  location           = each.value.loc
  template_repo_name = "devstream_infra_template"
}