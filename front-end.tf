#frontend.tf

resource "aws_security_group" "frontend" {
  name        = "frontend"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "access from web browser"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "ssh from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
   security_groups = ["${aws_security_group.alb.id}"]

  }
  ingress {
    description     = "ssh from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins-sg.id}"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-frontendsg"
  }
}

resource "aws_key_pair" "demo" {
  key_name   = "demo"
  public_key = file("~/.ssh/id_rsa.pub")
}



resource "aws_instance" "frontend" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.demo.id
  vpc_security_group_ids = ["${aws_security_group.frontend.id}"]
  subnet_id              = aws_subnet.pubsubnets[0].id
  #user_data              = data.template_file.userdata1.rendered
  user_data = "${file("frontend.sh")}"

  tags = {
    Name = "${var.envname}-frontend"
  }
}
