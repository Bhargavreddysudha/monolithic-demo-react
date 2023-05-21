 #rds.tf
resource "aws_security_group" "rds" {
  name        = "rds"
  description = "Allow 8080 and ssh inbound traffic"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description     = "ssh from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.frontend.id}"]

  }
  ingress {
    description     = "ssh from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.backend-sg.id}"]

  }

  ingress {
    description     = "ssh from VPC"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]

  }
  ingress {
    description     = "http from VPC"
    from_port       = 3306
    to_port         = 3306
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
    Name = "${var.envname}-rdssg"
  }
}

resource "aws_db_subnet_group" "db-subnetgroup" {
  name       = "db-subnetgroup"
  subnet_ids = [aws_subnet.datasubnets[0].id, aws_subnet.datasubnets[1].id, aws_subnet.datasubnets[2].id]

  tags = {
    Name = "${var.envname}-rdssubnet-group"
  }
}


resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  name                   = "demords"
  username               = "devapiuser"
  password               = "9573972811Mahi"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db-subnetgroup.name
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]

  tags = {
    Name = "${var.envname}-rds"
  }

}