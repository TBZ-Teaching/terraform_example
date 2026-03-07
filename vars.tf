# Input variable: server port
variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default = "80"
}

# Input variable: instance name
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  default     = "terraform-example-default"
}