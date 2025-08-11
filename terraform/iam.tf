resource "aws_iam_role" "sonarqube" {
  name = "sonarqube-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "sonarqube-ec2-role"
  }
}

resource "aws_iam_instance_profile" "sonarqube" {
  name = "sonarqube-ec2-instance-profile"
  role = aws_iam_role.sonarqube.name
}
