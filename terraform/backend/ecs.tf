data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

# ECS
resource "aws_ecs_cluster" "backend" {
  name = "backend"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "backend" {
  name            = "backend"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = var.backend_port
  }

  network_configuration {
    subnets         = [
      data.terraform_remote_state.common.outputs.private-subnet-a-id,
      data.terraform_remote_state.common.outputs.private-subnet-b-id
    ]
    security_groups = [aws_security_group.backend.id]
  }
}

resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.backend.arn
  cpu                      = var.backend_cpu
  memory                   = var.backend_memory
  container_definitions    = jsonencode(
[
  {
    name = "backend"
    image = "${data.terraform_remote_state.ci.outputs.backend_repository_url}:${var.git_sha}"
    cpu = var.backend_cpu
    memory = var.backend_memory
    mountPoints = []
    volumesFrom = []
    essential = true
    portMappings = [
      {
          containerPort = var.backend_port
          hostPort = var.backend_port
          protocol = "tcp"
      }
    ]
    networkMode = "awsvpc"
    logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = aws_cloudwatch_log_group.backend.name
          awslogs-region = data.aws_region.current.name
          awslogs-stream-prefix = "backend-"
        }
    },
    environment = [
      {
        name = "PORT"
        value = "4000"
      },
      {
        name = "GIT_SHA"
        value = var.git_sha
      }
    ]
  }
])
}

resource "aws_cloudwatch_log_group" "backend" {
  name              = "backend"
  retention_in_days = 365
}

# IAM
resource "aws_iam_role" "backend" {
  name               = "backend"
  assume_role_policy = jsonencode(
{
  Version = "2012-10-17"
  Statement = [
    {
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }
  ]
})
}

resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.backend.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
