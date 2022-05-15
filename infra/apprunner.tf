resource "time_sleep" "wait_60_seconds" {
  depends_on = [
    aws_ecr_repository.ecr_image_repository,
    null_resource.push-container,
    aws_iam_role.apprunner-service-role
  ]

  create_duration = "60s"
}

resource "aws_apprunner_service" "apprunner_service" {
  service_name = "pullrequest-${var.pr_number}"

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner-service-role.arn
    }
    image_repository {
      image_configuration {
        port = "4567"
        start_command = "bundle exec ruby main.rb"
      }
      image_identifier      = "${aws_ecr_repository.ecr_image_repository.repository_url}:latest"
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = true
  }

  tags = {
    Name = "pullrequest-${var.pr_number}"
  }

  instance_configuration {
    instance_role_arn = aws_iam_role.apprunner-service-role.arn
  }

  depends_on = [time_sleep.wait_60_seconds]
}

output "app_runner_url" {
  value = aws_apprunner_service.apprunner_service.service_url
  depends_on = [aws_apprunner_service.apprunner_service]
}
