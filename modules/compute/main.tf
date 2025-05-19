data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"] 

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_launch_template" "frontend_lt" {
  name_prefix     = "frontend-lt-"
  image_id        = data.aws_ami.ubuntu_24_04.id
  instance_type   = "t2.micro"

  user_data = base64encode(templatefile("${path.module}/fe_user_data.sh", {
    backend_alb_dns = var.backend_lb_dns_name
  }))

  key_name = var.public_key

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.frontend_sg]
  }
}

resource "aws_launch_template" "backend_lt" {
  name_prefix   = "backend-lt-"
  image_id      = data.aws_ami.ubuntu_24_04.id
  instance_type = "t2.micro"

  user_data = base64encode(templatefile("${path.module}/backend_user_data.sh", {
    rds_endpoint = var.db_address
    db_username  = "admin"
    db_password  = var.db_password
    db_name      = "appdb"
  }))

  key_name = var.public_key

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.backend_sg]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "frontend_asg" {
  vpc_zone_identifier = var.public_subnet_ids
  desired_capacity      = 2
  max_size              = 2
  min_size              = 1

  launch_template {
    id      = aws_launch_template.frontend_lt.id
    version = "$Latest"
  }

}



resource "aws_autoscaling_group" "backend_asg" {
  vpc_zone_identifier = var.private_subnet_ids
  desired_capacity      = 2
  max_size              = 2
  min_size              = 1

  launch_template {
    id      = aws_launch_template.backend_lt.id
    version = "$Latest"
  }

}


resource "aws_lb_target_group" "frontend_tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-404" 
  }
}

resource "aws_lb_target_group" "backend_tg" {
  name     = "backend-tg"
  port     = 3000 
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/increment"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


resource "aws_autoscaling_attachment" "frontend" {
  autoscaling_group_name = aws_autoscaling_group.frontend_asg.name
  lb_target_group_arn    = aws_lb_target_group.frontend_tg.arn
}

resource "aws_autoscaling_attachment" "backend" {
  autoscaling_group_name = aws_autoscaling_group.backend_asg.name
  lb_target_group_arn    = aws_lb_target_group.backend_tg.arn
}
