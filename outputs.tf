output "ssh_private_key" {
  sensitive = true
  value     = module.minecraft_shared.private_key_pem
}

output "public_ip" {
  value = module.minecraft_server.public_ip
}

output "private_ip" {
  value = module.minecraft_server.private_ip
}

output "public_dns" {
  value = module.minecraft_server.public_dns
}
