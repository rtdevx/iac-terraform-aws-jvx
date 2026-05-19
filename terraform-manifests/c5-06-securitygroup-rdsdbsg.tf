# INFO: Create Ingress Security Group - DB Traffic
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#example-usage

resource "aws_security_group" "private-db-3306" {
  name        = "private-db-3306"
  description = "${local.name}-private-db-3306"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "private-db-3306"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private-db-3306_ipv4" {
  description       = "Allow Port 3306 INBOUND"
  security_group_id = aws_security_group.private-db-3306.id
  //cidr_ipv4         = var.vpc_cidr
  referenced_security_group_id = aws_security_group.private-web-8080.id
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306

  tags = {
    "Name" = "private-db-inbound-3306"
  }
}

# INFO: Create Egress Security Group - ALL

resource "aws_security_group" "db-egress" {
  name = "${local.name}-private-db-egress"
  description = "${local.name}-db-egress"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags
}

resource "aws_vpc_security_group_egress_rule" "db-allow-all-traffic_ipv4" {
  description       = "Allow all IP and ports OUTBOUND"
  security_group_id = aws_security_group.db-egress.id
  cidr_ipv4         = var.vpc_cidr # NOTE: Outbound only to VPC CIDR required for AWS Services (KMS, CloudWatch Logs, Secrets Manager). Communication via NAT or VPC Endpoints (if present)
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = local.common_tags
}