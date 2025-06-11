provider "aws" {
  region = var.aws_region
}

# Get the Latest AMI ID
data "aws_ami" "ubuntu_24_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Use the Existing VPC ID
data "aws_vpc" "existing" {
  id = var.existing_vpc_id
}

# Use the Existing subnet
data "aws_subnet" "existing" {
  id = var.existing_subnet_id
}

# Use the existing security group
data "aws_security_group" "existing" {
  id = var.existing_security_group_id
}

resource "aws_instance" "DMA_app" {
  ami                    = data.aws_ami.ubuntu_24_04.id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = var.vol_size       
    volume_type = var.vol_type  
    delete_on_termination = false
  }

  tags = {
    Name = "DMA_Application"
  }
}

output "instance_public_ip" {
  value = aws_instance.DMA_app.public_ip
}
