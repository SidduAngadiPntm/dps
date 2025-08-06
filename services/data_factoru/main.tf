module "s3_bucket" {
  source = "../../terraform_models/s3-bucket"

  bucket_name = "${local.resource_prefix}-s3"

  s3_object_ownership = "BucketOwnerEnforced"
  versioning_enabled  = false
}

module "iam_policy" {
  source = "../../terraform_models/terraform-aws-iam/iam-policy"

  policy = data.aws_iam_policy_document.glue_s3_access.json
  name   = "${local.resource_prefix}-glue-iam-po"

}

module "iam_role" {
  source = "../../terraform_models/terraform-aws-iam/iam-assumable-role"

  custom_role_policy_arns = [module.iam_policy.arn]
  trusted_role_services   = ["glue.amazonaws.com"]
  role_name               = "${local.resource_prefix}-glue-iam-role"
  create_role             = true
  role_requires_mfa       = false
}

module "glue" {
  source = "../../terraform_models/terraform-aws-glue-s3"

  resource_prefix = local.resource_prefix
  role            = module.iam_role.iam_role_arn
  s3_target = [{
    path = format("s3://%s/%s", module.s3_bucket.bucket_id, "personal_banking")
  }]
  # location_uri = format("s3://%s", module.s3_bucket_source.bucket_id)
  # schedule = "cron(0 1 * * ? *)"

  enable_glue_classifier = true
  glue_classifier_csv_classifier = [
    {
      allow_single_column    = false
      contains_header        = "PRESENT"
      delimiter              = ","
      disable_value_trimming = false
      quote_symbol           = "\""
    }
  ]

}
