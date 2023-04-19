variable "ami" {
  description = "AMI of image for the EC2 instances"
  type = string
}

variable "aws_profile" {
  description = "AWS CLI Profile"
  type = string
}

variable "aws_tags" {
  description = "Default tags to use for AWS"
  type        = map(string)
}

variable "instances_masters" {
  description = "Instance list to create all the masters"
  type = set(string)
  default = ["master-1"]
}

variable "instances_workers" {
  description = "Instance list to create all the worker nodes"
  type = set(string)
  default = ["worker-1"]
}

variable "instance_name_prefix" {
  description = "Prefix of the EC2 instance name"
  type        = string
  default     = "rke2-test"
}

variable "instance_type" {
  description = "Size of the EC2 instance"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "Name of Keypair to use for SSH"
  type        = string
}


variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "rke2_version" {
  description = "RKE2 Version"
  type        = string
  default     = "v1.24.11+rke2r1"

}

#variable "security_group_ids" {
#  description = "VPC security group IDs"
#  type        = set(string)
#}
#
#variable "subnet_id" {
#  description = "Subnet ID to use for instances"
#  type = string
#}

variable "volume_type" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "gp2"
}

variable "volume_size" {
  description = "Value of the Name tag for the EC2 instance"
  type        = number
  default     = 60
}

