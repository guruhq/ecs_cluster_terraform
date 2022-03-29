#
# AutoScaling resources
#
data "template_cloudinit_config" "container_instance_cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/cloud-config/base-container-instance.yml.tpl", {
      ecs_cluster_name = aws_ecs_cluster.container_instance.name
    })
  }

  part {
    content_type = "text/cloud-config"
    content      = "${var.cloud_config}"
  }
}

resource "aws_launch_configuration" "container_instance" {
  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type = "${var.root_block_device_type}"
    volume_size = "${var.root_block_device_size}"
    encrypted   = "${var.root_block_device_encrypted}"
  }

  iam_instance_profile = "${aws_iam_instance_profile.container_instance.name}"
  image_id             = "${var.ami_id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"
  security_groups      = var.security_groups
  user_data            = "${data.template_cloudinit_config.container_instance_cloud_config.rendered}"
}

resource "aws_autoscaling_group" "container_instance" {
  name                      = "asg${var.environment}${var.project}ContainerInstance"
  launch_configuration      = "${aws_launch_configuration.container_instance.name}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "EC2"
  desired_capacity          = "${var.desired_capacity}"
  termination_policies      = ["OldestLaunchConfiguration", "Default"]
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  enabled_metrics           = "${var.enabled_metrics}"
  vpc_zone_identifier       = "${var.private_subnet_ids}"


  tags = [
    {
      key                 = "Name"
      value               = "${var.environment}-${var.project}-ContainerInstance"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "${var.project}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    { 
      key                 = "Managed By"
      value               = "Terraform"
      propagate_at_launch = true
    },
    {
      key                 = "Inspector Scan"
      value               = "${var.inspector_scanned}"
      propagate_at_launch = true
    }
  ]
}

