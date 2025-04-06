#Output instance details 

output "Master_pub_ip" {
  value = aws_eip.master-eip.public_ip
}

output "Slave_pub_ip" {
  value = aws_eip.slave-eip.public_ip
}

output "node_instance_role" {
  value = aws_cloudformation_stack.nodegroup.outputs["NodeInstanceRole"]
}

output "node_autoscaling_group" {
  value = aws_cloudformation_stack.nodegroup.outputs["NodeAutoScalingGroup"]
}

output "node_security_group" {
  value = aws_cloudformation_stack.nodegroup.outputs["NodeSecurityGroup"]
}