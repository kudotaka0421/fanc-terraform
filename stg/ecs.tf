resource "aws_ecs_cluster" "fanc_api_cluster_stg" {
  name = "fanc-api-cluster-stg"
}

resource "aws_iam_policy" "ecs_task_execution_custom_policy" {
  name        = "ECSTaskExecutionCustomPolicy"
  description = "Additional permissions for ECS Task Execution"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "logs:CreateLogGroup",
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_custom_role_attachment" {
  role       = "ecsTaskExecutionRole"
  policy_arn = aws_iam_policy.ecs_task_execution_custom_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_default_role_attachment" {
  role       = "ecsTaskExecutionRole"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "stg_task_definition" {
  family                   = "fanc-api-definition-task-stg"
  network_mode             = "awsvpc"
  execution_role_arn       = "arn:aws:iam::757245745517:role/ecsTaskExecutionRole"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "3072"

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name      = "fanc-app",
      image     = "757245745517.dkr.ecr.us-east-1.amazonaws.com/fanc-app:latest",
      cpu       = 0,
      essential = true,
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp"
        }
      ],
      environment = [
        { name = "MYSQL_DATABASE", value = var.MYSQL_DATABASE },
        { name = "CORS_ALLOW_ORIGIN", value = var.CORS_ALLOW_ORIGIN },
        { name = "MYSQL_PASSWORD", value = var.MYSQL_PASSWORD },
        { name = "MYSQL_ROOT_PASSWORD", value = var.MYSQL_ROOT_PASSWORD },
        { name = "MYSQL_USER", value = var.MYSQL_USER },
        { name = "SENDGRID_API_KEY", value = var.SENDGRID_API_KEY },
        { name = "JWT_SECRET_KEY", value = var.JWT_SECRET_KEY },
        { name = "MYSQL_HOST", value = var.MYSQL_HOST }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-create-group"  = "true",
          "awslogs-group"         = "/ecs/fanc-api-definition-task-stg",
          "awslogs-region"        = "us-east-1",
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "fanc_api_service_stg" {
  name            = "fanc-api-service-stg"
  cluster         = aws_ecs_cluster.fanc_api_cluster_stg.id
  task_definition = aws_ecs_task_definition.stg_task_definition.arn
  launch_type     = "FARGATE"
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.fanc_stg.arn
    container_name   = "fanc-app"
    container_port   = 8080
  }

  network_configuration {
    subnets = [
      aws_subnet.private_subnet_a.id,
      aws_subnet.private_subnet_b.id
    ]
    security_groups = [aws_security_group.ecs_stg.id]
  }

  depends_on = [
    aws_lb_listener.front_end,
    aws_lb_listener.https_listener_stg
  ]
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.fanc_api_cluster_stg.name}/${aws_ecs_service.fanc_api_service_stg.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "cpu-tracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
