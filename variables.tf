variable "vpc_cidr" {
  description = "CIDR block of the VPC to host the server in"
  type        = string
  default     = "10.0.0.0/16"
}

variable "max_azs" {
  description = "Max number of AZs for VPC. If fewer AZs are available, all available AZs will be used. "
  type        = number
  default     = 3

  validation {
    condition     = var.max_azs <= 10
    error_message = "Only up to 10 AZs are currently supported."
  }
}

variable "namespace" {
  description = "Application namespace, used for naming and tagging"
  type        = string
  default     = "minecraft-tf"
}

variable "environment" {
  description = "Application environment, used for tagging"
  type        = string
  default     = "sandbox"
}

variable "minecraft_version" {
  description = "Version of Minecraft server to install"
  type        = string
  default     = "1.19.2"
}
