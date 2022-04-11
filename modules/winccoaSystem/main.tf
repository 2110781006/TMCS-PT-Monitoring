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
resource "aws_instance" "winccoaSystem" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  tags = {
    Name = "${var.winccoaSystemName}"
  }
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh-winccoaSystem.id, aws_security_group.ingress-all-opcuaPort-winccoaSystem.id, aws_security_group.ingress-all-dbPort-winccoaSystem.id, aws_security_group.ingress-all-hotrod-winccoaSystem.id]
  user_data = base64encode(templatefile("${path.module}/winccoa.tpl", { connectToOpcUaServers= var.connectToOpcUaServers, dbHost=var.dbHost, dbUser=var.dbUser, dbPassword=var.dbPassword, monitoringHost=var.monitoringHost, grafanaPassword=var.grafanaPassword } ))
}

/************************SECURITY*****************************************/

resource "aws_security_group" "ingress-all-ssh-winccoaSystem"{
  name = "${var.winccoaSystemName}-allow-all-ssh-winccoaSystem"
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

resource "aws_security_group" "ingress-all-opcuaPort-winccoaSystem"{
  name = "${var.winccoaSystemName}-allow-all-opcuaPort-winccoaSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 4840
    to_port = 4840
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

resource "aws_security_group" "ingress-all-dbPort-winccoaSystem"{
  name = "${var.winccoaSystemName}-allow-all-dbPort-winccoaSystem"
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

resource "aws_security_group" "ingress-all-hotrod-winccoaSystem"{
  name = "${var.winccoaSystemName}-allow-all-hotrod-winccoaSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 8080
    to_port = 8080
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

resource "aws_security_group" "ingress-all-jaeger-winccoaSystem"{
  name = "${var.winccoaSystemName}-allow-all-jaeger-winccoaSystem"
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 16686
    to_port = 16686
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