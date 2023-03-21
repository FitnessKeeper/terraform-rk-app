variable "env" {
  type        = string
  description = "Environment"
}

variable "app" {
  type        = string
  description = "Name of application"
}

variable "ami_id" {
  type        = string
  description = "ID of AMI to deploy via launch configuration"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to provision resources"
}

variable "alb_listener_arn" {
  type        = string
  description = "ARN of ALB listener to which target group should be registered"
  default     = ""
}

variable "max_size" {
  type        = string
  description = "Maximum size of auto scaling group"
  default     = "4"
}

variable "min_size" {
  type        = string
  description = "Minimum size of auto scaling group"
  default     = "2"
}

variable "health_check_grace_period" {
  type        = string
  description = "Time in seconds to wait before beginning health checks"
  default     = 120
}

variable "health_check_type" {
  type        = string
  description = "Type of health check to apply"
  default     = "ELB"
}

variable "wait_for_capacity_timeout" {
  type        = string
  description = "Time in seconds to wait for capacity changes to complete"
  default     = "10m"
}

variable "default_cooldown" {
  default     = "60"
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start. (default: 60)"
}

variable "asg_subnets" {
  type        = list(string)
  description = "List of subnet IDs in which to create app server instances"
}

variable "instance_type" {
  type        = string
  description = "Type of EC2 instance to use for app servers"
  default     = "t2.micro"
}

variable "iam_instance_profile" {
  type        = string
  description = "ARN of IAM profile to associate with app server instances"
}

variable "key_name" {
  type        = string
  description = "EC2 key name to be used for access to app server instances"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group ID associated with load balancer"
}

variable "bastion_security_group_id" {
  type        = string
  description = "Security group ID associated with bastion host"
}

variable "port" {
  type        = string
  description = "Numeric port on which the application listens"
  default     = "8080"
}

variable "protocol" {
  type        = string
  description = "Protocol on which the application listens"
  default     = "HTTP"
}

variable "health_check_path" {
  type        = string
  description = "URL path for HTTP health check"
  default     = "/healthcheck"
}

variable "health_check_interval" {
  type        = string
  description = "Interval in seconds for load balancer health checks"
  default     = "15"
}

variable "health_check_timeout" {
  type        = string
  description = "Time in seconds before load balancer health check times out"
  default     = "5"
}

variable "health_check_healthy_threshold" {
  type        = string
  description = "Number of consecutive successful health checks before service is healthy"
  default     = "2"
}

variable "health_check_unhealthy_threshold" {
  type        = string
  description = "Number of consecutive failed health checks before service is unhealthy"
  default     = "4"
}

variable "health_check_healthy_codes" {
  type        = string
  description = "HTTP response codes to be considered healthy"
  default     = "200,302"
}

variable "associate_public_ip_address" {
  type        = string
  description = "Associate a public IP address with app server instances"
  default     = "false"
}
