variable "project"    { default = "SampleProject" }
variable "stage"      {}
locals {
    app_name = "${var.project}-${var.stage}"
    awslogs  = "/aws/fargate/${local.app_name}"
}

variable "region"          { default = "us-east-1" }

variable "ecs_task_cpu"    { default = 512 }
variable "ecs_task_memory" { default = 2048 }

variable "ecr_image_limit" { default = 150 }
variable "log_retention_in_days" { default = 90 }

variable "vpc_cidr_block"  { default = "172.31.0.0/16" }
variable "subnet_az"       {
    type = "list"
    default = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c",
        "us-east-1d",
        "us-east-1e",
        "us-east-1f"
    ]
}
variable "subnet_newbits"  { default = 8 }

data "aws_caller_identity" "current" {}
