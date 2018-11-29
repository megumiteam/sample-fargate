locals {
    ecr_name = "${lower(local.app_name)}"
}

resource "aws_ecr_repository" "ecr" {
    name = "${local.ecr_name}"
}

resource "aws_ecr_lifecycle_policy" "policy" {
    repository = "${aws_ecr_repository.ecr.name}"

    policy = <<POLICY
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last ${var.ecr_image_limit} images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": ${var.ecr_image_limit}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
POLICY
}