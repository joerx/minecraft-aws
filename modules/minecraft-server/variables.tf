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

# variable "max_azs" {
#   default = 3

#   validation {
#     condition     = var.max_azs <= 10
#     error_message = "Only up to 10 AZs are currently supported."
#   }
# }

# variable "vpc_cidr" {
#   default = "10.0.0.0/16"
# }
