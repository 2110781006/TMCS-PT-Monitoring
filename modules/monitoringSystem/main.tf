# Data Source for getting Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

/************************instance*****************************************/

# Resource for master
resource "aws_instance" "monitoringSystem" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  tags = {
    Name = "${var.monitoringSystemName}"
  }
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh-monitoringSystem.id, aws_security_group.ingress-all-mariadb-monitoringSystem.id, aws_security_group.ingress-all-grafana-monitoringSystem.id]
  user_data = templatefile("${path.module}/monitoringSystem.tpl", {})
}


/************************SECURITY*****************************************/

resource "aws_security_group" "ingress-all-ssh-monitoringSystem"{
  name = "${var.monitoringSystemName}-allow-all-ssh-monitoringSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-mariadb-monitoringSystem"{
  name = "${var.monitoringSystemName}-allow-all-mariadb-monitoringSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ingress-all-grafana-monitoringSystem"{
  name = "${var.monitoringSystemName}-allow-all-grafana-monitoringSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
