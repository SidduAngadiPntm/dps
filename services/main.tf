resource "aws_s3_bucket" "raw_data" {
  bucket = "carbon-raw-data"
  force_destroy = true
}

resource "aws_s3_bucket" "Staging_data" {
  bucket = "carbon-staging-data"
   force_destroy = true
}
resource "aws_s3_bucket" "processed_data" {
  bucket = "carbon-processed-data"
   force_destroy = true
}
#s3 bucket for Athena results
# resource "aws_s3_bucket" "athena_results" {
#   bucket = "my-athena-results-bucket"
#     force_destroy = true
# }

# resource "aws_s3_bucket_acl" "athena_results_acl" {

#   bucket = aws_s3_bucket.athena_results.id
#   acl    = "private"
# }

# resource "aws_s3_bucket_ownership_controls" "athena_results_ownership" {
#   bucket = aws_s3_bucket.athena_results.id

#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "athena_results_public_access" {
#   bucket                  = aws_s3_bucket.athena_results.id
#   block_public_acls       = true
#   block_public_policy     = true
#   ignore_public_acls      = true
#   restrict_public_buckets = true
# }


# IAM Role trust policy, to allow Glue service to assume this role
data "aws_iam_policy_document" "glue_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["glue.amazonaws.com"]
    }
  }
}

# Create IAM Role for Glue
resource "aws_iam_role" "glue_role" {
  name               = "carbon-glue-role"
  assume_role_policy = data.aws_iam_policy_document.glue_assume_role.json
}

# Attach managed policy for basic Glue permissions
resource "aws_iam_role_policy_attachment" "glue_managed_policy" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Inline policy granting access to specific S3 buckets
resource "aws_iam_policy" "glue_s3_access_policy" {
  name        = "carbon-glue-s3-access"
  description = "Allow Glue to access Carbon S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.raw_data.arn,
          "${aws_s3_bucket.raw_data.arn}/*",
          aws_s3_bucket.processed_data.arn,
          "${aws_s3_bucket.processed_data.arn}/*"
        ]
      }
    ]
  })
}

# Attach the inline policy to the Glue role
resource "aws_iam_role_policy_attachment" "glue_s3_access_attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_s3_access_policy.arn
}

resource "aws_glue_catalog_database" "carbon_db" {
  name        = "carbondb"
  description = "Glue Catalog database for Carbon data pipeline"
}

#creating crawler 
resource "aws_glue_crawler" "carbon_raw_crawler" {
  name          = "carbon-raw-data-crawler"
  database_name = aws_glue_catalog_database.carbon_db.name
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${aws_s3_bucket.raw_data.bucket}"
  }

  schedule    = "cron(0 12 * * ? *)"  # Optional: daily at 12 PM UTC
  description = "Crawler for raw carbon data in S3"
  table_prefix = "raw_"

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}
