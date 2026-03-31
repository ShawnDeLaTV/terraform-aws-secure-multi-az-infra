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