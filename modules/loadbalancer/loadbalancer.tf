resource "aws_lb" "web-server-load-balancer" {
  name               = "web-server-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb-sg-id]
  subnets            = [var.public-subnet-a-id, var.public-subnet-b-id]
}

resource "aws_lb_target_group" "web-server-target-group" {
  name     = "web-server-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.main-vpc-id
}

resource "aws_lb_listener" "web-server-listener" {
  load_balancer_arn = aws_lb.web-server-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-server-target-group.arn
  }
}
/*
resource "aws_lb_target_group_attachment" "web-server-attachment" {
  count            = 4
  target_group_arn = aws_lb_target_group.web-server-target-group.arn
  
  target_id        = var.target_instances_ids[count.index]
  port             = 80
}
*/

##DNS
resource "aws_cloudfront_distribution" "web_distribution" {
  enabled     = true
  price_class = "PriceClass_100"

  origin {
    domain_name = aws_lb.web-server-load-balancer.dns_name
    origin_id   = "ALB-Origin"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "ALB-Origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]
    
    # TTL à 0, On se sert de CloudFront comme d'un simple proxy pour l'ALB de facon a avoir du https sans devoir gérer des certificats sur l'ALB (car on a un freetier)
    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0

    forwarded_values {
      query_string = true
      cookies      { forward = "all" }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }
}