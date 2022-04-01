output "dbIp" {
  value = "${aws_instance.dbSystem.public_ip}"
}