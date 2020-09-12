# outputs

output "public_ip" {
  value = aws_instance.nginx1.public_ip
}