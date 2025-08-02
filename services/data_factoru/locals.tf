locals {
  aws_region      = data.aws_region.current.name
  resource_prefix = "${var.project_name}-${var.env_name}"
}
