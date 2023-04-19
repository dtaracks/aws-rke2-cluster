output "masters_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = {for server in aws_instance.masters: server.id => server.public_ip}
}

output "workers_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = {for server in aws_instance.workers: server.id => server.public_ip}
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = ["${module.vpc.private_subnets.*}"]
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets.*}"]
}
