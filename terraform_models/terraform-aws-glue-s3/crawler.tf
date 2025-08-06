
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_crawler
resource "aws_glue_crawler" "this" {

  name                   = "${var.resource_prefix}-glue-cwr"
  description            = "${var.resource_prefix}-glue-cwr"
  database_name          = aws_glue_catalog_database.this.name
  role                   = var.role
  schedule               = var.schedule
  classifiers            = var.enable_glue_classifier ? [for c in aws_glue_classifier.this[*] : c.name] : null
  configuration          = var.configuration
  security_configuration = var.security_configuration
  table_prefix           = var.table_prefix

  dynamic "s3_target" {
    for_each = var.s3_target != null ? var.s3_target : []

    content {
      path                = s3_target.value.path
      connection_name     = try(s3_target.value.connection_name, null)
      exclusions          = try(s3_target.value.exclusions, null)
      sample_size         = try(s3_target.value.sample_size, null)
      event_queue_arn     = try(s3_target.value.event_queue_arn, null)
      dlq_event_queue_arn = try(s3_target.value.dlq_event_queue_arn, null)
    }
  }

  dynamic "lineage_configuration" {
    for_each = var.lineage_configuration != null ? [true] : []

    content {
      crawler_lineage_settings = var.lineage_configuration.crawler_lineage_settings
    }
  }

  dynamic "schema_change_policy" {
    for_each = var.schema_change_policy != null ? [true] : []

    content {
      delete_behavior = var.schema_change_policy.delete_behavior
      update_behavior = var.schema_change_policy.update_behavior
    }
  }

  dynamic "recrawl_policy" {
    for_each = var.recrawl_policy != null ? [true] : []

    content {
      recrawl_behavior = var.recrawl_policy.recrawl_behavior
    }
  }

  tags = var.tags
}
