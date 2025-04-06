locals {
  region = "us-east-1"
  aws_tags = {
    "Terraform"   = "True"
    "Purpose"     = "Jenkins-infra"
    "Environment" = "Dev"
  }
  subnet_az1 = "us-east-1a"
  subnet_az2 = "us-east-1b"
  #Version of Kubernetes to be used for the EKS cluster
  eks_version = "1.30"
  #Only the below specific names are supported to create a cluster in kodekloud 
  eks_name          = "demo-eks"
  cluster_role_name = "eksClusterRole"
}
