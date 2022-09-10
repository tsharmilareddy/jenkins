










resource "aws_security_group" "cicd" {
  name        = "apach"
  description = "connecting to cicd"
  vpc_id      = "vpc-0d07c31974c0b2f98"


  ingress {
    description = "connecting to apache"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  ingress {
    description = "connecting to apache"
    from_port   = 8080
    to_port     = 8080
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
    Name = "cicd"
  }
}









resource "aws_instance" "jenkins" {
  ami                    = "ami-0eb375f24fdf647b8"
  instance_type          = "c5.2xlarge"
  subnet_id              = "subnet-0b96e7aece2af52d0"
  key_name               = "key"
  vpc_security_group_ids = [aws_security_group.cicd.id]
  user_data              = <<-EOF
 #!/bin/bash
 sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
 sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
 yum install epel-release # repository that provides 'daemonize'
 amazon-linux-extras install epel
 amazon-linux-extras install java-openjdk11 -y
#  yum install java-11-openjdk-devel
 yum install jenkins -y
 systemctl start jenkins
 systemctl enable jenkins
  EOF



  tags = {
    Name = "cicd"
  }
}


