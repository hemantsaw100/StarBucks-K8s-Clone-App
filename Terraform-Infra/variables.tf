variable aws_region {
    description = "The AWS region to create resources in"
    type        = string
}

variable "jenkins_server_ami" {
    description = "The AMI ID for the Jenkins server"
    type        = string
}

variable "jenkins_root_block_device_size" {
    description = "The size of the root block device for the Jenkins server"
    type        = number
}

variable "jenskins_instace_type" {
    description = "The instance type for the Jenkins server"
    type        = string
    default     = "t3.large" 
}

variable "sonarqube_server_ami" {
    description = "The AMI ID for the SonarQube server"
    type        = string
}

variable "sonarqube_instance_type" {
    description = "The instance type for the SonarQube server"
    type        = string
    default     = "t2.medium" 
}

variable "sonarqube_root_block_device_size" {
    description = "The size of the root block device for the SonarQube server"
    type        = number
}