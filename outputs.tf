output "target_group_arn" {
  value = aws_alb_target_group.app.arn
}

output "target_group_arn_suffix" {
  value = aws_alb_target_group.app.arn_suffix
}

output "target_group_name" {
  value = aws_alb_target_group.app.name
}

output "ami_name" {
  value = aws_ssm_parameter.ami_id_param.insecure_value
}

output "autoscaling_group_arn" {
  value = aws_autoscaling_group.app.arn
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.app.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.app.name
}
