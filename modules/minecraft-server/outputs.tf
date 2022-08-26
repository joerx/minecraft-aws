output "ssh_private_key" {
  sensitive = true
  value     = tls_private_key.keypair.private_key_pem
}

output "public_ip" {
  value = aws_instance.instance.public_ip
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}
