resource "aws_ecr_repository" "default" {
  name                 = "${data.terraform_remote_state.infra.outputs.resource_prefix}-ecr"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
