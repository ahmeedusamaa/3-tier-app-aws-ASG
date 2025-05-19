resource "aws_lb" "frontend_alb" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.frontend_alb_sg]
  subnets            = var.public_subnet_ids
  tags = {
    Environment = "dev"
  }
  
}

resource "aws_lb" "backend_alb" {
  name               = "backend-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.backend_alb_sg]
  subnets            = var.private_subnet_ids
  tags = {
    Environment = "dev"
  }

}

resource "aws_lb_listener" "frontend_listener" {
  load_balancer_arn = aws_lb.frontend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.frontend_lb_target_group_arn
  }
  
}

resource "aws_lb_listener" "backend_listener" {
  load_balancer_arn = aws_lb.backend_alb.arn
  port              = "3000"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.backend_lb_target_group_arn
  }
  
}
