














data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}


resource "aws_security_group" "apache1" {
  name        = "apache"
  description = "connecting to cicd"
  vpc_id      = "vpc-0d07c31974c0b2f98"

  ingress {
    description = "connecting to cicd"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    description = "connecting to bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    description = "connecting to rds"
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
    Name = "apache"
  }
}



resource "aws_instance" "apache" {
  ami           = "ami-0eb375f24fdf647b8"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0b96e7aece2af52d0"
  key_name      = "key"

  vpc_security_group_ids = [aws_security_group.apache1.id]
  user_data              = <<-EOF
 #!/bin/bash
  yum update -y
  yum install httpd -y
  systemctl start httpd
  systemctl enable httpd
  EOF



  tags = {
    Name = "apache"
  }
}