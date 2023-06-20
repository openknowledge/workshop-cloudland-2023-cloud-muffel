locals {
  release_url = "https://github.com/openknowledge/workshop-cloudland-2023-cloud-muffel/releases/download/test/on-premises-0.0.1-SNAPSHOT.jar"
}

data "aws_ami" "app" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }
}

resource "aws_instance" "app" {
  ami = data.aws_ami.app.id

  instance_type = "t3a.micro"

  user_data = <<-EOF
  #!/bin/bash

  echo Update all packages
  yum -y update

  echo Install Java 17
  yum -y install java-17-amazon-corretto-headless

  echo Download app
  wget ${local.release_url} -O app.jar

  echo Start app
  java -jar app.jar --server.port=80
  EOF

  security_groups = [aws_security_group.app.name]
}

resource "aws_security_group" "app" {
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
}

output "app_domain" {
  value = aws_instance.app.public_dns
}
