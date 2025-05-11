terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.0"
        }
    }
}

// AWS Provider Configuration
// This block configures the AWS provider with the specified region and profile
provider "aws" {
  region = var.aws_region
  profile = "terraform-project-user"
  }


// Create EC2 Instance for Jenkins Server
resource "aws_instance" "jenkins_server" {
  ami           = var.jenkins_server_ami
  instance_type = var.jenskins_instace_type 
  associate_public_ip_address = "true" // Associate a public IP address
  key_name      = "starbucks-project" // Key pair name for SSH access
  security_groups = [aws_security_group.starbucks_project_sg.name] // Attach the security group to the instance

  root_block_device {
    volume_size = var.jenkins_root_block_device_size
    volume_type = "gp3" // General Purpose SSD
    delete_on_termination = true // Delete the volume when the instance is terminated
  }

  tags = {
    Name = "Jenkins-Server"
  }
}

# Allocate Elastic IP Address
resource "aws_eip" "eip_for_jenkins_server" {
  instance = aws_instance.jenkins_server.id // Associate the EIP with the Jenkins server instance
  domain = "vpc"

  tags = {
    Name = "EIP for Jenkins Server"
  }
}

// Create EC2 Instance for SonarQube Server
resource "aws_instance" "sonarqube_server" {
  ami           = var.sonarqube_server_ami
  instance_type = var.sonarqube_instance_type
  associate_public_ip_address = "true" // Associate a public IP address
  key_name      = "starbucks-project" // Key pair name for SSH access
  security_groups = [aws_security_group.starbucks_project_sg.name] // Attach the security group to the instance

  root_block_device {
    volume_size = var.sonarqube_root_block_device_size
    volume_type = "gp3" // General Purpose SSD
    delete_on_termination = true // Delete the volume when the instance is terminated
  }

  tags = {
    Name = "SonarQube-Server"
  }
}


// Security Group for Starbucks Project
// This security group allows inbound traffic on specified ports and all outbound traffic
resource "aws_security_group" "starbucks_project_sg" {
  name        = "project_sg"
  description = "Security group for project resources"
  //vpc_id      = Default VPC will be used here

# Define a single ingress rule to allow traffic on all specified ports
# Attributes like "ipv6_cidr_blocks", "prefix_list_ids", and "security_groups" are required otherwise it will throw an inappropriate values error.
  ingress = [
    for port in [22, 80, 443, 465, 587, 8080, 3000, 9000] : {  //SSH, HTTP, HTTPS, SMTP, SMTPS, JENKINS, (GRAFANA, NODEJS), SONARQUBE
      description      = "Allow traffic on port ${port}"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Starbucks-Project-SG"
  }

}




