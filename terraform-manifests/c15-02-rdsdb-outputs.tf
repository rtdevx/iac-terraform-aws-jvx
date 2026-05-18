# INFO: RDS DB Outputs
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#attribute-reference

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.rdsdb.address
}

output "db_instance_ip" {
  description = "The IP address of the RDS instance"
  value       = aws_db_instance.rdsdb.domain_dns_ips
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.rdsdb.arn
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = aws_db_instance.rdsdb.availability_zone
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.rdsdb.endpoint
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = aws_db_instance.rdsdb.hosted_zone_id
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = aws_db_instance.rdsdb.identifier

}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = aws_db_instance.rdsdb.resource_id
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = aws_db_instance.rdsdb.status
}

output "db_instance_name" {
  description = "The database name"
  value       = aws_db_instance.rdsdb.db_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = aws_db_instance.rdsdb.username
  sensitive   = true
}

output "db_instance_password" {
  description = "The master username for the database"
  value       = aws_db_instance.rdsdb.password
  sensitive   = true
}

output "rds_master_user_secret_arn" {
  value     = aws_db_instance.rdsdb.master_user_secret[0].secret_arn
  sensitive = true
}

output "db_instance_port" {
  description = "The database port"
  value       = aws_db_instance.rdsdb.port
}

output "db_subnet_group_id" {
  description = "The db subnet group name"
  value       = aws_db_instance.rdsdb.db_subnet_group_name
}

/*
output "db_subnet_group_arn" {
  description = "The ARN of the db subnet group"
  value       = aws_db_instance.rdsdb.db_subnet_group_name.arn
}
*/
output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = aws_db_instance.rdsdb.parameter_group_name
}
/*
output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = aws_db_instance.rdsdb.parameter_group_name.arn
}
*/
/*
output "db_enhanced_monitoring_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the monitoring role"
  value       = aws_db_instance.rdsdb.enhanced_monitoring_iam_role_arn
}
*/