variable "vpc-config" {
  type = any
}

variable "private-subnet" {
  type = any
}

variable "security-group" {
  type = any
}

variable "tf-backend-s3-bucket-name" {
  type = string
}

variable "tf-backend-s3-key" {
  type = string
}

variable "tf-backend-s3-region" {
  type = string
}

variable "aws-region" {
  type = string
}

variable "ec2-configuration-optional" {
  type = any
}




