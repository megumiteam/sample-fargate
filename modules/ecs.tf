resource "aws_ecs_cluster" "ecs" {
    name = "${local.app_name}_ecs"
}

data "template_file" "ecs_task_service" {
    template = "${file("${path.module}/ecs_task_service.json")}"

    vars {
        region             = "${var.region}"
        stage              = "${var.stage}"
        app_name           = "${local.app_name}"
        awslogs            = "${local.awslogs}"
        image              = "${aws_ecr_repository.ecr.repository_url}:latest"
        cpu                = "${var.ecs_task_cpu}"
        memory             = "${var.ecs_task_memory}"
    }
}

resource "aws_ecs_task_definition" "task" {
    family                = "${local.app_name}_task"
    container_definitions = "${data.template_file.ecs_task_service.rendered}"
    requires_compatibilities = ["FARGATE"]
    task_role_arn         = "${aws_iam_role.ecs_task.arn}"
    execution_role_arn    = "${aws_iam_role.ecs_execution.arn}"
    network_mode          = "awsvpc"
    cpu                   = "${var.ecs_task_cpu}"
    memory                = "${var.ecs_task_memory}"
}