resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-postgres"
  subnet_ids = var.database_subnet_ids
  tags       = var.tags
}

resource "aws_security_group" "database" {
  name        = "${var.name_prefix}-postgres"
  description = "No public ingress; allow workload security groups in a later compute increment."
  vpc_id      = var.vpc_id
  tags        = var.tags
}

resource "aws_db_instance" "this" {
  identifier                  = "${var.name_prefix}-postgres"
  engine                      = "postgres"
  engine_version              = "16"
  instance_class              = "db.t4g.micro"
  allocated_storage           = 20
  max_allocated_storage       = 100
  storage_encrypted           = true
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = [aws_security_group.database.id]
  publicly_accessible         = false
  multi_az                    = false
  backup_retention_period     = 7
  deletion_protection         = true
  skip_final_snapshot         = false
  final_snapshot_identifier   = "${var.name_prefix}-postgres-final"
  manage_master_user_password = true
  username                    = "platformadmin"
  apply_immediately           = false
  copy_tags_to_snapshot       = true
  tags                        = var.tags
}
