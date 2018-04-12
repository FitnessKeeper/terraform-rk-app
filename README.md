# terraform-rk-app

===========

Terraform Module for deploying RK App clusters

This module contains a `.terraform-version` file which matches the version of Terraform we currently use to test with.


#### Introduction and Assumptions



Module Input Variables
----------------------
#### Required
- `alb_log_bucket` - s3 bucket to send ALB Logs


#### Optional

- `vault_image` - Image to use when deploying vault, (Default: hashicorp/vault)

Usage
-----

```hcl

```

Outputs
=======
- `target_group_arn`        - _(String)_ ARN of the target group
- `target_group_arn_suffix` - _(String)_ Target Group ARN suffix 
- `ami_name`                - _(String)_ AMI Name
- `autoscaling_group_arn`   - _(String)_ The ARN for this AutoScaling Group
- `autoscaling_group_id`    - _(String)_ The autoscaling group id
- `autoscaling_group_name`  - _(String)_ The name of the autoscale group

Authors
=======

* [Tim Hartmann](https://github.com/tfhartmann)
* [Steve Huff](https://github.com/hakamadare)
License
=======

[MIT](LICENSE)
