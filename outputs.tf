output "target_group_arn" {
  value = "${aws_alb_target_group.app.arn}"
}

output "target_group_arn_suffix" {
  value = "${aws_alb_target_group.app.arn_suffix}"
}

output "ami_name" {
  value = "${data.aws_ami.app.name}"
}
