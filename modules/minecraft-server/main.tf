locals {
  tags = {
    "app:namespace" = var.namespace
    "app:env"       = var.environment
  }

  minecraft_download_urls = {
    "1.19.2" = "https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar"
  }

  minecraft_download_url = local.minecraft_download_urls[var.minecraft_version]
}

# Security group
resource "aws_security_group" "sg" {
  name_prefix = "${var.namespace}-sg"
  description = "Security group for Minecraft server"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  ingress {
    description = "Minecraft ingress"
    from_port   = 25565
    to_port     = 25565
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = -1
  }
}

# SSH keypair (throwaway)
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name_prefix = var.namespace
  public_key      = tls_private_key.keypair.public_key_openssh
  tags            = local.tags
}

# Deploy an EC2 instance into it
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "random_shuffle" "subnets" {
  input = var.vpc_subnet_ids
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.amazon_linux.id
  associate_public_ip_address = true
  subnet_id                   = random_shuffle.subnets.result[0]
  user_data                   = templatefile("${path.module}/setup.sh", { minecraft_download_url = local.minecraft_download_url })
  key_name                    = aws_key_pair.keypair.key_name
  instance_type               = "t2.small"
  vpc_security_group_ids      = [aws_security_group.sg.id]
}
