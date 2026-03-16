variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally-unique S3 bucket name for Terraform remote state"
  type        = string
}

variable "lock_table_name" {
  description = "Optional DynamoDB table name for Terraform state locking (leave empty to disable)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags applied to bootstrap resources"
  type        = map(string)
  default = {
    project = "terraform-example"
  }
}
