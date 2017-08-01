output "target_group_arn" {
  value = "${aws_alb_target_group.app.arn}"
}

output "target_group_arn_suffix" {
  value = "${aws_alb_target_group.app.arn_suffix}"
}
