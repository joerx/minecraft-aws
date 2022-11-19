output "public_ip" {
  value = aws_eip.ip.public_ip
}

output "private_ip" {
  value = aws_instance.instance.private_ip
}

output "public_dns" {
  value = aws_route53_record.r.name
}
