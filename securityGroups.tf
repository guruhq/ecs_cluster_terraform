#
# Security group resources
#
resource "aws_security_group" "container_instance" {
  vpc_id = "${var.vpc_id}"

  tags = {
    Name        = "sgContainerInstance"
    Project     = "${var.project}"
    Environment = "${var.environment}"
  }
}

