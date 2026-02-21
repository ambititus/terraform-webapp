
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-plucky-25.04-amd64-server-*"]
  }
}

resource "aws_instance" "webapp-server" {
  ami                    = data.aws_ami.amazon_linux.image_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.web-sg.id]



  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y python3
    cd /home/ec2-user
    echo "Hello from Terraform!" > index.html
    python3 -m http.server 80 &
  EOF

  tags = {
    name = "web"
  }
}


resource "aws_security_group" "web-sg" {
  name        = "web_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name = "wirfoncloud"
  }
}


resource "aws_vpc_security_group_ingress_rule" "ingress-http" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}


resource "aws_vpc_security_group_ingress_rule" "ingress-ssh" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0" # replace with cidr_ipv4 = "203.0.113.42/32" 
  #from laptop ip
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}


resource "aws_vpc_security_group_egress_rule" "all_egress" {
  security_group_id = aws_security_group.web-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}






