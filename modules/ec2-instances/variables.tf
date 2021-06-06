variable "ami" {
  description = "An Amazon Machine Image provides the information required to launch an instance"
  type        = string
}

variable "instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t2.micro"
}

variable "instances_count" {
  description = "Number of instances to create"
  type        = string
  default     = "1"
}

variable "key_name" {
  description = "Name for key pair"
  type        = string
}