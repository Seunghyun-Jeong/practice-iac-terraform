resource "aws_launch_configuration" "sprint-lc" {
  image_id        = "ami-0ed11f3863410c386"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.Public-SG.id]

  user_data = <<-EOF
		#!/bin/bash
		echo "Hello, World" > index.html
		nohup busybox httpd -f -p 80 &
		EOF
}

resource "aws_autoscaling_group" "sprint-asg" {
  launch_configuration = aws_launch_configuration.sprint-lc.name
  vpc_zone_identifier  = [aws_subnet.public_subnet.id, aws_subnet.public_subnet2.id]
  target_group_arns = [aws_alb_target_group.sprint-alb-tg.arn]

  min_size = 2
  max_size = 10
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_alb_listener.sprint-listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.sprint-alb-tg.arn
  }
}
