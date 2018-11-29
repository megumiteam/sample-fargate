## Security Group for EC2
##
resource "aws_security_group" "ecs" {
    lifecycle {
        ignore_changes = [
            "description"
        ]
    }

    name        = "${local.app_name}_sg"
    description = "for ${var.project}-${var.stage} ECS"
    vpc_id      = "${aws_vpc.vpc.id}"

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        ipv6_cidr_blocks= ["::/0"]
    }

    tags {
        Name    = "${local.app_name}_sg"
        project = "${var.project}"
        stage   = "${var.stage}"
        "user:Cost Center" = "${var.project}-${var.stage}"
    }
}