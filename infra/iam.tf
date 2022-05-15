resource "aws_iam_role" "apprunner-service-role" {
  name               = "pullrequest-${var.pr_number}-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.apprunner-service-assume-policy.json

  depends_on = [
    aws_ecr_repository.ecr_image_repository,
    null_resource.push-container
  ]
}

data "aws_iam_policy_document" "apprunner-service-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    sid = ""

    principals {
      type        = "Service"
      identifiers = [
        "tasks.apprunner.amazonaws.com",
        "build.apprunner.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "apprunner-service-role-attachment" {
  role       = aws_iam_role.apprunner-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"

  depends_on = [
    aws_ecr_repository.ecr_image_repository,
    null_resource.push-container,
    aws_iam_role.apprunner-service-role
  ]
}
