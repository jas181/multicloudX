output "autoscaling_group_name" { value = aws_autoscaling_group.app.name }
output "internal_load_balancer_dns_name" { value = aws_lb.internal.dns_name }
