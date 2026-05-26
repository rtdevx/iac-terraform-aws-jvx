# INFO: Input Variables
# ? https://developer.hashicorp.com/terraform/language/block/variable

# INFO: AWS Region and Account
variable "aws_region" {
  description = "Region in which AWS Resources will be created"
  type        = string
  default     = "eu-west-2"
}

variable "aws_account_id" {
  description = "AWS Account ID in which AWS Resources will be created"
  type        = string
  default     = "390157243794"
}

# INFO: Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# INFO: Business Division
variable "business_division" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "operations"
}

# INFO: Platform / Product
variable "platform" {
  description = "Platform / Product this infrastructure supports"
  type        = string
  default     = "aws"
}

# ! Default values will be overwritten in terraform.tfvars