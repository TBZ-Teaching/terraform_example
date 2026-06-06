output "state_bucket" {
  value       = aws_s3_bucket.tf_state.bucket
  description = "S3 bucket name for remote Terraform state"
}

output "backend_init_example" {
  value = join(" ", compact([
    "terraform init",
    format("-backend-config=\"bucket=%s\"", aws_s3_bucket.tf_state.bucket),
    "-backend-config=\"key=state/main/terraform.tfstate\"",
    format("-backend-config=\"region=%s\"", var.region),
  ]))

  description = "Example terraform init command to configure the root module backend"
}
