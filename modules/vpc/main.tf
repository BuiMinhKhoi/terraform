terraform {
  experiments = [module_variable_optional_attrs]
}

variable "vpc" {
  type = object({
    enable_dns_support   = optional(bool)
    enable_dns_hostnames = optional(bool)
    network              = optional(string)
    netmask              = optional(string)
    name                 = optional(string)
  })
  default = {
    enable_dns_support   = true
    enable_dns_hostnames = true
    network              = "10.0.0.0"
    netmask              = "16"
    name                 = "VPC"
  }
}

variable "private-subnet" {
  type = object({
    network = optional(string)
    netmask = optional(string)
    name    = optional(string)
  })
  default = {
    network = "10.0.0.0"
    netmask = "16"
    name    = "PRIVATE SUBNET"
  }
}

variable "security-group" {
  type = object({
    ingress = optional(object({
      description = optional(string)
      from_port   = optional(number)
      to_port     = optional(number)
      protocol    = optional(string)
      cidr_blocks = optional(list(string))
    }))

    egress = optional(object({
      description = optional(string)
      from_port   = optional(number)
      to_port     = optional(number)
      protocol    = optional(string)
      cidr_blocks = optional(list(string))
    }))

    name        = optional(string)
    description = optional(string)
  })
  default = {
    ingress = {
      description = "Deny All"
      from_port   = 0
      to_port     = 0
      protocol    = "all"
    }

    egress = {
      description = "Allow All"
      from_port   = 0
      to_port     = 25565
      protocol    = "all"
      cidr_blocks = ["0.0.0.0/0"]
    }

    name        = "Default sg"
    description = "Default config of security group"
  }
}


resource "aws_vpc" "vpc" {
  enable_dns_support   = var.vpc.enable_dns_hostnames
  enable_dns_hostnames = var.vpc.enable_dns_hostnames
  cidr_block           = "${var.vpc.network}/${var.vpc.netmask}"
  tags = {
    Name = var.vpc.name
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "${var.private-subnet.network}/${var.private-subnet.netmask}"
  tags = {
    Name = var.private-subnet.name
  }
}

# TODO: Add public subnet

resource "aws_security_group" "security-group" {
  name        = var.security-group.name
  description = var.security-group.description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = var.security-group.ingress.description
    from_port   = var.security-group.ingress.from_port
    to_port     = var.security-group.ingress.to_port
    protocol    = var.security-group.ingress.protocol
    cidr_blocks = var.security-group.ingress.cidr_blocks
  }

  egress {
    from_port   = var.security-group.egress.from_port
    to_port     = var.security-group.egress.to_port
    protocol    = var.security-group.egress.protocol
    cidr_blocks = var.security-group.egress.cidr_blocks
  }

  tags = {
    Name = var.security-group.name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_default_route_table" "route-tb" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
