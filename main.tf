# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create a Security Group for an EC2 instance 
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  
  ingress {
    from_port	  = "${var.server_port}"
    to_port	    = "${var.server_port}"
    protocol	  = "tcp"
    cidr_blocks	= ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami			                = "ami-0071174ad8cbb9e17" # Ubuntu 24.04 LTS (Noble Numbat)
  instance_type           = "t2.micro"
  vpc_security_group_ids  = ["${aws_security_group.instance.id}"]
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, Modul 300" > index.html
              nohup python3 -m http.server "${var.server_port}" &
              EOF
			  
  tags = {
    Name = "terraform-example"
  }

}
