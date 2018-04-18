# terraform-rk-app

===========

Terraform Module for deploying RK App clusters

This module contains a `.terraform-version` file which matches the version of Terraform we currently use to test with.


#### Introduction and Assumptions



Module Input Variables
----------------------
#### Required
- `env`                       - Environment
- `app`                       - Name of application
- `ami_id`                    - ID of AMI to deploy via launch configuration
- `vpc_id`                    - VPC ID in which to provision resources
- `asg_subnets`               - List of subnet IDs in which to create app server instances
- `iam_instance_profile`      - ARN of IAM profile to associate with app server instances
- `key_name`                  - EC2 key name to be used for access to app server instances
- `alb_security_group_id`     - Security group ID associated with load balancer
- `bastion_security_group_id` - Security group ID associated with bastion host

#### Optional

- `alb_listener_arn`                 - ARN of ALB listener to which target group should be registered
- `default_cooldown`                 - The amount of time, in seconds, after a scaling activity completes before another scaling activity can start. (default: 60)
- `max_size`                         - Maximum size of auto scaling group (default: 4)
- `min_size`                         - Minimum size of auto scaling group (default: 2)
- `health_check_grace_period`        - Time in seconds to wait before beginning health checks (default: 120)
- `health_check_type`                - Type of health check to apply (default: ELB)
- `wait_for_capacity_timeout`        - Time in seconds to wait for capacity changes to complete (default: 10m)
- `instance_type`                    - Type of EC2 instance to use for app servers (default: t2.micro)
- `port`                             - Numeric port on which the application listens (default: 8080)
- `protocol`                         - Protocol on which the application listens (default: HTTP)
- `health_check_path`                - URL path for HTTP health check (default: /healthcheck)
- `health_check_interval`            - Interval in seconds for load balancer health checks (default: 15)
- `health_check_timeout`             - Time in seconds before load balancer health check times out (default: 5)
- `health_check_healthy_threshold`   - Number of consecutive successful health checks before service is healthy (default: 2)
- `health_check_unhealthy_threshold` - Number of consecutive failed health checks before service is unhealthy (default: 4)
- `health_check_healthy_codes`       - HTTP response codes to be considered healthy (default: 200,302)
- `associate_public_ip_address`      - Associate a public IP address with app server instances (default: false)

Usage
-----

```hcl

```

Outputs
=======
- `target_group_arn`        - _(String)_ ARN of the target group
- `target_group_arn_suffix` - _(String)_ Target Group ARN suffix
- `target_group_name`       - _(String)_ Target Group Name
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
