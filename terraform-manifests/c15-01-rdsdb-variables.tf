# INFO: Terraform AWS RDS Database Variables
# * Values are defined in "rdsdb.auto.tfvars" and "secrets.tfvars"

#INFO: DB Name
variable "db_name" {
  description = "AWS RDS Database Name"
  type        = string
}

#INFO: DB Instance Identifier
variable "db_instance_identifier" {
  description = "AWS RDS Database Instance Identifier"
  type        = string
}

#INFO: DB Username - Enable Sensitive flag
variable "db_username" {
  description = "AWS RDS Database Administrator Username"
  type        = string
}

/**

#INFO: DB Password - Enable Sensitive flag
variable "db_password" {
  description = "AWS RDS Database Administrator Password"
  type        = string
  sensitive   = true
}

*/