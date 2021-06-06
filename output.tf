output "instances_public_ip" {
  description = "Public IP address of the EC2 instances"
  value = module.ec2_instances.instances_public_ip
}