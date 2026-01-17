data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../infrastructure/terraform.tfstate"
  }
}
