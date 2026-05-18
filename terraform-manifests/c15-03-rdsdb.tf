# INFO: RDS
# ? RDS Terraform resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# ? Use KMS_KEY instead of a variable: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance#managed-master-passwords-via-secrets-manager-default-kms-key


# INFO: SQL Custom Parameter Group
# NOTE: To require encrypted connections, custom parameter group is required
# ? DB Parameter Group Terraform resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_parameter_group
# ? Aurora MySQL reference: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/AuroraMySQL.Reference.html

/**
The default parameter group does NOT enforce TLS.

This Custom Parameter Grout is later referenced: "parameter_group_name = aws_db_parameter_group.mysql_tls.name"

# * This ensures all clients must use TLS on port 3306.
**/

resource "aws_db_parameter_group" "mysql_tls" {
  name   = "mysql8-require-tls-${var.environment}"
  family = "mysql8.0"

  parameter {
    name  = "require_secure_transport"
    value = "ON"
  }
}

# INFO: Create DB Instance
resource "aws_db_instance" "rdsdb" {
  allocated_storage     = 5
  max_allocated_storage = 10
  db_name               = var.db_name
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  port                  = 3306
  //engine                      = data.aws_rds_orderable_db_instance.custom-sqlserver.engine
  //engine_version              = data.aws_rds_orderable_db_instance.custom-sqlserver.engine_version
  //instance_class              = data.aws_rds_orderable_db_instance.custom-sqlserver.instance_class
  username                    = var.db_username
  manage_master_user_password = true # NOTE: Store the password in Secrets Manager automatically, use the AWS-managed KMS key for Secrets Manager, Avoids hard-coded secrets in Terraform state

  /**
  For "manage_master_user_password", retrieve the generated secret via:

  output "rds_master_user_secret_arn" {
  value = aws_db_instance.rdsdb.master_user_secret[0].secret_arn
}
  **/

  # NOTE: If "kms_key_id" not specified, RDS will use the AWS-managed key for RDS
  # TODO: CMKs are a future enhancement, not a current requirement.
  //kms_key_id                  = data.aws_kms_key.by_id.arn 

  //parameter_group_name = "default.mysql8.0"
  parameter_group_name = aws_db_parameter_group.mysql_tls.name # NOTE: Enforce TLS on 3306 with Custom SQL Parameter Group
  skip_final_snapshot  = var.environment == "prod" ? false : true
  deletion_protection  = var.environment == "prod" ? true : false
  publicly_accessible  = false # NOTE: False is the default value

  auto_minor_version_upgrade = true                              # NOTE: if set to false, it will miss security patches
  backup_retention_period    = var.environment == "prod" ? 7 : 1 # NOTE: Must be between 0 and 35
  db_subnet_group_name       = module.vpc.database_subnet_group
  vpc_security_group_ids     = [aws_security_group.private-db-3306.id, aws_security_group.db-egress.id]
  identifier                 = var.db_instance_identifier
  multi_az                   = var.environment == "prod" ? true : false # NOTE: Multi-AZ enabled for "prod" only
  storage_encrypted          = true                                     # NOTE: If "kms_key_id" not specified, RDS will use the AWS-managed key for RDS

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general", "slowquery", "error"]

  performance_insights_enabled          = true                                # NOTE: PI is one of the best diagnostic tools AWS offers.
  performance_insights_retention_period = var.environment == "prod" ? 731 : 7 # NOTE: Only enable when `performance_insights_enabled` is set to true. Retention values: RDS only allows 7 or 731 days.

  timeouts {
    create = "40m"
    delete = "90m"
    update = "1h"
  }

  tags = local.common_tags
}