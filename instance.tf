terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-063db2954fe2eec9f"
  instance_type = "t2.micro"
  key_name      = "seunghyunMac"
  subnet_id              = aws_subnet.public_subnet2.id
  vpc_security_group_ids = [aws_security_group.Public-SG.id]
  user_data              = <<-EOF
                          #!/bin/bash
                          echo "Hello, World" > index.html
                          nohup busybox httpd -f -p 80 &
                          EOF
}

resource "aws_instance" "app_server2" {
  ami           = "ami-063db2954fe2eec9f"
  instance_type = "t2.micro"
  key_name      = "seunghyunMac"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.Public-SG.id]
  user_data              = <<-EOF
                          #!/bin/bash
                          echo "Hello, World" > index.html
                          nohup busybox httpd -f -p 80 &
                          EOF
}
