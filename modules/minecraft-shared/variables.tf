variable "namespace" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "max_azs" {
  type    = number
  default = 3
}

variable "single_nat_gateway" {
  type    = bool
  default = true # Not HA, but saves some money
}

variable "parent_zone_name" {
  type = string
}

variable "hosted_zone_name" {
  type = string
}
