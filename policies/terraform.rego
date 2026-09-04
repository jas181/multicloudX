package main

deny contains msg if {
  some resource in input.resource_changes
  resource.type == "aws_s3_bucket"
  not resource.change.after.server_side_encryption_configuration
  msg := sprintf("%s: S3 bucket must enable encryption", [resource.address])
}

deny contains msg if {
  some resource in input.resource_changes
  resource.type == "aws_security_group_rule"
  resource.change.after.cidr_blocks[_] == "0.0.0.0/0"
  resource.change.after.from_port == 22
  msg := sprintf("%s: SSH cannot be internet-accessible", [resource.address])
}

deny contains msg if {
  some resource in input.resource_changes
  resource.type == "aws_db_instance"
  resource.change.after.publicly_accessible == true
  msg := sprintf("%s: databases must be private", [resource.address])
}

deny contains msg if {
  some resource in input.resource_changes
  resource.change.after.tags
  required := ["application", "environment", "owner", "cost_center", "managed_by"]
  some key in required
  not resource.change.after.tags[key]
  msg := sprintf("%s: missing required tag %s", [resource.address, key])
}
