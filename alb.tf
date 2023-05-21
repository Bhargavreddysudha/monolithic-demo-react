#alb-sg

resource "aws_security_group" "alb" {
  name        = "alb"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-albsg"
  }
}

resource "aws_lb" "jenkins-alb" {
  name               = "dev-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = ["${aws_subnet.pubsubnets[1].id}", "${aws_subnet.pubsubnets[2].id}"]

  enable_deletion_protection = true


  tags = {
    Name = "${var.envname}-alb"
  }
}

# instance target group

resource "aws_lb_target_group" "jenkins-tg" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id
}



resource "aws_lb_target_group_attachment" "testing" {
  target_group_arn = aws_lb_target_group.jenkins-tg.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}





# listner


resource "aws_lb_listener" "r_end" {
  load_balancer_arn = aws_lb.jenkins-alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-tg.arn
  }
}
# jenkins-listner_rule
resource "aws_lb_listener_rule" "jenkins-hostbased" {
  listener_arn = aws_lb_listener.r_end.arn
  #   priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-tg.arn
  }

  condition {
    host_header {
      values = ["jenkins-thanshi.life"]
    }
  }
}


#frontend

# instance target group

resource "aws_lb_target_group" "frontend-tg" {
  name     = "frontend-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id
}



resource "aws_lb_target_group_attachment" "testing1" {
  target_group_arn = aws_lb_target_group.frontend-tg.arn
  target_id        = aws_instance.frontend.id
  port             = 80
}





# listner


resource "aws_lb_listener" "r_end1" {
  load_balancer_arn = aws_lb.jenkins-alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }
}
# jenkins-listner_rule
resource "aws_lb_listener_rule" "frontend-hostbased" {
  listener_arn = aws_lb_listener.r_end1.arn
  #   priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend-tg.arn
  }

  condition {
    host_header {
      values = ["frontend-thanshi.life"]
    }
  }
}