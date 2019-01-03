#
# Security group resources
#
resource "aws_security_group" "container_instance" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name        = "sg${var.environment}${var.project}ContainerInstance"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

