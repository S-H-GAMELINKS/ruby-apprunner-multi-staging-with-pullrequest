resource "aws_ecr_repository" "ecr_image_repository" {
  name                 = "pullrequest-${var.pr_number}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "push-container" {
  triggers = {
    commit_hash = "${var.commit_hash}"
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr_image_repository.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker build -t ${var.pr_number} ../"
  }

  provisioner "local-exec" {
    command = "docker tag ${var.pr_number}:latest ${aws_ecr_repository.ecr_image_repository.repository_url}"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ecr_image_repository.repository_url}"
  }

  depends_on = [
    aws_ecr_repository.ecr_image_repository
  ]
}
