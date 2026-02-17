# INFO: EC2 Instance Types

variable "instance_type_private" {
  description = "EC2 Instance Type - AppServer"
  type        = string
  default     = "t3.micro"
}