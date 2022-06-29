resource "aws_alb" "sprint-alb" {
  name = "sprint-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.Public-SG.id ]
  subnets = [ aws_subnet.public_subnet.id , aws_subnet.public_subnet2.id ]
  enable_cross_zone_load_balancing = true
}

resource "aws_security_group" "alb-sg" {
	name = "alb-sg"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = [ "0.0.0.0/0" ]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = [ "0.0.0.0/0" ]
	}
}

resource "aws_alb_target_group" "sprint-alb-tg" {
  name = "sprint-alb-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}

resource "aws_alb_target_group_attachment" "privateInstance01" {
  target_group_arn = aws_alb_target_group.sprint-alb-tg.arn
  target_id = aws_instance.app_server.id
  port = 80
}

resource "aws_alb_target_group_attachment" "privateInstance02" {
  target_group_arn = aws_alb_target_group.sprint-alb-tg.arn
  target_id = aws_instance.app_server2.id
  port = 80
}

resource "aws_alb_listener" "sprint-listener" {
  load_balancer_arn = aws_alb.sprint-alb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.sprint-alb-tg.arn
  }
}

