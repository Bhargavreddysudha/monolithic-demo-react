#bastion.tf

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
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
    Name = "${var.envname}-bastionsg"
  }
}



resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.demo.id
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  subnet_id              = aws_subnet.pubsubnets[0].id

  tags = {
    Name = "${var.envname}-bastion"
  }
}