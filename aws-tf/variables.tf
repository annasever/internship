variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  type    = string
  default = "t3.small"
}

variable "instance_AMI" {
  type    = string
  default = "ami-0745b7d4092315796"
}

variable "ssh_key_name" {
  type    = string
  default = "vasilenko"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the security group will be created"
}

variable "aws_account_id" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type    = string
  default = "password"
}

variable "docdb_username" {
  type    = string
  default = "postgres"
}

variable "docdb_password" {
  type    = string
  default = "password"
}

variable "subnet_ids" {
  type = list(string)
}
