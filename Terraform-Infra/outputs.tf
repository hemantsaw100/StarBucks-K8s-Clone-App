output "jenkins_server_public_ip" {
    value =  "Your Jenkins Server IP is : ${aws_instance.jenkins_server.public_ip}"
}

output "sonarqube_server_public_ip" {
    value =  "Your SonarQube Server IP is : ${aws_instance.sonarqube_server.public_ip}"
  
}