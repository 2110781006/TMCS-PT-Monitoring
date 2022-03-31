output "opcuaIp" {
  value = "${aws_instance.opcuaSystem.public_ip}"
}