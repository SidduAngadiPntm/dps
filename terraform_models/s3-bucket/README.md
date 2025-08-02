# Introduction
  This module enables :
  - Create the S3 bucket
  - Enable the replication and lifecycle policy


# usage:

  ''''
  '''

    module "s3_bucket" {
      source = "../s3-bucket"

      bucket_name = "${local.resource_name}-sftp-s3"

      s3_object_ownership      = "BucketOwnerEnforced"
      versioning_enabled       = false
    }


  ''''
  '''
