##################################################################################
# VARIABLES
##################################################################################

variable "region" {
  default = "us-east-1"
}

variable "web_subnet_count" {
  default = 1
}

variable "web_cidr_block" {
  default = "10.1.0.0/16"
}

variable "web_private_subnets" {
  type = list
}

variable "web_public_subnets" {
  type = list
}

variable "key_name" {}

variable "private_key_path" {}

variable "my_ip" {}
