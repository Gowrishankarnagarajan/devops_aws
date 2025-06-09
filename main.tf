provider "aws" {
  region = "eu-west-1"
}
resource "aws_instance" "terraform_instance" {
  ami                    = "ami-0bd7827ebb65be011" # Example AMI, replace with a valid Windows AMI
  instance_type          = "t2.micro"
  key_name               = "gs" # Replace with your key pair name
  vpc_security_group_ids = [aws_security_group.gs1.id]
 

  root_block_device {
    volume_size = 30    # Size in GB
    volume_type = "gp2" # General Purpose SSD
  }
  tags = {
    Name = "TerraformWindowsInstance"
  }

}
resource "aws_security_group" "gs1" {
  name        = "terraform_windows_gs1"
  description = "Allow RDP access"

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow RDP from anywhere, consider restricting this in production

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "Public IP of the Windows instance"
  value       = aws_instance.terraform_instance.public_ip
}