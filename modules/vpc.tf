resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr_block}"
    assign_generated_ipv6_cidr_block = true
    enable_dns_support = true
    enable_dns_hostnames = true
    enable_classiclink = false
    tags {
        Name    = "${local.app_name}"
        project = "${var.project}"
        stage   = "${var.stage}"
        "user:Cost Center" = "${var.project}-${var.stage}"
    }
}

resource "aws_subnet" "subnets" {
    count      = "${length(var.subnet_az)}"
    vpc_id     = "${aws_vpc.vpc.id}"
    cidr_block = "${cidrsubnet(aws_vpc.vpc.cidr_block, var.subnet_newbits, count.index)}"
    ipv6_cidr_block  = "${cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, var.subnet_newbits, count.index)}"
    availability_zone = "${element(var.subnet_az,count.index)}"
    map_public_ip_on_launch = true
    assign_ipv6_address_on_creation = true

    tags {
        Name    = "${local.app_name}-dmz-${element(var.subnet_az,count.index)}"
        project = "${var.project}"
        stage   = "${var.stage}"
        "user:Cost Center" = "${var.project}-${var.stage}"
    }
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name    = "${local.app_name}-igw"
        project = "${var.project}"
        stage   = "${var.stage}"
        "user:Cost Center" = "${var.project}-${var.stage}"
    }
}
resource "aws_egress_only_internet_gateway" "igw_ipv6" {
    vpc_id = "${aws_vpc.vpc.id}"
}

## Route Table
resource "aws_route_table" "rtb" {
    vpc_id     = "${aws_vpc.vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igw.id}"
    }
    route {
        ipv6_cidr_block = "::/0"
        egress_only_gateway_id = "${aws_egress_only_internet_gateway.igw_ipv6.id}"
    }

    tags {
        Name    = "${local.app_name}-rtb"
        project = "${var.project}"
        stage   = "${var.stage}"
        "user:Cost Center" = "${var.project}-${var.stage}"
    }
}

resource "aws_route_table_association" "route_subnet" {
    count          = "${length(var.subnet_az)}"
    subnet_id      = "${element(aws_subnet.subnets.*.id,count.index)}"
    route_table_id = "${aws_route_table.rtb.id}"
}
