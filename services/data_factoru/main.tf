module "s3_bucket" {
  source = "../../terraform_models/s3-bucket"

  bucket_name = "${local.resource_prefix}-s3"

  s3_object_ownership = "BucketOwnerEnforced"
  versioning_enabled  = false
}
