resource "aws_cloudwatch_log_group" "log" {
    name = "${local.awslogs}-log"
    retention_in_days = "${var.log_retention_in_days}"

    tags {
        Name    = "${local.awslogs}-log"
        project = "${var.project}"
        stage   = "${var.stage}"
        "user:Cost Center" = "${var.project}-${var.stage}"
    }
}
