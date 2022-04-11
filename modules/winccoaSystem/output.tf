output "winccoaIp" {
  value = "${aws_instance.winccoaSystem.public_ip}"
}