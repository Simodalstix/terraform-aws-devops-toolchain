variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "ap-southeast-2"
}


variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}


variable "instance_type" {
  description = "The EC2 instance type for the SonarQube server."
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "The name of the EC2 key pair to use for SSH access."
  type        = string
  # This variable has no default and must be provided by the user.
}
