# INFO: Create Security Groups for the Application Load Balancer
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

# INFO: Create Ingress Security Group - WEB Traffic - 80

resource "aws_security_group" "web-alb-public-ingress" {
  name        = "${local.name}-web-alb-public-ingress"
  description = "Security Group for public ALB HTTP/HTTPS"
  vpc_id      = module.vpc.vpc_id
  tags        = local.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "web-alb-public-ingress-80" {
  security_group_id = aws_security_group.web-alb-public-ingress.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "web-alb-public-ingress-443" {
  security_group_id = aws_security_group.web-alb-public-ingress.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# INFO: Create Egress Security Group - ALL

resource "aws_security_group" "web-alb-public-egress" {
  name        = "${local.name}-web-alb-public-egress"
  description = "Security Group for public ALB - ALL OUTBOUND"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags

}

resource "aws_vpc_security_group_egress_rule" "web-alb-public-allow-all-traffic_ipv4" {
  description       = "Allow all IP and ports OUTBOUND"
  security_group_id = aws_security_group.web-alb-public-egress.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = local.common_tags

}