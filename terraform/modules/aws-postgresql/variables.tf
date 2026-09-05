variable "name_prefix" { type = string }
variable "vpc_id" { type = string }
variable "database_subnet_ids" { type = list(string) }
variable "tags" { type = map(string) }
