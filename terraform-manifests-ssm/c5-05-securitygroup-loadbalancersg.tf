# INFO: Create Security Groups for the Application Load Balancer
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

# INFO: Create Ingress Security Group - WEB Traffic - 80

resource "aws_security_group" "web-alb-private-80" {
  name        = "${local.name}-web-alb-private-80"
  description = "Security Group for Private ALB - WEB Traffic Port 80"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags

}

resource "aws_vpc_security_group_ingress_rule" "web-alb-private-80_ipv4" {
  description       = "Allow Port 80 INBOUND"
  security_group_id = aws_security_group.web-alb-private-80.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = local.common_tags

}

# INFO: Create Ingress Security Group - WEB Traffic - 443

resource "aws_security_group" "web-alb-private-443" {
  name        = "${local.name}-web-alb-private-443"
  description = "Security Group for Private ALB - WEB Traffic Port 443"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "web-alb-private-443"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web-alb-private-443_ipv4" {
  description       = "Allow Port 443 INBOUND"
  security_group_id = aws_security_group.web-alb-private-443.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = local.common_tags

}

# INFO: Create Egress Security Group - ALL

resource "aws_security_group" "web-alb-private-egress" {
  name        = "${local.name}-web-alb-private-egress"
  description = "Security Group for Private ALB - ALL OUTBOUND"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags

}

resource "aws_vpc_security_group_egress_rule" "web-alb-private-allow-all-traffic_ipv4" {
  description       = "Allow all IP and ports OUTBOUND"
  security_group_id = aws_security_group.web-alb-private-egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = local.common_tags

}