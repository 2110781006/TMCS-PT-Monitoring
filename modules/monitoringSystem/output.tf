output "monitoringIp" {
  value = "${aws_instance.monitoringSystem.public_ip}"
}