# terraform-rk-app
#
# Provisions a Runkeeper app server cluster
#
# Inputs:
# * VPC name
# * ALB name or ALB ARN
# * AMI name or AMI ID
#
# Outputs:
# * ALB FQDN

data "aws_caller_identity" "current" {
}

data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_ssm_parameter" "ami_id_param" {
  name           = "/${var.env}/${var.app}/webapi_ami_id"
  description    = "AMI ID to be used for webapi_secondary/tertiary instances"
  type           = "String"
  # This is a bit tricky. When ami_id is "" we want to lookup the existing value from the data object to make this sticky/noop. When it's passed we want to set the new value passed.
  insecure_value = var.ami_id != "" ? var.ami_id : nonsensitive(data.aws_ssm_parameter.ami_id_param[0].value)
  overwrite      = true
  data_type      = "aws:ec2:image"
}

data "aws_ssm_parameter" "ami_id_param" {
  # Only create this data object when var.ami_id is empty string (the default value when not set)
  count = var.ami_id != "" ? 0 : 1
  name  = "/${var.env}/${var.app}/webapi_ami_id"
}

resource "aws_autoscaling_group" "app" {
  name                      = "tf-asg-${aws_launch_configuration.app.name}"
  max_size                  = var.max_size
  min_size                  = var.min_size
  min_elb_capacity          = var.min_size
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown
  health_check_type         = var.health_check_type
  termination_policies      = ["OldestLaunchConfiguration", "ClosestToNextInstanceHour", "Default"]
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  metrics_granularity       = "1Minute"
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  target_group_arns         = [aws_alb_target_group.app.id]
  launch_configuration      = aws_launch_configuration.app.name
  vpc_zone_identifier       = var.asg_subnets

  tag {
    key                 = "Name"
    value               = "AS-${var.env}-${var.app}"
    propagate_at_launch = true
  }
  tag {
    key                 = "App"
    value               = var.app
    propagate_at_launch = true
  }
  tag {
    key                 = "CrowdStrikeEnv"
    value               = "production"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "app" {
  name_prefix                 = "tf-lc-${data.aws_vpc.vpc.tags["Name"]}-${var.app}-"
  image_id                    = var.ami_id != "" ? var.ami_id : nonsensitive(data.aws_ssm_parameter.ami_id_param[0].value)
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  security_groups             = [aws_security_group.app.id]
  associate_public_ip_address = var.associate_public_ip_address

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "app" {
  name     = "tf-tg-${data.aws_vpc.vpc.tags["Name"]}-${var.app}"
  port     = var.port
  protocol = var.protocol
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_healthy_codes
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "app" {
  name_prefix = "tf-sg-${data.aws_vpc.vpc.tags["Name"]}-${var.app}-"
  description = "${var.app} application server security group"
  vpc_id      = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "app_ingress" {
  type                     = "ingress"
  from_port                = var.port
  to_port                  = var.port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
  security_group_id        = aws_security_group.app.id
}

resource "aws_security_group_rule" "ssh_ingress" {
  type                     = "ingress"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
  source_security_group_id = var.bastion_security_group_id
  security_group_id        = aws_security_group.app.id
}

resource "aws_security_group_rule" "app_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.app.id
}
