output "vpc" {
  value = module.vpc
}

output "key_name" {
  value = aws_key_pair.keypair.key_name
}

output "private_key_pem" {
  sensitive = true
  value     = tls_private_key.keypair.private_key_pem
}

output "hosted_zone_id" {
  value = aws_route53_zone.rz.zone_id
}

output "hosted_zone_name" {
  value = aws_route53_zone.rz.name
}
