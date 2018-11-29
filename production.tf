module "ecs_production" {
    source          = "./modules"

    region          = "${var.region}"
    project         = "${var.project}"
    stage           = "production"
    vpc_cidr_block  = "${var.vpc_cidr_block}"
    subnet_az       = ["${var.subnet_az}"]
    subnet_newbits  = "${var.subnet_newbits}"

    ecr_image_limit = "${var.ecr_image_limit}"
    log_retention_in_days = 90

    ecs_task_cpu    = 512
    ecs_task_memory = 2048
}

output "production" {
    value {
        vpc_id = "${module.ecs_production.vpc_id}"
        subnets_id = "[${join(",",module.ecs_production.subnets_id)}]"
        subnets_az = "[${join(",",var.subnet_az)}]"
        iam_role_id = "${module.ecs_production.iam_role_id}"
        iam_role_execution_id = "${module.ecs_production.iam_role_execution_id}"
        ecs_arn = "${module.ecs_production.ecs_arn}"
        ecs_task_definition_arn = "${module.ecs_production.ecs_task_definition_arn}"
        ecr = "${module.ecs_production.ecr_url}"
        security_group_id = "${module.ecs_production.security_group_id}"
    }
}