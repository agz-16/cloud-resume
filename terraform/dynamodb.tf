
# DynamoDB Table (import existing)

# This table was originally created manually 
# It can be imported into Terraform state using:
#
# terraform import aws_dynamodb_table.cloud_resume_table cloud-resume-test
#
# Importing preserves existing visitor count data.

resource "aws_dynamodb_table" "cloud_resume_table" {
  name         = "cloud-resume-test"   # must match the existing table name exactly
  billing_mode = "PAY_PER_REQUEST"  

  hash_key = "id"                      

  attribute {
    name = "id"
    type = "S"
  }
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.cloud_resume_table.name
  description = "DynamoDB table name"
}