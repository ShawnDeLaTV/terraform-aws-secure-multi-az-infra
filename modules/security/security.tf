resource "aws_security_group" "web-server-sg" {
  name        = "WebServerSecurityGroup"
  description = "Allow HTTP and HTTPS traffic for ec2 instances"
  vpc_id      = var.main-vpc-id

  tags = {
    Name = "WebServerSecurityGroup"
  }
}

resource "aws_security_group" "alb-sg" {
  name        = "ALBSecurityGroup"
  description = "Allow HTTP and HTTPS traffic for ALB"
  vpc_id      = var.main-vpc-id

  tags = {
    Name = "ALBSecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "web_server_allow_http_from_alb_inbound_rule" {
  security_group_id = aws_security_group.web-server-sg.id
  //cidr_ipv4         = "0.0.0.0/0"
  referenced_security_group_id = aws_security_group.alb-sg.id # On autorise le trafic HTTP provenant de l'ALB
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}
/*
resource "aws_vpc_security_group_ingress_rule" "web_server_allow_https_inbound_rule" {
  security_group_id = aws_security_group.web-server-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
*/
resource "aws_vpc_security_group_egress_rule" "web_server_allow_all_outbound_rule" {
  security_group_id = aws_security_group.web-server-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" // -1 means all protocols
}

# --- RÈGLES POUR L'ALB ---

resource "aws_vpc_security_group_ingress_rule" "alb_http_inbound" {
  security_group_id = aws_security_group.alb-sg.id # <--- On cible l'ALB
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "alb_https_inbound" {
  security_group_id = aws_security_group.alb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "alb_all_outbound" {
  security_group_id = aws_security_group.alb-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
