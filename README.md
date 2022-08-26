# Minecraft Terraform

Simple Minecraft server stack, Terraform edition. Deploys a VPC and a single-instance Vanilla Minecraft server into it.

## Usage

```bash
terraform login
terraform apply
# ...

(umask 0077; terraform output -raw ssh_private_key > key.pem)
ssh -i key.pem ec2-user@$(terraform output -raw public_ip)
```
