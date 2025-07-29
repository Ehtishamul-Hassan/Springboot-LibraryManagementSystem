variable "region" {
  default = "ap-south-1"
}

variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "key_name" {
  description = "Name of the existing key pair created in AWS"
  type        = string
}

variable "instance_type" {
  default     = "t2.micro"
  description = "EC2 type"
}

# 👇 New complex variable to launch multiple instances
variable "instances" {
  type = map(object({
    az            = string
    tag           = string
    name          = string
    instance_type = string
  }))
  description = "Instances to launch with subnet info and names"
}
