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
resource "aws_instance" "dbSystem" {
  ami = data.aws_ami.amazon-2.id
  instance_type = "t3.micro"

  tags = {
    Name = "${var.dbSystemName}"
  }
  vpc_security_group_ids = [aws_security_group.ingress-all-ssh-dbSystem.id, aws_security_group.ingress-all-dbPort-dbSystem.id, aws_security_group.ingress-all-http2Port-dbSystem.id]
  user_data = templatefile("${path.module}/dbSystem.tpl", {dbPassword=var.dbPassword})
}


/************************SECURITY*****************************************/

resource "aws_security_group" "ingress-all-ssh-dbSystem"{
  name = "${var.dbSystemName}-allow-all-ssh-dbSystem"
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

resource "aws_security_group" "ingress-all-dbPort-dbSystem"{
  name = "${var.dbSystemName}-allow-all-dbPort-dbSystem"
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

resource "aws_security_group" "ingress-all-http2Port-dbSystem"{
  name = "${var.dbSystemName}-allow-all-http2Port-dbSystem"
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