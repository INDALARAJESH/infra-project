provider "aws" {
  region = "us-east-1"  # Adjust as needed
}

resource "aws_instance" "jenkins_server" {
  ami           = "ami-0e86e20dae9224db8"  # Ubuntu 22.04 LTS AMI (adjust based on region)
  instance_type = "t3.medium"
  key_name      = "project"  # Replace with your key pair
  tags = {
    Name = "ArgoCD-Server"
  }

  user_data = <<-EOF
    #!/bin/bash
    # Update the system
    sudo apt update -y

    # Install AWS CLI v2
    sudo snap install aws-cli --classic

    # Install kubectl
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo apt install gh -y

    # Clean up installation files
    rm -f kubectl
  EOF

  security_groups = [aws_security_group.argocd_sg.name]
}

resource "aws_security_group" "argocd_sg" {
  name        = "argocd-sg"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
