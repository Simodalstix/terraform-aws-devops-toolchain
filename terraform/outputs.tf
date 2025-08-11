# No outputs are defined yet.

output "sonarqube_public_ip" {
  description = "The public IP address of the SonarQube server."
  value       = aws_instance.sonarqube.public_ip
}
