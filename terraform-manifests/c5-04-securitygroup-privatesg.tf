# INFO: Create Security Groups for EC2 instances in the Private Subnet
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#example-usage

# INFO: Create Ingress Security Group - WEB Traffic - 8443

resource "aws_security_group" "private-web-8443" {
  name        = "${local.name}-private-web-8443"
  description = "Security Group for Private Instances - WEB Traffic Port 8443"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags

}

resource "aws_vpc_security_group_ingress_rule" "private-web-8443_ipv4" {
  description       = "Allow Port 8443 INBOUND from ALB only"
  security_group_id = aws_security_group.private-web-8443.id

  //cidr_ipv4         = var.vpc_cidr
  referenced_security_group_id = aws_security_group.web-alb-public-ingress.id

  from_port   = 8443
  to_port     = 8443
  ip_protocol = "tcp"

  tags = local.common_tags
}

# INFO: Create Egress Security Group - ALL

resource "aws_security_group" "private-egress" {
  name        = "${local.name}-private-egress"
  description = "security Group for Private Instances - ALL OUTBOUND"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags

}

resource "aws_vpc_security_group_egress_rule" "private-allow-all-traffic_ipv4" {
  description       = "Allow all IP and ports OUTBOUND"
  security_group_id = aws_security_group.private-egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = local.common_tags

}