variable "app" {
  type = "string"
  description = "Name of application"
}

variable "ami_name" {
  type = "string"
  description = "Name of AMI to deploy via launch configuration"
}

variable "vpc_id" {
  type = "string"
  description = "VPC ID in which to provision resources"
}

variable "alb_arn" {
  type = "string"
  description = "ARN of ALB to which target group should be registered (must provide this or alb_name)"
  default = ""
}

variable "alb_name" {
  type = "string"
  description = "Name of ALB to which target group should be registered (must provide this or alb_arn)"
  default = ""
}

variable "role_name" {
  type = "string"
  description = "Name of IAM role under which app server instances should run"
}

variable "max_size" {
  type = "string"
  description = "Maximum size of auto scaling group"
  default = "4"
}

variable "min_size" {
  type = "string"
  description = "Minimum size of auto scaling group"
  default = "2"
}

variable "desired_capacity" {
  type = "string"
  description = "Desired capacity at creation of auto scaling group"
  default = "2"
}

variable "health_check_grace_period" {
  type = "string"
  description = "Time in seconds to wait before beginning health checks"
  default = 120
}

variable "health_check_type" {
  type = "string"
  description = "Type of health check to apply"
  default = "ELB"
}

variable "wait_for_capacity_timeout" {
  type = "string"
  description = "Time in seconds to wait for capacity changes to complete"
  default = "600"
}

variable "asg_subnets" {
  type = "list"
  description = "List of subnet IDs in which to create app server instances"
}

variable "instance_type" {
  type = "string"
  description = "Type of EC2 instance to use for app servers"
  default = "t2.micro"
}

variable "iam_instance_profile" {
  type = "string"
  description = "ARN of IAM profile to associate with app server instances"
}

variable "key_name" {
  type = "string"
  description = "EC2 key name to be used for access to app server instances"
}

variable "alb_security_group_id" {
  type = "list"
  description = "Security group ID associated with load balancer"
}

variable "bastion_security_group_id" {
  type = "list"
  description = "Security group ID associated with bastion host"
}

variable "port" {
  type = "string"
  description = "Numeric port on which the application listens"
  default = "8080"
}

variable "protocol" {
  type = "string"
  description = "Protocol on which the application listens"
  default = "HTTP"
}

variable "health_check_path" {
  type = "string"
  description = "URL path for HTTP health check"
  default = "/healthcheck"
}

variable "health_check_interval" {
  type = "string"
  description = "Interval in seconds for load balancer health checks"
  default = "15"
}

variable "health_check_timeout" {
  type = "string"
  description = "Time in seconds before load balancer health check times out"
  default = "5"
}

variable "health_check_healthy_threshold" {
  type = "string"
  description = "Number of consecutive successful health checks before service is healthy"
  default = "2"
}

variable "health_check_unhealthy_threshold" {
  type = "string"
  description = "Number of consecutive failed health checks before service is unhealthy"
  default = "4"
}
