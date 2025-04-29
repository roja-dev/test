output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "instance_ids" {
  description = "IDs of created EC2 instances"
  value       = aws_instance.ec2_instance[*].id
}

output "instance_public_ips" {
  description = "Public IPs of created EC2 instances"
  value       = aws_instance.ec2_instance[*].public_ip
}
