output "state_bucket" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "S3 bucket name for remote Terraform state"
}

output "lock_table" {
  value       = var.lock_table_name == "" ? "" : aws_dynamodb_table.tf_lock[0].name
  description = "DynamoDB table name for state locking (empty if disabled)"
}

output "backend_init_example" {
  value = join(" ", compact([
    "terraform init",
    format("-backend-config=\"bucket=%s\"", aws_s3_bucket.tf_state.bucket),
    "-backend-config=\"key=state/main/terraform.tfstate\"",
    format("-backend-config=\"region=%s\"", var.region),
    var.lock_table_name == "" ? "" : format("-backend-config=\"dynamodb_table=%s\"", aws_dynamodb_table.tf_lock[0].name),
  ]))

  description = "Example terraform init command to configure the root module backend"
}
