#
# ECS resources
#
resource "aws_ecs_cluster" "container_instance" {
  name = "${var.environment}-${var.project}-cluster"
}

