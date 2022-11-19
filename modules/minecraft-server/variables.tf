variable "namespace" {
  default = "minecraft-tf"
}

variable "environment" {
  default = "sandbox"
}

variable "minecraft_version" {
  default = "1.19.2"
}

variable "vpc_id" {
  type = string
}

variable "vpc_subnet_ids" {
  type = list(string)
}

variable "key_name" {
  description = "AWS EC2 key pair name to use with the instance"
  type        = string
}

variable "hosted_zone_id" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}
