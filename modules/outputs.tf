output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
}
output "subnets_id" {
    value = "${aws_subnet.subnets.*.id}"
}
output "iam_role_task_id" {
    value = "${aws_iam_role.ecs_task.id}"
}
output "iam_role_execution_id" {
    value = "${aws_iam_role.ecs_execution.id}"
}
output "ecs_arn" {
    value = "${aws_ecs_cluster.ecs.arn}"
}
output "ecs_task_definition_arn" {
    value = "${aws_ecs_task_definition.task.arn}"
}
output "ecr_url" {
    value = "${aws_ecr_repository.ecr.repository_url}"
}
output "ecr_id" {
    value = "${aws_ecr_repository.ecr.id}"
}
output "security_group_id" {
    value = "${aws_security_group.ecs.id}"
}
