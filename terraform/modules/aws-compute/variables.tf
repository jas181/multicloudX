variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "app_subnet_ids" { type = list(string) }
variable "ami_id" { type = string }
variable "tags" { type = map(string) }
