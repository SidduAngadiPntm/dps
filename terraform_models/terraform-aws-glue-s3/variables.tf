variable "resource_prefix" {
  type        = string
  description = "Glue crawler name. If not provided, the name will be generated from the context."
}

variable "tags" {
  description = "pass the tags for resources"
  type        = map(string)
  default     = {}
}
# Glue Database variables
variable "catalog_id" {
  type        = string
  description = "ID of the Glue Catalog to create the database in. If omitted, this defaults to the AWS Account ID."
  default     = null
}

variable "create_table_default_permission" {
  #  type = object({
  #    permissions = list(string)
  #    principal = object({
  #      data_lake_principal_identifier = string
  #    })
  #  })
  # Using `type = any` since some of the the fields are optional and we don't want to force the caller to specify all of them and set to `null` those not used
  type        = any
  description = "Creates a set of default permissions on the table for principals."
  default     = null
}

variable "location_uri" {
  type        = string
  description = "Location of the database (for example, an HDFS path)."
  default     = null
}

variable "parameters" {
  type        = map(string)
  description = "Map of key-value pairs that define parameters and properties of the database."
  default     = null
}

variable "target_database" {
  type = object({
    # If `target_database` is provided (not `null`), all these fields are required
    catalog_id    = string
    database_name = string
  })
  description = " Configuration block for a target database for resource linking."
  default     = null
}




# Glue Crawler








variable "role" {
  type        = string
  description = "The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
}

variable "schedule" {
  type        = string
  description = "A cron expression for the schedule."
  default     = null
}

variable "classifiers" {
  type        = list(string)
  description = "List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification."
  default     = null
}

variable "configuration" {
  type        = string
  description = "JSON string of configuration information."
  default     = null
}

variable "s3_target" {
  #  type = list(object({
  #    path                = string
  #    connection_name     = string
  #    exclusions          = list(string)
  #    sample_size         = number
  #    event_queue_arn     = string
  #    dlq_event_queue_arn = string
  #  }))

  # Using `type = list(any)` since some of the the fields are optional and we don't want to force the caller to specify all of them and set to `null` those not used
  type        = list(any)
  description = "List of nested Amazon S3 target arguments."
  default     = null
}

variable "table_prefix" {
  type        = string
  description = "The table prefix used for catalog tables that are created."
  default     = null
}

variable "security_configuration" {
  type        = string
  description = "The name of Security Configuration to be used by the crawler."
  default     = null
}

variable "schema_change_policy" {
  #  type = object({
  #    delete_behavior = string
  #    update_behavior = string
  #  })

  # Using `type = map(string)` since some of the the fields are optional and we don't want to force the caller to specify all of them and set to `null` those not used
  type        = map(string)
  description = "Policy for the crawler's update and deletion behavior."
  default     = null
}

variable "lineage_configuration" {
  type = object({
    crawler_lineage_settings = string
  })
  description = "Specifies data lineage configuration settings for the crawler."
  default     = null
}

variable "recrawl_policy" {
  type = object({
    recrawl_behavior = string
  })
  description = "A policy that specifies whether to crawl the entire dataset again, or to crawl only folders that were added since the last crawler run."
  default     = null
}

#---------------------------------------------------
# AWS Glue classifier
#---------------------------------------------------
variable "enable_glue_classifier" {
  description = "Enable glue classifier usage"
  default     = false
}

variable "glue_classifier_name" {
  description = "The name of the classifier."
  default     = ""
}

variable "glue_classifier_csv_classifier" {
  description = "(Optional) A classifier for Csv content. "
  default     = []
}

variable "glue_classifier_grok_classifier" {
  description = "(Optional) A classifier for grok content. "
  default     = []
}

variable "glue_classifier_json_classifier" {
  description = "(Optional) A classifier for json content. "
  default     = []
}

variable "glue_classifier_xml_classifier" {
  description = "(Optional) A classifier for xml content. "
  default     = []
}
