resource "aws_security_group" "sonarqube" {
  name        = "sonarqube-sg"
  description = "Allow traffic to SonarQube"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SonarQube web UI"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sonarqube-sg"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.sonarqube.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              systemctl start docker
              systemctl enable docker
              usermod -a -G docker ec2-user

              # Format and mount the EBS volume
              mkfs -t ext4 /dev/sdh
              mkdir /var/sonarqube
              mount /dev/sdh /var/sonarqube
              
              # SonarQube requires higher vm.max_map_count
              sysctl -w vm.max_map_count=262144
              
              # Run SonarQube container with persistent data volumes
              docker run -d --name sonarqube \
                -p 9000:9000 \
                -v /var/sonarqube/data:/opt/sonarqube/data \
                -v /var/sonarqube/logs:/opt/sonarqube/logs \
                -v /var/sonarqube/extensions:/opt/sonarqube/extensions \
                sonarqube:lts-community
              EOF

  tags = {
    Name = "sonarqube-server"
  }
}

resource "aws_ebs_volume" "sonarqube" {
  availability_zone = aws_instance.sonarqube.availability_zone
  size              = 20
  type              = "gp2"

  tags = {
    Name = "sonarqube-data-volume"
  }
}

resource "aws_volume_attachment" "sonarqube" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.sonarqube.id
  instance_id = aws_instance.sonarqube.id
}
