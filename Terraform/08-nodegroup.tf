#Create key pair contents for the nodes 
resource "tls_private_key" "random-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Save the content at a local location
resource "local_file" "save-key-pair" {
  content         = tls_private_key.random-key.private_key_openssh
  filename        = "${path.module}/node-key-pair.pem"
  file_permission = "0400"
}

#Create the given keypair in aws
resource "aws_key_pair" "node-key-pair" {
  key_name   = "node-key-pair"
  public_key = tls_private_key.random-key.public_key_openssh
}

#Call cloudformation with the yaml file 
resource "aws_cloudformation_stack" "nodegroup" {
  name = "eks-cluster-stack"
  #Get the kodekloud template hosted on s3 to be used in the cloudformation stack
  template_url = "https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2022-12-23/amazon-eks-nodegroup.yaml"

  #Pass the parameters to be called to the cloudformation
  parameters = {
    ClusterName                         = aws_eks_cluster.eks.name
    ClusterControlPlaneSecurityGroup    = aws_security_group.j-security-group.id
    NodeGroupName                       = "eks-demo-node"
    NodeAutoScalingGroupMinSize         = "2"
    NodeAutoScalingGroupDesiredCapacity = "2"
    NodeAutoScalingGroupMaxSize         = "2"
    NodeInstanceType                    = "t3.medium"
    NodeVolumeSize                      = "30"
    NodeVolumeType                      = "gp3"
    KeyName                             = aws_key_pair.node-key-pair.key_name
    VpcId                               = aws_vpc.main-vpc.id
    Subnets                             = join(",", data.aws_eks_cluster.eks_cluster.vpc_config[0].subnet_ids)
  }

  capabilities = ["CAPABILITY_NAMED_IAM"]
  depends_on   = [aws_eks_cluster.eks]
}