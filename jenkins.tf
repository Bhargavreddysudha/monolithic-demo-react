#jenkis-sg.tf

resource "aws_security_group" "jenkins-sg" {
  name        = "jenkins-sg"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = aws_vpc.demo.id

#   ingress {
#     description     = "ssh from VPC"
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = ["${aws_security_group.frontend.id}"]

#   }
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "access from web browser"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description = "access from web browser"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = ["${aws_security_group.alb.id}"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-jenkins-sg"
  }
}


#jenkinsuserdata

# data "template_file" "userdata1" {
#   template = file("jenkinsuserdata.sh")

# }


#jenkins instance

resource "aws_instance" "jenkins" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.demo.id
  vpc_security_group_ids = ["${aws_security_group.jenkins-sg.id}"]
  subnet_id              = aws_subnet.pubsubnets[0].id
  #user_data              = data.template_file.userdata1.rendered
  user_data = "${file("jenkins.sh")}"

  tags = {
    Name = "${var.envname}-jenkins"
  }
}