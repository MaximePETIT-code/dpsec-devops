variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "eu-north-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "The instance type for the Spark instance"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The key name to be used for the instance"
  type        = string
  default     = "myKey"
}

variable "ami_id" {
  description = "The AMI ID for the Spark instance"
  type        = string
  default     = "ami-09a6bd44f658d0bbc"
}
