output "ssh_private_key" {
  sensitive = true
  value     = module.minecraft_server.ssh_private_key
}

output "public_ip" {
  value = module.minecraft_server.public_ip
}

output "private_ip" {
  value = module.minecraft_server.private_ip
}
