output "frontend-public-ip" {
    value = aws_instance.frontend.public_ip
  
}
output "backend-private-ip" {
    value = aws_instance.backend.public_ip
  
}
output "jenkins-pub-ip" {
    value = aws_instance.jenkins.public_ip
  
}
output "bastion-pub-ip" {
    value = aws_instance.bastion.public_ip
  
}
output "rds-endpoint" {
    value = aws_db_instance.mysql.endpoint
  
}