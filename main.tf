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

data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

data "aws_alb" "app" {
  arn = "${var.alb_arn}"
  name = "${var.alb_name}"
}

data "aws_ami" "app" {
  most_recent = true
  executable_users = ["self"]
  owners = ["${data.aws_caller_identity.current.account_id}"]

  filter {
    name = "name"
    values = ["${var.ami_name}"]
  }
}

resource "aws_autoscaling_group" "app" {
  name-prefix = "tf-asg-${data.aws_vpc.vpc.tags["Name"]}-${var.app}-"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  desired_capacity = "${var.desired_capacity}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type = "${var.health_check_type}"
  termination_policies = ["OldestLaunchConfiguration", "ClosestToNextInstanceHour", "Default"]
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  metrics_granularity = "1Minute"
  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  target_group_arns = ["${aws_alb_target_group.app.id}"]
  launch_configuration = "${aws_launch_configuration.app.name}"
  vpc_zone_identifier = ["${var.asg_subnets}"]

  tags [
    {
      key = "Name"
      value = "tf-asg-${data.aws_vpc.vpc.tags["Name"]}-${var.app}-"
      propagate_at_launch = true
    },
    {
      key = "App"
      value = "${var.app}"
      propagate_at_launch = true
    }
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "app" {
  name-prefix = "tf-lc-${data.aws_vpc.vpc.tags["Name"]}-${var.app}-"
  image_id = "${data.aws_ami.app.id}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.iam_instance_profile}"
  key_name = "${var.key_name}"
  security_groups = ["${var.security_groups}"]
  associate_public_ip_address = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "app" {
  name-prefix = "tf-tg-${data.aws_vpc.vpc.tags["Name"]}-${var.app}-"
  port = "${var.port}"
  protocol = "${var.app_protocol}"
  vpc_id = "${data.aws_vpc.vpc.id}"

  health_check {
    path = "${health_check_path}"
    interval = "${var.health_check_interval}"
    timeout = "${var.health_check_timeout}"
    healthy_threshold = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
  }

  lifecycle {
    create_before_destroy = true
  }
}