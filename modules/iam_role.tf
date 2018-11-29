// task role
data "template_file" "ecs_assume_role_policy" {
    template = "${file("${path.module}/ecs_assume_role_policy.json")}"

    vars {
        region = "${var.region}"
        aws_id = "${data.aws_caller_identity.current.account_id}"
        stage  = "${var.stage}"
    }
}
resource "aws_iam_role" "ecs_task" {
    name = "${local.app_name}_ecs"
    assume_role_policy = "${data.template_file.ecs_assume_role_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
    role       = "${aws_iam_role.ecs_task.id}"
}
resource "aws_iam_role_policy_attachment" "ecs_task" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    role       = "${aws_iam_role.ecs_task.id}"
}
resource "aws_iam_role_policy_attachment" "ecr_power_user" {
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
    role       = "${aws_iam_role.ecs_task.id}"
}

data "template_file" "ecs_task_role_policy" {
    template = "${file("${path.module}/ecs_task_role_policy.json")}"

    vars {
        region          = "${var.region}"
        aws_id          = "${data.aws_caller_identity.current.account_id}"
        stage           = "${var.stage}"
        awslogs         = "${local.awslogs}"
    }
}
resource "aws_iam_policy" "ecs_task_role_policy" {
    name        = "${local.app_name}_task_role_policy"
    policy      = "${data.template_file.ecs_task_role_policy.rendered}"
}
resource "aws_iam_role_policy_attachment" "ecs_task_role" {
    role       = "${aws_iam_role.ecs_task.id}"
    policy_arn = "${aws_iam_policy.ecs_task_role_policy.arn}"
}

// execution role
data "template_file" "ecs_execution_assume_role_policy" {
    template = "${file("${path.module}/ecs_execution_assume_role_policy.json")}"

    vars {
        region = "${var.region}"
        aws_id = "${data.aws_caller_identity.current.account_id}"
        stage  = "${var.stage}"
    }
}
resource "aws_iam_role" "ecs_execution" {
    name = "${local.app_name}_execution"
    assume_role_policy = "${data.template_file.ecs_execution_assume_role_policy.rendered}"
}
resource "aws_iam_role_policy_attachment" "ecs_execution" {
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
    role       = "${aws_iam_role.ecs_execution.id}"
}
