module "ecs_development" {
    source          = "./modules"

    region          = "${var.region}"
    project         = "${var.project}"
    stage           = "development"
    vpc_cidr_block  = "${var.vpc_cidr_block}"
    subnet_az       = ["${var.subnet_az}"]
    subnet_newbits  = "${var.subnet_newbits}"

    ecr_image_limit = "${var.ecr_image_limit}"
    log_retention_in_days = 14

    ecs_task_cpu    = 256
    ecs_task_memory = 1024
}

output "development" {
    value {
        vpc_id = "${module.ecs_development.vpc_id}"
        subnets_id = "[${join(",",module.ecs_development.subnets_id)}]"
        subnets_az = "[${join(",",var.subnet_az)}]"
        iam_role_task = "${module.ecs_development.iam_role_task_id}"
        iam_role_execution = "${module.ecs_development.iam_role_execution_id}"
        ecs_arn = "${module.ecs_development.ecs_arn}"
        ecs_task_definition_arn = "${module.ecs_development.ecs_task_definition_arn}"
        ecr = "${module.ecs_development.ecr_url}"
        security_group_id = "${module.ecs_development.security_group_id}"
    }
}
