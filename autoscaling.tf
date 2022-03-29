#
# AutoScaling resources
#
resource "aws_launch_configuration" "container_instance" {
  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "${var.root_block_device_type}"
    volume_size = "${var.root_block_device_size}"
  }

  iam_instance_profile = "${aws_iam_instance_profile.container_instance.name}"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = var.security_groups
  user_data            = templatefile("${path.module}/cloud-config/base-container-instance.yml.tpl", {
    ecs_cluster_name = aws_ecs_cluster.container_instance.name
    cloud_config     = var.cloud_config
  })
}

resource "aws_autoscaling_group" "container_instance" {
  name                      = "asg${var.environment}ContainerInstance"
  launch_configuration      = "${aws_launch_configuration.container_instance.name}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "EC2"
  desired_capacity          = "${var.desired_capacity}"
  termination_policies      = ["OldestLaunchConfiguration", "Default"]
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  enabled_metrics           = var.enabled_metrics
  vpc_zone_identifier       = var.private_subnet_ids

  tag {
    key                 = "Name"
    value               = "${var.environment}-ContainerInstance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = true
  }
  
  tag {
    key                 = "Managed By"
    value               = "Terraform"
    propagate_at_launch = true
  }

  tag {
    key                 = "Inspector Scan"
    value               = "${var.inspector_scanned}"
    propagate_at_launch = true
  }
}

