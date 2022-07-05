terraform {
  experiments = [module_variable_optional_attrs]
}

variable "ec2-configuration-required" {
  type = object({
    vpc_security_group_ids = list(string)
    vpc_subnet_id         = string
  })
}

variable "ec2-configuration-optional" {
  type = object({
    aws-ec2-ami          = optional(string)
    awc-ec2-machine-type = optional(string)
    public-ip            = optional(bool)
    name                 = optional(string)
  })
  default = {
      aws-ec2-ami          = "ami-02ee763250491e04a"
      awc-ec2-machine-type = "t2.micro"
      public-ip            = false
      name                 = "backend-server"
  }
  sensitive = false
}

resource "aws_instance" "backend-server" {
  vpc_security_group_ids      = var.ec2-configuration-required.vpc_security_group_ids
  subnet_id                   = var.ec2-configuration-required.vpc_subnet_id
  ami                         = var.ec2-configuration-optional.aws-ec2-ami
  instance_type               = var.ec2-configuration-optional.awc-ec2-machine-type
  associate_public_ip_address = var.ec2-configuration-optional.public-ip
  tags = {
    Name = var.ec2-configuration-optional.name
  }
}