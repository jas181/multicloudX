output "vpc_id" { value = aws_vpc.this.id }
output "private_app_subnet_id" { value = aws_subnet.app.id }
output "private_app_subnet_ids" { value = [aws_subnet.app.id, aws_subnet.app_b.id] }
output "private_database_subnet_id" { value = aws_subnet.database.id }
output "private_database_subnet_ids" { value = [aws_subnet.database.id, aws_subnet.database_b.id] }
