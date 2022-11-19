locals {
  host_name = "${random_pet.prefix.id}-${random_string.suffix.id}"

  tags = {
    "app:namespace" = var.namespace
    "app:env"       = var.environment
  }

  minecraft_download_urls = {
    "1.19.2" = "https://piston-data.mojang.com/v1/objects/f69c284232d7c7580bd89a5a4931c3581eae1378/server.jar"
  }

  minecraft_download_url = local.minecraft_download_urls[var.minecraft_version]
}

resource "random_pet" "prefix" {}

resource "random_string" "suffix" {
  upper   = false
  special = false
  length  = 4
}

# Security group
resource "aws_security_group" "sg" {
  name_prefix = "${var.namespace}-sg"
  description = "Security group for Minecraft server"
  vpc_id      = var.vpc_id
  tags        = local.tags

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

resource "aws_eip" "ip" {
  instance = aws_instance.instance.id
  vpc      = true
}

resource "random_shuffle" "subnets" {
  input = var.vpc_subnet_ids
}

resource "aws_instance" "instance" {
  ami                         = data.aws_ami.amazon_linux.id
  associate_public_ip_address = false
  subnet_id                   = random_shuffle.subnets.result[0]
  user_data                   = templatefile("${path.module}/setup.sh", { minecraft_download_url = local.minecraft_download_url })
  key_name                    = var.key_name
  instance_type               = "t2.small"
  vpc_security_group_ids      = [aws_security_group.sg.id]

  tags = merge(local.tags, {
    Name = local.host_name
  })

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_route53_record" "r" {
  zone_id = var.hosted_zone_id
  name    = "${local.host_name}.${var.hosted_zone_name}"
  records = [aws_eip.ip.public_ip]
  type    = "A"
  ttl     = 300
}
