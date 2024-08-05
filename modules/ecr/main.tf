resource "aws_ecr_repository" "ecr_repo" {
    name = "ecr-${var.suffix}"
    tags = {
        Application = var.suffix
    }
}

resource "aws_ecr_lifecycle_policy" "ecr_repo_policy" {
    repository = aws_ecr_repository.ecr_repo.name
    policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Keep last n images",
                "selection": {
                    "tagStatus":"any",
                    "countType": "imageCountMoreThan",
                    "countName": ${var.image_count}
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
    EOF
}