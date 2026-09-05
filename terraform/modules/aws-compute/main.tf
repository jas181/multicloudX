resource "aws_security_group" "load_balancer" {
  name        = "${var.name_prefix}-internal-alb"
  description = "Internal application load balancer"
  vpc_id      = var.vpc_id
  ingress {
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["10.50.0.0/16"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_security_group" "application" {
  name        = "${var.name_prefix}-application"
  description = "Application instances accept traffic only from internal ALB"
  vpc_id      = var.vpc_id
  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.load_balancer.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

resource "aws_lb" "internal" {
  name               = "${var.name_prefix}-internal"
  internal           = true
  load_balancer_type = "application"
  subnets            = var.app_subnet_ids
  security_groups    = [aws_security_group.load_balancer.id]
  tags               = var.tags
}

resource "aws_lb_target_group" "app" {
  name     = "${var.name_prefix}-app"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/health"
    matcher = "200-399"
  }
  tags = var.tags
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 8080
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_launch_template" "app" {
  name_prefix            = "${var.name_prefix}-app-"
  image_id               = var.ami_id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.application.id]
  metadata_options { http_tokens = "required" }
  monitoring { enabled = true }
  user_data = base64encode("#!/bin/bash\necho multicloudx > /var/tmp/bootstrap")
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.name_prefix}-app"
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = var.app_subnet_ids
  health_check_type   = "ELB"
  target_group_arns   = [aws_lb_target_group.app.arn]
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-app"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "cpu" {
  name                   = "${var.name_prefix}-cpu"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70
  }
}
