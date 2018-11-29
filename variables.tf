variable "project"    { default = "SampleProject" }

variable "vpc_cidr_block"  {}
variable "subnet_az"       { type = "list" }
variable "subnet_newbits"  { default = 8 }
variable "ecr_image_limit" { default = 150 }