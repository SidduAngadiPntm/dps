
# Databse
output "db_id" {
  description = "Glue catalog database ID"
  value       = aws_glue_catalog_database.this.id
}

output "db_name" {
  description = "Glue catalog database name"
  value       = aws_glue_catalog_database.this.name
}

output "db_arn" {
  description = "Glue catalog database ARN"
  value       = aws_glue_catalog_database.this.arn
}

# Crawler
output "crawler_id" {
  description = "Glue crawler ID"
  value       = aws_glue_crawler.this.id
}

output "crawler_name" {
  description = "Glue crawler name"
  value       = aws_glue_crawler.this.name
}

output "crawler_arn" {
  description = "Glue crawler ARN"
  value       = aws_glue_crawler.this.arn
}
